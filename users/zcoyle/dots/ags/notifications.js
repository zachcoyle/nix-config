const notifications = await Service.import("notifications");

notifications.popupTimeout = 3000;
notifications.forceTimeout = false;
notifications.cacheActions = false;
notifications.clearDelay = 100;

export const Notifications = Widget.Window({
  name: "notifications",
  anchor: ["top", "right"],
  child: Widget.Box({
    children: [],
  }),
  visible: true,
});

export const toggleNotifications = () => {
  Notifications.visible = !Notifications.visible;
};

const allowNotifications = Variable(true);

const toggleDnd = () => {
  allowNotifications.setValue(!allowNotifications.value);
};

const merged = Utils.merge(
  [notifications.bind("notifications"), allowNotifications.bind()],
  (n, a) => {
    if (n.length === 0) {
      return a ? "" : "";
    }
    return a ? "" : "";
  },
);

export const NotificationButton = Widget.Button({
  className: "notificationsButton",
  onClicked: toggleNotifications,
  onSecondaryClick: toggleDnd,
  onMiddleClick: () => {
    /* clear notifications */
  },
  child: Widget.Label({
    label: merged,
  }),
});
