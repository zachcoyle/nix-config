import { Workspaces } from "./workspaces.js";
import { togglePowerMenu } from "./powermenu.js";

export const Left = Widget.Box({
  children: [
    Widget.Button({
      className: "nixosButton",
      onClicked: togglePowerMenu,
      child: Widget.Icon({
        className: "nixosIcon",
        icon: App.configDir + "/nix-snowflake-colours.svg",
      }),
      // child: Widget.Label({
      //   label: "",
      // }),
    }),
    Widget.Button({
      className: "hyprlandButton",
      onClicked: togglePowerMenu,
      child: Widget.Label({
        label: "",
      }),
    }),
    Workspaces(),
  ],
});
