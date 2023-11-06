{pkgs}: let
  theme_colors = import ./colors.nix;
  createBar = {
    height ? "32",
    blur_radius ? "30",
    position ? "top",
    sticky ? "off",
    padding_left ? "10",
    padding_right ? "10",
    color ? "0x15ffffff",
    defaults ? {},
  }: let
    _defaults =
      pkgs.lib.recursiveUpdate {
        padding_left = "5";
        padding_right = "5";
        icon = {
          font = {
            name = "Hack Nerd Font";
            weight = "Bold";
            size = "17.0";
          };
          color = "0xffffffff";
          padding_left = "4";
          padding_right = "4";
        };
        label = {
          font = {
            name = "Hack Nerd Font";
            weight = "Bold";
            size = "14.0";
          };
          color = "0xffffffff";
          padding_left = "4";
          padding_right = "4";
        };
      }
      defaults;
  in ''
    sketchybar --bar height=${height} \
                     blur_radius=${blur_radius} \
                     position=${position} \
                     sticky=${sticky} \
                     padding_left=${padding_left} \
                     padding_right=${padding_right} \
                     color=${color}

    sketchybar --default icon.font="${_defaults.icon.font.name}:${_defaults.icon.font.weight}:${_defaults.icon.font.size}" \
                         icon.color="${_defaults.icon.color}" \
                         label.font="${_defaults.label.font.name}:${_defaults.label.font.weight}:${_defaults.label.font.size}" \
                         label.color="${_defaults.label.color}" \
                         padding_left=${_defaults.padding_left} \
                         padding_right=${_defaults.padding_right} \
                         label.padding_left=${_defaults.label.padding_left} \
                         label.padding_right=${_defaults.label.padding_right} \
                         icon.padding_left=${_defaults.icon.padding_left} \
                         icon.padding_right=${_defaults.icon.padding_right}

  '';
  createItem = {
    itemType ? "item",
    space ? null,
    name,
    side,
    background ? {},
    click_script ? null,
    icon ? null,
    label ? null,
    padding_left ? null,
    padding_right ? null,
    subscriptions ? null,
    update_freq ? null,
    script ? null,
  }: let
    _background =
      pkgs.lib.recursiveUpdate {
        color = null;
        corner_radius = null;
        height = null;
        drawing = null;
      }
      background;
  in ''
    sketchybar --add ${itemType} ${name} ${side} \
    --set ${name} ${
      if space == null
      then ""
      else "space=${space}"
    } ${
      if icon == null
      then "icon.drawing=off"
      else "icon=${icon}"
    } \
    ${
      if label == null
      then "label.drawing=off"
      else "label=${label}"
    } \
    ${
      if padding_left == null
      then ""
      else "padding_left=${padding_left}"
    } \
    ${
      if padding_right == null
      then ""
      else "padding_right=${padding_right}"
    } \
    ${
      if script == null
      then ""
      else "script=${script}/bin/${name}.sh"
    } \
    ${
      if subscriptions == null
      then ""
      else "--subscribe ${name} ${pkgs.lib.concatStringsSep " " subscriptions}"
    } \
    ${
      if update_freq == null
      then ""
      else "update_freq=${update_freq}"
    } \
    ${
      if _background.color == null
      then ""
      else "background.color=${_background.color}"
    } \
    ${
      if _background.corner_radius == null
      then ""
      else "background.corner_radius=${_background.corner_radius}"
    } \
    ${
      if _background.height == null
      then ""
      else "background.height=${_background.height}"
    } \
    ${
      if _background.drawing == null
      then "background.drawing=off"
      else ""
    } \
    ${
      if click_script == null
      then ""
      else ''click_script="${click_script}"''
    }
  '';
  bars = [
    (createBar {
      defaults = {
        color = theme_colors.bg;
        label = {
          font = {
            name = "Ubuntu Nerd Font";
          };
          color = theme_colors.fg;
        };
        icon = {
          color = theme_colors.fg;
        };
      };
    })
  ];
  items =
    (builtins.map (n:
      createItem rec {
        itemType = "space";
        space = n;
        name = "space.${n}";
        icon = n;
        side = "left";
        background = {
          color = theme_colors.bg_hard;
          corner_radius = "5";
          height = "20";
          drawing = "off";
        };
        # label.drawing = "off";
        script = pkgs.writeScriptBin "${name}.sh" ''
          sketchybar --set $NAME background.drawing=$SELECTED
        '';
        click_script = "yabai -m space --focus ${n}";
      }) ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"])
    ++ [
      (createItem {
        name = "space_separator";
        side = "left";
        icon = "";
        padding_left = "10";
        padding_right = "10";
      })
      (createItem rec {
        name = "front_app";
        side = "left";
        label = "";
        subscriptions = ["front_app_switched"];
        script = pkgs.writeScriptBin "${name}.sh" ''
          if [ "$SENDER" = "front_app_switched" ]; then
            sketchybar --set $NAME label="$INFO"
          fi
        '';
      })
      (createItem rec {
        name = "clock";
        side = "right";
        update_freq = "10";
        label = "";
        icon = "";
        script = pkgs.writeScriptBin "${name}.sh" ''
          sketchybar --set $NAME label="$(date '+%d/%m %H:%M')"
        '';
      })
      (createItem rec {
        name = "battery";
        side = "right";
        update_freq = "120";
        label = "";
        icon = "";
        script = pkgs.writeScriptBin "${name}.sh" ''
          PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
          CHARGING=$(pmset -g batt | grep 'AC Power')

          if [ $PERCENTAGE = "" ]; then
            exit 0
          fi

          case ''${PERCENTAGE} in
            9[0-9]|100) ICON=""
            ;;
            [6-8][0-9]) ICON=""
            ;;
            [3-5][0-9]) ICON=""
            ;;
            [1-2][0-9]) ICON=""
            ;;
            *) ICON=""
          esac

          if [[ $CHARGING != "" ]]; then
            ICON=""
          fi

          # The item invoking this script (name $NAME) will get its icon and label
          # updated with the current battery status
          sketchybar --set $NAME icon="$ICON" label="''${PERCENTAGE}%"
        '';
      })
      (createItem rec {
        name = "volume";
        side = "right";
        icon = "";
        label = "";
        subscriptions = ["volume_change"];
        script = pkgs.writeScriptBin "${name}.sh" ''
          if [ "$SENDER" = "volume_change" ]; then
            VOLUME=$INFO

            case $VOLUME in
              [6-9][0-9]|100) ICON="󰕾"
              ;;
              [3-5][0-9]) ICON="󰖀"
              ;;
              [1-9]|[1-2][0-9]) ICON="󰕿"
              ;;
              *) ICON="󰖁"
            esac

            sketchybar --set $NAME icon="$ICON" label="$VOLUME%"
          fi
        '';
      })
    ];
in {
  enable = true;
  extraPackages = [];
  config = ''
    ${builtins.concatStringsSep "\n" bars}

    ${builtins.concatStringsSep "\n" items}

    sketchybar --update
  '';
}
