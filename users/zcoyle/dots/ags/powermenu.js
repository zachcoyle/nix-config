const entries = [
  {
    icon: "󰌾",
    extraClassName: "yellow",
    label: "Lock",
    action: ["hyprlock"],
  },
  {
    icon: "󰍃",
    extraClassName: "cyan",
    label: "Log out",
    action: ["hyprctl", "dispatch", "exit"],
  },
  {
    icon: "󱘲",
    extraClassName: "blue",
    label: "Hibernate",
    action: ["systemctl", "hibernate"],
  },
  {
    icon: "󰤄",
    extraClassName: "purple",
    label: "Suspend",
    action: ["systemctl", "suspend"],
  },
  {
    icon: "",
    extraClassName: "green",
    label: "Reboot",
    action: ["systemctl", "reboot"],
  },
  {
    icon: "󰐥",
    extraClassName: "red",
    label: "Power off",
    action: ["systemctl", "poweroff"],
  },
];

const PowerMenuItem = ({ icon, extraClassName, label, action }) =>
  Widget.Box({
    spacing: 0,
    homogeneous: false,
    vertical: false,
    children: [
      Widget.Button({
        className: "powerMenuItem",
        child: Widget.Overlay({
          passThrough: true,
          // child: Widget.Label({ label }),
          child: Widget.Box({
            children: [
              Widget.Label({ className: "powerMenuItemLabel", label }),
              Widget.Box({ hexpand: true }),
            ],
          }),
          overlays: [
            Widget.Box({
              children: [
                Widget.Label({
                  classNames: ["powerMenuItemIcon", extraClassName],
                  label: icon,
                }),
                Widget.Box({ hexpand: true }),
              ],
            }),
            Widget.Box({
              children: [
                Widget.Label({ className: "powerMenuItemLabel", label }),
                Widget.Box({ hexpand: true }),
              ],
            }),
          ],
        }),
        onClicked: () => {
          togglePowerMenu();
          Utils.execAsync(action);
        },
      }),
    ],
  });

const PowerMenu = Widget.Box({
  className: "powerMenu",
  spacing: 10,
  homogeneous: true,
  vertical: true,
  children: entries.map(({ icon, extraClassName, label, action }) =>
    PowerMenuItem({ icon, extraClassName, label, action }),
  ),
});

export const PowerMenuWindow = Widget.Window({
  name: "powermenu",
  anchor: ["top", "left"],
  visible: false,
  child: PowerMenu,
});

export const togglePowerMenu = () => {
  PowerMenuWindow.visible = !PowerMenuWindow.visible;
};
