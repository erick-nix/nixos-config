set -euo pipefail

action="${1:-}"
step="${2:-10}"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/ddc-brightness"
bus_file="$cache_dir/buses"
target_file="$cache_dir/target"
worker_lock="$cache_dir/worker.lock"

mkdir -p "$cache_dir"

get_buses() {
  if [ -n "${DDC_BUSES:-}" ]; then
    printf '%s\n' "$DDC_BUSES"
    return 0
  fi

  if [ -s "$bus_file" ]; then
    cat "$bus_file"
    return 0
  fi

  local buses
  buses="$(ddcutil detect --brief 2>/dev/null \
    | sed -n 's|.*I2C bus: */dev/i2c-\([0-9]\+\).*|\1|p' \
    | tr '\n' ' ' \
    | sed 's/[[:space:]]*$//')"
  if [ -n "$buses" ]; then
    printf '%s\n' "$buses" > "$bus_file"
  fi
  printf '%s\n' "$buses"
}

clamp() {
  local n="$1"
  [ "$n" -lt 1 ] && n=1
  [ "$n" -gt 100 ] && n=100
  printf '%s\n' "$n"
}

read_current() {
  local first_bus="$1"
  ddcutil --bus "$first_bus" getvcp 10 --brief 2>/dev/null \
    | awk -F'current value = |, max value = ' 'NF>2 {print $2; exit}'
}

buses="$(get_buses)"
if [ -z "$buses" ]; then
  exit 1
fi

if [ ! -s "$target_file" ]; then
  first_bus="$(printf '%s\n' "$buses" | awk '{print $1}')"
  current="$(read_current "$first_bus" || true)"
  current="${current:-50}"
  clamp "$current" > "$target_file"
fi

current_target="$(cat "$target_file" 2>/dev/null || printf '50')"

case "$action" in
  up) next_target=$((current_target + step)) ;;
  down) next_target=$((current_target - step)) ;;
  set) next_target="$step" ;;
  *) exit 2 ;;
esac

next_target="$(clamp "$next_target")"
printf '%s\n' "$next_target" > "$target_file"

(
  exec 9>"$worker_lock"
  flock -n 9 || exit 0

  last=""
  while true; do
    desired="$(cat "$target_file" 2>/dev/null || printf '50')"
    [ "$desired" = "$last" ] && break
    last="$desired"

    buses_now="$(get_buses)"
    [ -z "$buses_now" ] && break

    for bus in $buses_now; do
      ddcutil \
        --bus "$bus" \
        --noverify \
        setvcp 10 "$desired" >/dev/null 2>&1 &
    done
    wait
  done

  pkill -u "$USER" -USR2 i3status-rs >/dev/null 2>&1 || true
) >/dev/null 2>&1 &
