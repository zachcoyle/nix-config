const audio = await Service.import("audio");
const hyprland = await Service.import("hyprland");
const battery = await Service.import("battery");

const HyprlandButton = Widget.Button({
  className: "hyprlandButton",
  child: Widget.Label({
    className: "hyprlandLogo",
    label: "",
  }),
  onClicked: () => Utils.execAsync("wlogout"),
});

const FocusedWindowIcon = Widget.Icon({
  className: "focusedWindowIcon",
  icon: hyprland.active.client.bind("class"),
  size: 24,
});

const FocusedWindowTitle = Widget.Label({
  classNames: ["focusedWindowTitle", "shadow"],
  label: hyprland.active.client
    .bind("title")
    .as((title) => title.replace(" — Mozilla Firefox", "")),
  visible: hyprland.active.client.bind("address").as((addr) => !!addr),
});

const FocusedWindowInfo = Widget.Box({
  className: "focusedWindowInfo",
  spacing: 10,
  homogeneous: false,
  vertical: false,
  children: [FocusedWindowIcon, FocusedWindowTitle],
});

const Workspaces = () => {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      .filter(({ id }) => id > 0)
      .map(({ id }) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name: activeId.as((i) =>
            i === id ? "workspaceButtonFocused" : "workspaceButton",
          ),
        }),
      ),
  );

  return Widget.EventBox({
    class_name: "workspaces",
    onScrollUp: () => {},
    onScrollDown: () => {},
    child: Widget.Box({
      class_name: "workspaces",
      children: workspaces,
    }),
  });
};

const Notifications = Widget.Button({
  className: "",
  child: Widget.Label({ label: "" }),
  onClicked: () => Utils.execAsync("swaync-client -t -sw"),
  onSecondaryClick: () => Utils.execAsync("swaync-client -d -sw"),
});

const BatteryProgress = Widget.CircularProgress({
  child: Widget.Icon({
    icon: battery.bind("icon_name"),
  }),
  visible: battery.bind("available"),
  value: battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0)),
  class_name: battery.bind("charging").as((ch) => (ch ? "charging" : "")),
});

const Left = Widget.Box({
  className: "left",
  spacing: 10,
  homogeneous: false,
  vertical: false,
  children: [HyprlandButton, FocusedWindowInfo],
});

const Middle = Widget.Box({
  className: "middle",
  spacing: 10,
  homogeneous: false,
  children: [Workspaces()],
});

const Right = Widget.Box({
  className: "middle",
  spacing: 10,
  homogeneous: false,
  children: [BatteryProgress, Notifications],
});

const Bar = Widget.Window({
  name: "bar",
  anchor: ["top", "left", "right"],
  child: Widget.CenterBox({
    start_widget: Left,
    center_widget: Middle,
    end_widget: Right,
  }),
  exclusivity: "exclusive",
});

App.config({
  windows: [Bar],
  style: "./style.css",
});

export {};
