{ config, domain, ... }:

let
  glanceFile = ../../../../secrets/hosts/server/glance.yaml;
in

{
  sops.secrets."glance/environment".sopsFile = glanceFile;

  services = {
    caddy = {
      virtualHosts = {
        "home.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8026
        '';
      };
    };

    glance = {
      enable = true;
      openFirewall = true;
      environmentFile = config.sops.secrets."glance/environment".path;

      settings.server.port = 8026;
      settings.server.host = "0.0.0.0";

      settings.theme = {
        background-color = "240 10 12";
        contrast-multiplier = 1.1;
        primary-color = "213 100 65";
        positive-color = "140 60 45";
        negative-color = "0 75 60";
      };

      settings = {
        pages = [
          {
            name = "Home";
            hide-desktop-navigation = true;
            head-widgets = [
              {
                type = "html";
                source = ''
                  <div style="margin-top: 40px;"></div>
                '';
              }
            ];

            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "calendar";
                    first-day-of-week = "monday";
                    hide-header = true;
                  }
                  {
                    type = "custom-api";
                    hide-header = true;
                    title = "Immich stats";
                    cache = "1d";

                    url = "https://immich.${domain}/api/server/statistics";

                    headers = {
                      x-api-key = "ijzOu0kbvn2wJDnwVB4VtqHkUkj9uPLWHHlcLcQrFto";
                      Accept = "application/json";
                    };

                    template = ''
                      <div class="flex justify-between text-center">
                        <div>
                            <div class="color-highlight size-h3">{{ .JSON.Int "photos" | formatNumber }}</div>
                            <div class="size-h6">PHOTOS</div>
                        </div>
                        <div>
                            <div class="color-highlight size-h3">{{ .JSON.Int "videos" | formatNumber }}</div>
                            <div class="size-h6">VIDEOS</div>
                        </div>
                        <div>
                            <div class="color-highlight size-h3">{{ div (.JSON.Int "usage" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
                            <div class="size-h6">USAGE</div>
                        </div>
                      </div>
                    '';
                  }
                  {
                    type = "custom-api";
                    hide-header = true;
                    title = "Jellyfin/Emby Stats";

                    base-url = "https://jellyfin.${domain}";

                    options = {
                      url = "https://jellyfin.${domain}";
                      key = "37229b99c8f346e7b4255d7d4ac56206";
                    };

                    template = ''
                      {{ $url := .Options.StringOr "url" "" }}
                      {{ $key := .Options.StringOr "key" "" }}

                      {{- if or (eq $url "") (eq $key "") -}}
                        <p>Error: API Key não configurada</p>
                      {{- else -}}

                        {{- $requestUrl := printf "%s/emby/Items/Counts?api_key=%s" $url $key -}}
                        {{- $jellyfinData := newRequest $requestUrl | getResponse -}}

                        {{- if eq $jellyfinData.Response.StatusCode 200 -}}
                          <div class="flex justify-between text-center">
                            
                            <div>
                              <div class="color-highlight size-h3">{{ $jellyfinData.JSON.Int "MovieCount" }}</div>
                              <div class="size-h6">Movies</div>
                            </div>

                            <div>
                              <div class="color-highlight size-h3">{{ $jellyfinData.JSON.Int "SeriesCount" }}</div>
                              <div class="size-h6">Series</div>
                            </div>

                            <div>
                              <div class="color-highlight size-h3">{{ $jellyfinData.JSON.Int "EpisodeCount" }}</div>
                              <div class="size-h6">Episodes</div>
                            </div>

                          </div>
                        {{- else -}}
                          <p>Erro: {{ $jellyfinData.Response.Status }}</p>
                        {{- end -}}
                      {{- end -}}
                    '';
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "server-stats";
                    hide-header = true;
                    servers = [
                      {
                        type = "local";
                      }
                    ];
                  }
                  {
                    type = "monitor";
                    hide-header = true;
                    cache = "1m";

                    sites = [
                      {
                        title = "Vaultwarden";
                        url = "https://vault.${domain}";
                        icon = "si:bitwarden";
                      }
                      {
                        title = "Syncthing";
                        url = "https://syncthing.${domain}";
                        icon = "si:syncthing";
                      }
                      {
                        title = "Traccar";
                        url = "https://traccar.${domain}";
                        icon = "si:traccar";
                      }
                      {
                        title = "Immich";
                        url = "https://immich.${domain}";
                        icon = "si:immich";
                      }
                      {
                        title = "Jellyfin";
                        url = "https://jellyfin.${domain}";
                        icon = "si:jellyfin";
                      }
                      {
                        title = "FreshRSS";
                        url = "https://rss.${domain}";
                        icon = "si:freshrss";
                      }
                      {
                        title = "Suwayomi";
                        url = "https://suwayomi.${domain}";
                        icon = "mdi:book-variant";
                      }
                      {
                        title = "Invidious";
                        url = "https://invidious.${domain}";
                        icon = "si:invidious";
                      }
                      {
                        title = "Kanboard";
                        url = "https://kanboard.${domain}";
                        icon = "mdi:calendar-text";
                      }
                      {
                        title = "Frigate";
                        url = "https://frigate.${domain}";
                        icon = "si:frigate";
                      }
                      {
                        title = "Forgejo";
                        url = "https://git.${domain}";
                        icon = "si:forgejo";
                      }
                      {
                        title = "Bento PDF";
                        url = "https://bento.${domain}";
                        icon = "si:bento";
                      }
                      {
                        title = "Romm";
                        url = "https://rom.${domain}";
                        icon = "mdi:controller";
                      }
                      {
                        title = "Translate";
                        url = "https://translate.${domain}";
                        icon = "si:libretranslate";
                      }
                      {
                        title = "Status";
                        url = "https://status.${domain}";
                        icon = "mdi:pulse";
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
