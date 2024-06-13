import { Workspaces } from "./workspaces.js";
import { togglePowerMenu } from "./powermenu.js";
import { ActiveClient } from "./client.js";

export const Left = Widget.Box({
  spacing: 10,
  children: [
    Widget.Button({
      className: "nixosButton",
      onClicked: togglePowerMenu,
      child: Widget.Icon({
        className: "nixosIcon",
        icon: App.configDir + "/nix-snowflake-colours.svg",
      }),
    }),
    Widget.Button({
      className: "hyprlandButton",
      onClicked: togglePowerMenu,
      child: Widget.Label({
        label: "",
      }),
    }),
    Workspaces(),
    ActiveClient,
  ],
});
