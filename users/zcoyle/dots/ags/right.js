import { NotificationButton } from "./notifications.js";

const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");

/** @param {import('types/service/systemtray').TrayItem} item */
const SysTrayItem = (item) =>
  Widget.Button({
    className: "systrayButton",
    child: Widget.Icon().bind("icon", item, "icon"),
    tooltipMarkup: item.bind("tooltip_markup"),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
  });

const SysTray = Widget.Box({
  spacing: 2,
  children: systemtray.bind("items").as((i) => i.map(SysTrayItem)),
});

const BatteryProgress = Widget.CircularProgress({
  child: Widget.Icon({
    // icon: battery.bind("icon_name"),
    icon: "battery",
  }),
  visible: battery.bind("available"),
  value: battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0)),
  class_name: battery.bind("charging").as((ch) => (ch ? "charging" : "")),
});

const Time = Widget.Label({
  className: "time",
  label: "",
});

Utils.interval(1000, () => {
  Time.label = Utils.exec('date "+%a %b %d %I:%M"');
});

export const Right = Widget.Box({
  spacing: 10,
  children: [
    Widget.Box({ hexpand: true }),
    BatteryProgress,
    Time,
    SysTray,
    NotificationButton,
  ],
});
