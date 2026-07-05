{
  domain,
  config,
  lib,
  ...
}:

let
  searxFile = ../../../../secrets/hosts/server/searx.yaml;
in

{
  sops.secrets."searx/secret_key".sopsFile = searxFile;

  services = {
    caddy = {
      virtualHosts = {
        "search.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8887
        '';
      };
    };

    searx = {
      enable = true;
      redisCreateLocally = true;
      settings = {
        server = {
          base_url = "https://search.${domain}";
          bind_address = "0.0.0.0";
          port = 8887;
          secret_key = config.sops.secrets."searx/secret_key".path;
        };

        enabled_plugins = [
          "Tor check plugin"
          "Hostnames plugin"
        ];

        engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
          "startpage".disabled = true;
          "brave".disabled = true;
          "wikidata".disabled = true;
          "flickr".disabled = true;
          "brave.images".disabled = true;
          "duckduckgo images".disabled = true;
          "qwant images".disabled = true;
          "deviantart".disabled = true;
          "pexels".disabled = true;
          "artic".disabled = true;
          "unsplash".disabled = true;
          "openverse".disabled = true;
          "devicons".disabled = true;
          "lucide".disabled = true;
          "startpage images".disabled = true;
        };
      };
    };
  };
}
