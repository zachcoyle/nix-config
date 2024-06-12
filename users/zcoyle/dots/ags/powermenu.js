export const PowerMenu = Widget.Window({
  name: "powermenu",
  anchor: ["top", "left"],
  visible: false,
  child: Widget.Label({
    label: "powermenu",
  }),
});

export const togglePowerMenu = () => {
  PowerMenu.visible = !PowerMenu.visible;
};
