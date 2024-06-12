export const Notifications = Widget.Window({
  name: "notifications",
  anchor: ["top", "right"],
  child: Widget.Label({
    label: "Notifications",
  }),
  visible: true,
});

export const toggleNotifications = () => {
  Notifications.visible = !Notifications.visible;
};
