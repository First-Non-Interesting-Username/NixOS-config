{ inputs, ... }:
{
  flake = {
    nixosModules.browser =
      {
        lib,
        username,
        impermanence,
        ...
      }:
      {
        imports = lib.optional impermanence {
          environment.persistence."/persist" = {
            users.${username} = {
              directories = [
                ".mozilla"
                ".cache/mozilla"
              ];
            };
          };
        };

        home-manager.users.${username} =
          { pkgs, ... }:
          {
            stylix.targets.firefox = {
              enable = false;
            };

            xdg.mimeApps = {
              enable = true;
              defaultApplications = {
                "text/html" = "firefox.desktop";
                "text/xml" = "firefox.desktop";
                "application/xhtml+xml" = "firefox.desktop";
                "application/xml" = "firefox.desktop";
                "application/vnd.mozilla.xul+xml" = "firefox.desktop";
                "x-scheme-handler/http" = "firefox.desktop";
                "x-scheme-handler/https" = "firefox.desktop";
                "x-scheme-handler/ftp" = "firefox.desktop";
                "x-scheme-handler/chrome" = "firefox.desktop";
                "x-scheme-handler/about" = "firefox.desktop";
                "x-scheme-handler/unknown" = "firefox.desktop";
              };
            };

            home.sessionVariables = {
              BROWSER = "firefox";
              DEFAULT_BROWSER = "firefox";
            };

            xdg.configFile."mimeapps.list".force = true;

            programs = {
              firefox = {
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
                    "browser.tabs.closeWindowWithLastTab" = true;
                    "browser.startup.page" = 3;
                    "browser.urlbar.speculativeConnect.enabled" = false;
                    "network.http.max-persistent-connections-per-server" = 10;
                    "gfx.webrender.all" = true;
                    "layers.acceleration.force-enabled" = true;
                    "browser.search.suggest.enabled" = true;
                    "browser.urlbar.suggest.searches" = true;
                    "media.autoplay.default" = 0;
                    "media.autoplay.blocking_policy" = 0;
                    "browser.tabs.unloadOnLowMemory" = true;
                    "permissions.default.desktop-notification" = 2;
                    "sidebar.revamp" = true;
                    "browser.toolbar.bookmarks.visibility" = "never";
                  };
                };

                profiles.default = {
                  id = 0;
                  isDefault = true;

                  search = {
                    default = "ddg";
                    force = true;
                    engines = {
                      "NixOS Packages" = {
                        urls = [ { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; } ];
                        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                        updateInterval = 24 * 60 * 60 * 1000;
                        definedAliases = [
                          "@nixpkgs"
                          "@nix"
                          "@np"
                        ];
                      };
                      "NixOS Options" = {
                        urls = [ { template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; } ];
                        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                        updateInterval = 24 * 60 * 60 * 1000;
                        definedAliases = [
                          "@no"
                          "@nixoptions"
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
                    "sidebar.verticalTabs" = true;
                    "browser.sidebar.show" = true;
                    "browser.newtabpage.activity-stream.feeds.topsites" = false;
                    "browser.newtabpage.activity-stream.showSearchShortcuts" = false;
                    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                    "browser.newtabpage.activity-stream.feeds.discoverystreams" = false;
                    "browser.newtabpage.activity-stream.showSponsored" = false;
                    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                    "browser.ctrlTab.sortByRecentlyUsed" = true;
                    "signon.rememberSignons" = false;
                    "signon.autofillForms" = false;
                    "browser.toolbars.bookmarks.visibility" = "never";
                  };
                };
              };
            };
          };
      };
  };
}
