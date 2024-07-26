export const toggleNotifications = () => {};

const toggleDnd = () => {};

// const merged = Utils.merge(
//   [notifications.bind("notifications"), allowNotifications.bind()],
//   (n, a) => {
//     if (n.length === 0) {
//       return a ? "" : "";
//     }
//     return a ? "" : "";
//   },
// );

export const NotificationButton = Widget.Button({
  className: "notificationsButton",
  onClicked: toggleNotifications,
  onSecondaryClick: toggleDnd,
  onMiddleClick: () => {},
  child: Widget.Label({
    label: "",
  }),
});
