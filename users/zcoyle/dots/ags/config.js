const audio = await Service.import("audio");
const hyprland = await Service.import("hyprland");
const battery = await Service.import("battery");
// const systemtray = await Service.import("systemtray");

const date = Variable("", {
  poll: [1000, 'date "+%I:%M %a %b %e"'],
});

const divide = ([total, free]) => free / total;

const cpu = Variable(0, {
  poll: [
    2000,
    "top -b -n 1",
    (out) =>
      divide([
        100,
        out
          .split("\n")
          .find((line) => line.includes("Cpu(s)"))
          .split(/\s+/)[1]
          .replace(",", "."),
      ]),
  ],
});

const ram = Variable(0, {
  poll: [
    2000,
    "free",
    (out) =>
      divide(
        out
          .split("\n")
          .find((line) => line.includes("Mem:"))
          .split(/\s+/)
          .splice(1, 2),
      ),
  ],
});

const CPUStats = Widget.Box({
  spacing: 0,
  children: [
    Widget.Label({
      className: "cpuIcon",
      label: "󰻠 ",
    }),
    Widget.Label({
      className: "cpu",
      label: cpu.bind().as((x) => Math.round(x).toString()),
    }),
    Widget.Label({
      className: "cpu",
      label: "%",
    }),
  ],
});

const RAMStats = Widget.Box({
  spacing: 0,
  children: [
    Widget.Label({
      className: "ramIcon",
      label: "󰍛 ",
    }),
    Widget.Label({
      className: "ram",
      label: ram.bind().as((x) => Math.round(x).toString()),
    }),
    Widget.Label({
      className: "ram",
      label: "%",
    }),
  ],
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

const ActiveClientIcon = Widget.Icon({
  className: "activeClientIcon",
  icon: hyprland.active.client.bind("class"),
  size: 24,
});

const ActiveClientTitle = Widget.Label({
  className: "activeClientTitle",
  truncate: "end",
  label: hyprland.active.client
    .bind("title")
    .as((title) => title.replace(" — Mozilla Firefox", "")),
  visible: hyprland.active.client.bind("address").as((addr) => !!addr),
});

const ActiveClientInfo = Widget.Box({
  className: "activeClientInfo",
  spacing: 10,
  homogeneous: false,
  vertical: false,
  children: [ActiveClientIcon, ActiveClientTitle],
});

const Workspaces = () => {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      .filter(({ id }) => id > 0)
      .map(({ id }) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label({
            className: activeId.as((i) =>
              i === id ? "workspaceLabelFocused" : "workspaceLabel",
            ),
            label: `${id}`,
          }),
          className: "workspaceButton",
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
  className: "notificationButton",
  child: Widget.Label({
    className: "notificationLabel",
    label: notificationCount.bind().as(getNotificationLabel),
  }),
  onClicked: () => Utils.execAsync("swaync-client -t -sw"),
  onSecondaryClick: () => Utils.execAsync("swaync-client -d -sw"),
});

const getBatteryLabel = (percentage) => {
  return `${Math.round(percentage)}%`;
};

const getBatteryIcon = (percentage) => {
  if (percentage > 95) {
    return " ";
  }
  if (percentage > 75) {
    return " ";
  }
  if (percentage > 45) {
    return " ";
  }
  if (percentage > 25) {
    return " ";
  }
  return " ";
};

function BatteryLabel() {
  const label = battery.bind("percent").as(getBatteryLabel);
  const icon = battery.bind("percent").as(getBatteryIcon);
  const isCharging = battery.bind("charging").as((isCharging) => isCharging);

  return Widget.Box({
    spacing: 4,
    children: [
      Widget.Label({
        className: "batteryChargingLabel",
        label: "󱐋",
        visible: isCharging,
      }),
      Widget.Label({
        className: "batteryIconLabel",
        label: icon,
      }),
      Widget.Label({
        className: "batteryPercentageLabel",
        label: label,
      }),
    ],
  });
}

const Date = Widget.Label({
  className: "date",
  label: date.bind(),
});

const Left = Widget.Box({
  className: "left",
  spacing: 10,
  homogeneous: false,
  vertical: false,
  children: [HyprlandButton, ActiveClientInfo],
});

const Middle = Widget.Box({
  className: "middle",
  spacing: 10,
  homogeneous: false,
  children: [Workspaces()],
});

// needs weather, [wifi & bluetooth or tray]

const Right = Widget.Box({
  className: "middle",
  spacing: 10,
  homogeneous: false,
  children: [
    Widget.Box({ hexpand: true }),
    CPUStats,
    RAMStats,
    BatteryLabel(),
    Date,
    Notifications,
  ],
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
