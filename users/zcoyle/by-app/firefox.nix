{ pkgs, ... }:
let
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    dark-background-light-text
    darkreader
    dearrow
    firenvim
    keepassxc-browser
    nighttab
    passff
    react-devtools
    reddit-enhancement-suite
    sponsorblock
    stylus
    ublock-origin
    user-agent-string-switcher
    vimium
    vue-js-devtools
    wayback-machine
  ];
in
{
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
      engines = {
        Brave = {
          urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
          iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-search-icon.CsIFM2aN.svg";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [
            "@b"
            "@brave"
          ];
        };
        Youtube = {
          urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
          updateInterval = 24 * 60 * 60 * 1000;
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
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@nw" ];
        };
        Ollama = {
          urls = [ { template = "https://ollama.com/search?q={searchTerms}"; } ];
          iconUpdateURL = "https://ollama.com/public/icon-32x32.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@ll" ];
        };
        NPM = {
          urls = [ { template = "https://www.npmjs.com/search?q={searchTerms}"; } ];
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
}
