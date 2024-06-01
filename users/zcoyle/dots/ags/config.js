const hyprland = await Service.import("hyprland");
const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");

const date = Variable("", {
  poll: [1000, 'date "+%I:%M %a %b %e"'],
});

const safelyParseWeatherJson = (/** @type {string} */ x) => {
  try {
    return JSON.parse(x);
  } catch (e) {
    return { text: "" };
  }
};

const wthr = Variable("", {
  poll: [
    300000,
    "wttrbar --ampm --location 'Hartford City' --main-indicator temp_F --fahrenheit --custom-indicator '{ICON} {temp_F}'",
    (w) => safelyParseWeatherJson(w).text + "°",
  ],
});

const wthrTip = Variable("", {
  poll: [
    300000,
    "wttrbar --ampm --location 'Hartford City' --main-indicator temp_F --fahrenheit --custom-indicator '{ICON} {temp_F}'",
    (w) => safelyParseWeatherJson(w).tooltip,
  ],
});

const Weather = Widget.Label({
  className: "weather",
  label: wthr.bind(),
  tooltipText: wthrTip.bind(),
});

const divide = ([total, free]) => free / total;

const disk = Variable(0, {
  poll: [
    2000,
    "duf -json",
    (out) => {
      const usage = JSON.parse(out).filter(
        ({ mount_point }) => mount_point === "/",
      )[0];

      return Math.round((usage.used / usage.total) * 100);
    },
  ],
});

const cpu = Variable("", {
  poll: [
    2000,
    "top -b -n 1",
    (/** @type {string} */ out) =>
      out
        .split("\n")
        .find((line) => line.includes("Cpu(s)"))
        .split(/\s+/)[1]
        .replace(",", "."),
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
  spacing: 8,
  children: [
    Widget.Label({
      className: "cpuIcon",
      label: "󰻠",
    }),
    Widget.Label({
      className: "cpu",
      label: cpu.bind().as((x) => Math.round(x).toString() + "%"),
    }),
  ],
});

const RAMStats = Widget.Box({
  spacing: 8,
  children: [
    Widget.Label({
      className: "ramIcon",
      label: "󰍛",
    }),
    Widget.Label({
      className: "ram",
      label: ram.bind().as((x) => Math.round(x * 100).toString() + "%"),
    }),
  ],
});

const DiskStats = Widget.Box({
  spacing: 8,
  children: [
    Widget.Label({
      className: "diskIcon",
      label: "󱛟",
    }),
    Widget.Label({
      className: "disk",
      label: disk.bind().as((x) => x.toString() + "%"),
    }),
  ],
});

const SysTray = () => {
  const items = systemtray.bind("items").as((items) =>
    items.map((item) =>
      Widget.Button({
        className: "trayButton",
        child: Widget.Icon({
          className: "trayIcon",
          icon: item.bind("icon"),
        }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind("tooltip_markup"),
      }),
    ),
  );

  return Widget.Box({
    children: items,
  });
};

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

const romanize = (/** @type {number} */ n) => {
  const numerals = {
    1: "I",
    2: "II",
    3: "III",
    4: "IV",
    5: "V",
    6: "VI",
    7: "VII",
    8: "VIII",
    9: "IX",
    10: "X",
  };
  return numerals[n] ?? n;
};

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
            label: romanize(id),
          }),
          className: "workspaceButton",
        }),
      ),
  );

  return Widget.EventBox({
    class_name: "workspaces",
    onScrollUp: () => hyprland.messageAsync(`dispatch workspace -1`),
    onScrollDown: () => hyprland.messageAsync(`dispatch workspace +1`),
    child: Widget.Box({
      class_name: "workspaces",
      children: workspaces,
    }),
  });
};

const yubikeyNeedsAttention = Variable(false, {
  listen: [["yubikey-touch-detector", "-stdout"], (out) => out === "U2F_1"],
});

const YubikeyNeedsAttention = Widget.Icon({
  icon: "./cat.gif",
  size: 30,
});

const notificationCount = Variable(0, {
  listen: [["swaync-client", "-swb", "-sw"], (out) => JSON.parse(out)],
});

const getNotificationLabel = ({ text, alt }) => {
  if (alt === "dnd-none") {
    return "";
  }

  if (alt === "dnd-notification") {
    return "";
  }

  switch (text) {
    case "0":
      return "";
    default:
      return "";
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

const getBatteryLabel = (/** @type {number} */ percentage) => {
  return `${Math.round(percentage)}%`;
};

const getBatteryIcon = (/** @type {number} */ percentage) => {
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
    className: label === "-1%" ? "" : "",
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

const Right = Widget.Box({
  className: "middle",
  spacing: 10,
  homogeneous: false,
  children: [
    ...[Widget.Box({ hexpand: true }), Weather, CPUStats, RAMStats, DiskStats],
    ...(battery.available ? [BatteryLabel()] : []),
    ...[Date, SysTray()],
    ...(yubikeyNeedsAttention.value === true ? [YubikeyNeedsAttention] : []),
    ...[Notifications],
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
