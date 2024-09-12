{ pkgs, ... }:
let
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    # darkreader
    dark-background-light-text
    dearrow
    firenvim
    keepassxc-browser
    nighttab
    passff
    react-devtools
    reddit-enhancement-suite
    sponsorblock
    stylus
    tridactyl
    ublock-origin
    user-agent-string-switcher
    vimium
    vue-js-devtools
    wayback-machine
  ];
in
{
  programs.firefox = {
    enable = true;

    profiles.apple_music = {
      id = 1;
      name = "apple_music";
      extensions = [ pkgs.nur.repos.rycee.firefox-addons.ublock-origin ];
    };
    profiles.zcoyle = {
      id = 0;
      name = "zcoyle";
      inherit extensions;

      search = {
        force = true;
        default = "Brave";
        engines =
          let
            updateInterval = 24 * 60 * 60 * 1000;
          in
          {
            Brave = {
              urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
              iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-search-icon.CsIFM2aN.svg";
              inherit updateInterval;
              definedAliases = [
                "@b"
                "@brave"
              ];
            };
            Youtube = {
              urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
              inherit updateInterval;
              definedAliases = [
                "@yt"
                "@youtube"
              ];
            };
            "Home Manager" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master";
                    }
                  ];
                }
              ];
              definedAliases = [ "@hm" ];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };
            "NixOS Wiki" = {
              urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              inherit updateInterval;
              definedAliases = [ "@nw" ];
            };
            Ollama = {
              urls = [ { template = "https://ollama.com/search?q={searchTerms}"; } ];
              iconUpdateURL = "https://ollama.com/public/icon-32x32.png";
              inherit updateInterval;
              definedAliases = [ "@ll" ];
            };
            "crates.io" = {
              urls = [ { template = "https://crates.io/search?q={searchTerms}"; } ];
              iconUpdateURL = "https://crates.io/favicon.ico";
              inherit updateInterval;
              definedAliases = [ "@crates" ];
            };
            NPM = {
              urls = [ { template = "https://www.npmjs.com/search?q={searchTerms}"; } ];
              iconUpdateURL = "https://static-production.npmjs.com/1996fcfdf7ca81ea795f67f093d7f449.png";
              inherit updateInterval;
              definedAliases = [ "@npm" ];
            };
            "Wikipedia (en)".metaData.alias = "@wiki";
            Google.metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            Bing.metaData.hidden = true;
            eBay.metaData.hidden = true;
          };
      };

      settings = {
        "general.smoothScroll" = true;
        # forbids sites from taking over keybinds
        "permissions.default.shortcuts" = 2;
        # disable alt key bringing up window menu
        "ui.key.menuAccessKeyFocuses" = false;
      };

      extraConfig = # javascript
        ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
          user_pref("apz.overscroll.enabled", true);
          user_pref("browser.shell.checkDefaultBrowser", false);
        '';

      userChrome = # css
        ''
          .titlebar-buttonbox-container {
            display: none !important;
          }
          #statuspanel {
            display: none !important;
          }
        '';

      userContent = '''';
    };
  };
}
