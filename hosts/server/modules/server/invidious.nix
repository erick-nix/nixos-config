{
  domain,
  ...
}:

{
  services = {
    caddy = {
      virtualHosts = {
        "invidious.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:3001
        '';
      };
    };

    # Invidious
    invidious = {
      enable = true;
      port = 3001;
      domain = "invidious.${domain}";
      settings = {
        registration_enabled = false;

        invidious_companion = [
          { private_url = "http://127.0.0.1:8282/companion"; }
        ];

        default_user_preferences = {
          save_player_pos = true;
          feed_menu = [
            "Popular"
            "Subscriptions"
            "Playlists"
          ];
        };

        invidious_companion_key = "Sm4B0Rt4GKwiqnMF";
      };
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      # Run invidious companion in a docker container until deno packages are supported in
      # nixpkgs. Ref:
      # https://github.com/NixOS/nixpkgs/issues/415116#issuecomment-3326087868
      invidious-companion = {
        image = "quay.io/invidious/invidious-companion:latest";
        ports = [ "127.0.0.1:8282:8282" ];
        volumes = [
          "companioncache:/var/tmp/youtubei.js:rw"
        ];
        environment.SERVER_SECRET_KEY = "Sm4B0Rt4GKwiqnMF";
        extraOptions = [ "--pull=always" ];
      };
    };
  };
}
