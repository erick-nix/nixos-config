#!/usr/bin/env bash

# https://github.com/albertored11/dotfiles/blob/pc-nord/.local/bin/bright-notif

progname="$(basename "$0")"

usage() {
    echo "usage: $progname <up/down/set/off> [brightness %]" >&2
    exit 1
}

[[ "$#" -eq 1 || "$#" -eq 2 ]] || usage

# Exit if an instance of the script is already running to avoid errors
# It has to be somewhere in $PATH for this to work
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/$progname.lock"
flock -n 9 || exit 1

# Get bus number for all displays and number of displays
displays=$(ddcutil detect --terse | grep -F "I2C bus:" | awk -F '-' '{print $2}' || true)
n_displays=$(echo "$displays" | wc -w)

[[ "$n_displays" -gt 0 ]] || { echo "no displays found" >&2; exit 1; }

case "$1" in
    up)
        [[ -n "${2:-}" ]] || usage
        b="+ $2"
    ;;
    down)
        [[ -n "${2:-}" ]] || usage
        b="- $2"
    ;;
    set)
        [[ -n "${2:-}" ]] || usage
        b="$2"
    ;;
    off)
        # Turn off all displays
        # shellcheck disable=SC2016
        echo "$displays" | xargs -n1 -P"$n_displays" sh -c 'ddcutil setvcp d6 5 --bus "$1"' sh
        exit 0
    ;;
    *)
        usage
    ;;
esac

export BRIGHT_ARG="$b"

# shellcheck disable=SC2016
echo "$displays" | xargs -n1 -P"$n_displays" sh -c 'ddcutil setvcp 10 $BRIGHT_ARG --bus "$1"' sh
