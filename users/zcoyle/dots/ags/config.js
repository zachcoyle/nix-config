const audio = await Service.import("audio");
const hyprland = await Service.import("hyprland");
const battery = await Service.import("battery");
// const systemtray = await Service.import("systemtray");

const date = Variable("", {
  poll: [1000, 'date "+%H:%M:%S %b %e."'],
});

// const SysTray = () => {
//   const items = systemtray.bind("items").as((items) =>
//     items.map((item) =>
//       Widget.Button({
//         child: Widget.Icon({ icon: item.bind("icon") }),
//         on_primary_click: (_, event) => item.activate(event),
//         on_secondary_click: (_, event) => item.openMenu(event),
//         tooltip_markup: item.bind("tooltip_markup"),
//       }),
//     ),
//   );
//
//   return Widget.Box({
//     children: items,
//   });
// };

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
  truncate: "end",
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

const notificationCount = Variable(0, {
  listen: [["swaync-client", "-swb", "-sw"], (out) => JSON.parse(out)],
});

const getNotificationLabel = ({ text, alt }) => {
  if (alt === "dnd-none") {
    return "";
  }

  switch (text) {
    case "0":
      return "";
    default:
      return "🔔";
  }
};

const Notifications = Widget.Button({
  className: "",
  child: Widget.Label({
    className: "shadow",
    label: notificationCount.bind().as(getNotificationLabel),
  }),
  onClicked: () => Utils.execAsync("swaync-client -t -sw"),
  onSecondaryClick: () => Utils.execAsync("swaync-client -d -sw"),
});

const CPU = Widget.CircularProgress({});

const Date = Widget.Label({
  className: "shadow",
  label: date.bind(),
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

// needs battery, time, cpu, weather, [wifi & bluetooth or tray]

const Right = Widget.Box({
  className: "middle",
  spacing: 10,
  homogeneous: false,
  children: [Widget.Box({ hexpand: true }), Notifications],
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
