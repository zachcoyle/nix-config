const entries = [
  { icon: "", label: "Reboot", action: ["systemctl", "reboot"] },
  { icon: "", label: "Hibernate", action: ["systemctl", "hibernate"] },
  { icon: "", label: "Suspend", action: ["systemctl", "suspend"] },
  { icon: "", label: "Power off", action: ["systemctl", "poweroff"] },
  { icon: "", label: "Log out", action: ["hyprctl", "dispatch", "exit"] },
  { icon: "", label: "Lock", action: ["hyprlock"] },
];

const PowerMenuItem = ({ icon, label, action }) =>
  Widget.Box({
    spacing: 0,
    homogeneous: false,
    vertical: false,
    children: [
      Widget.Button({
        className: "powerMenuItem",
        child: Widget.Label({ label }),
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
  children: entries.map(({ icon, label, action }) =>
    PowerMenuItem({ icon, label, action }),
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
