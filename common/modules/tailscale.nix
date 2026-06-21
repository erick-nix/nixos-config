{
  hostname,
  ...
}:

let
  isServer = hostname == "server";
in

{
  services.tailscale = {
    enable = true;

    useRoutingFeatures = if isServer then "both" else "client";

    extraUpFlags =
      (
        if isServer then
          [
            "--advertise-routes=192.168.1.0/24"
          ]
        else
          [ ]
      )
      ++ [
        "--accept-routes"
      ];
  };
}
