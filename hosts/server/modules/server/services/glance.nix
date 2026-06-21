{ config, domain, ... }:

{
  services = {
    # Glance
    glance = {
      enable = true;
      openFirewall = true;
      environmentFile = config.sops.secrets."glance/environment".path;

      settings.server.port = 3000;
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
                    type = "html";
                    source = ''
                      <div style="display: flex; justify-content: center; margin-bottom: 10px; color: rgb(76, 157, 255);">
                        <pre style="font-family: monospace; line-height: 1.1; font-size: 7px;">
                              _   ___    _
                              +o\  \  \  / \
                              \oo\  \  \/  /
                            ,oo+oo+oo\   ,/ +\
                          /oooooooooo\  \ /os;     Y88b Y88 ,e,            e88 88e    dP"8
                              /``/    \  ,oo/       Y88b Y8  "   Y8b Y8Y  d888 888b  C8b Y
                          ,─~─'  /      \,oooooo,   b Y88b Y 888   Y8b Y  C8888 8888D  Y8b
                          \__   ;s      /oo/sss\`   8b Y88b  888  e Y8b    Y888 888P  b Y8D
                            /  /so\____/ss/____     88b Y88b 888 d8b Y8b    "88 88"   8edP
                          `, / \oo\   ```     /
                            \/ /sooo\─~.  .─~─`
                              /so/\oo\  \  \
                              \o/  \s+\  \_/
                                    ```
                        </pre>
                      </div>
                    '';
                  }
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

                    url = "http://127.0.0.1:2283/api/server/statistics";

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

                    base-url = "http://127.0.0.1:8096";

                    options = {
                      url = "http://127.0.0.1:8096";
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
                        title = "Suwayomi";
                        url = "https://suwayomi.${domain}";
                        icon = "mdi:book-variant";
                      }
                      {
                        title = "Kanboard";
                        url = "https://kanboard.${domain}";
                        icon = "mdi:calendar-text";
                      }
                      {
                        title = "forgejo";
                        url = "https://git.${domain}";
                        icon = "si:forgejo";
                      }
                      {
                        title = "Bento PDF";
                        url = "https://bento.${domain}";
                        icon = "si:bento";
                      }
                      {
                        title = "Crafty";
                        url = "https://crafty.${domain}";
                        icon = "mdi:minecraft";
                      }
                      {
                        title = "Glances";
                        url = "https://status.${domain}";
                        icon = "mdi:monitor-dashboard";
                      }
                    ];
                  }
                  {
                    type = "lobsters";
                    hide-header = true;
                    sort-by = "hot";
                    tags = [
                      "nix"
                      "security"
                      "linux"
                      "web"
                      "culture"
                      "email"
                      "performance"
                      "c"
                      "rust"
                      "philosophy"
                      "education"
                    ];
                  }
                ];
              }

              {
                size = "small";
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
                    type = "rss";
                    hide-header = true;
                    title = "News";
                    style = "vertical-list";

                    feeds = [
                      {
                        url = "https://diolinux.com.br/feed";
                        title = "Diolinux";
                      }
                      {
                        url = "https://api.theregister.com/api/v1/article?query=tag:software&orderBy=published&site_id=2&remapper=rss&limit=25";
                        title = "The Register";
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
