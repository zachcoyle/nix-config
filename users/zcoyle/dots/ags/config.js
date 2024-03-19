// @ts-ignore (top-level await)
const audio = await Service.import("audio");
// @ts-ignore (top-level await)
const hyprland = await Service.import("hyprland");
// @ts-ignore (top-level await)
const battery = await Service.import("battery");

const hyprlandButton = Widget.Button({
  className: "hyprlandButton",
  child: Widget.Label({
    className: "hyprlandLogo",
    label: "",
  }),
  onClicked: () => Utils.execAsync("wlogout"),
});

const focusedWindowIcon = Widget.Icon({
  icon: hyprland.active.client.bind("class"),
  size: 24,
});

const focusedWindowTitle = Widget.Label({
  className: "focusedWindowTitle",
  label: hyprland.active.client.bind("title"),
  visible: hyprland.active.client.bind("address").as((addr) => !!addr),
});

const focusedWindowInfo = Widget.Box({
  className: "focusedWindowInfo",
  spacing: 10,
  homogeneous: false,
  vertical: false,
  children: [focusedWindowIcon, focusedWindowTitle],
});

const workspaces = Widget.Box({
  className: "workspaces",
  spacing: 8,
  homogeneous: true,
  vertical: false,
  children: [],
});

const left = Widget.Box({
  className: "left",
  spacing: 10,
  homogeneous: false,
  vertical: false,
  children: [hyprlandButton, focusedWindowInfo, workspaces],
});

const topBar = Widget.Window({
  name: "bar",
  anchor: ["top", "left", "right"],
  child: left,
  exclusivity: "exclusive",
});

App.config({
  windows: [topBar],
  style: "./style.css",
});
