{
  self,
  inputs,
  ...
}: {
  flake = {
    homeModules.browser = {
      pkgs,
      lib,
      config,
      ...
    }: {
      stylix.targets.floorp = {
        enable = false;
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "floorp.desktop";
          "text/xml" = "floorp.desktop";
          "application/xhtml+xml" = "floorp.desktop";
          "application/xml" = "floorp.desktop";
          "application/vnd.mozilla.xul+xml" = "floorp.desktop";
          "x-scheme-handler/http" = "floorp.desktop";
          "x-scheme-handler/https" = "floorp.desktop";
          "x-scheme-handler/ftp" = "floorp.desktop";
          "x-scheme-handler/chrome" = "floorp.desktop";
          "x-scheme-handler/about" = "floorp.desktop";
          "x-scheme-handler/unknown" = "floorp.desktop";
        };
      };

      home.sessionVariables = {
        BROWSER = "floorp";
        DEFAULT_BROWSER = "floorp";
      };

      xdg.configFile."mimeapps.list".force = true;

      programs = {
        floorp = {
          enable = true;

          languagePacks = [
            "en-US"
            "pl"
          ];

          policies = {
            DisableFirefoxAccounts = true;
            DisableAppUpdate = true;
            DontCheckDefaultBrowser = true;
            DisableSetDesktopBackground = true;
            DisableProfileImport = true;
            EnableWidevine = true;
            Preferences = {
              "browser.download.useDownloadDir" = true;
              "browser.download.alwaysOpenPanel" = false;
              "browser.tabs.warnOnClose" = false;
              "browser.tabs.closeWindowWithLastTab" = false;
              "browser.startup.page" = 3;
              "browser.urlbar.speculativeConnect.enabled" = false;
              "network.http.max-persistent-connections-per-server" = 10;
              "gfx.webrender.all" = true;
              "layers.acceleration.force-enabled" = true;
              "browser.search.suggest.enabled" = true;
              "browser.urlbar.suggest.searches" = true;
              "media.autoplay.default" = 0;
              "media.autoplay.blocking_policy" = 0;
            };
          };

          profiles.default = {
            id = 0;
            isDefault = true;

            search = {
              default = "ddg";
              force = true;
              engines = {
                "MyNixOS" = {
                  urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
                  icon = "https://mynixos.com/favicon.ico";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [
                    "@mn"
                    "@mynixos"
                  ];
                };

                "bing".metaData.hidden = true;
                "amazon".metaData.hidden = true;
              };
            };

            extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              ublock-origin
              darkreader
              vimium
              proton-pass
              sponsorblock
              violentmonkey
            ];

            settings = {
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

              "general.smoothScroll" = true;

              "datareporting.healthreport.uploadEnabled" = true;
              "toolkit.telemetry.enabled" = true;
            };
          };
        };
      };
    };
  };
}
