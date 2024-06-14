const notifications = await Service.import("notifications");

notifications.popupTimeout = 4000;
notifications.forceTimeout = false;
notifications.cacheActions = false;
notifications.clearDelay = 100;

const Notification = ({
  actions,
  appEntry,
  appIcon,
  appName,
  body,
  close,
  hints,
  id,
  image,
  popup,
  summary,
  time,
  urgency,
}) =>
  Widget.Box({
    name: `notification-${id}`,
    classNames: ["notificationBox", `urgency${urgency}`],
    children: [
      Widget.Box({
        children: [
          Widget.Overlay({
            child: Widget.Icon({
              size: 50,
              icon: appIcon,
            }),
            overlays: [
              Widget.Icon({
                size: 22,
                icon: image,
                visible: !!image && appIcon != image,
              }),
            ],
          }),
          Widget.Box({ vexpand: true }),
        ],
      }),
      Widget.Box({
        vertical: true,
        children: [
          Widget.Box({
            children: [
              Widget.Label({
                className: "notificationTitle",
                label: summary,
              }),
              Widget.Box({ hexpand: true }),
              Widget.Button({
                onClicked: close,
                child: Widget.Label({
                  label: "󰅘",
                }),
              }),
            ],
          }),
          Widget.Label({
            label: body,
            wrap: true,
            useMarkup: true,
            truncate: "end",
            xalign: 0,
            justification: "left",
          }),
          // action buttons
          Widget.Box({
            spacing: 8,
          }),
        ],
      }),
    ],
  });

// export const NotificationCenter = Widget.Window({
//   name: "notifications",
//   anchor: ["top", "right"],
//   visible: true,
//   child: Widget.Scrollable({
//     hscroll: "never",
//     vscroll: "automatic",
//     // rather make this dynamic, but works for now
//     css: "min-height: 925px;",
//     className: "notificationWindow",
//     child: Widget.Box({
//       vertical: true,
//       spacing: 8,
//       children: notifications.bind("notifications").as((ns) =>
//         ns.reverse().map((n) =>
//           Notification({
//             actions: n.bind("actions"),
//             appEntry: n.bind("app_entry"),
//             appIcon: n.bind("app_icon"),
//             appName: n.bind("app_name"),
//             body: n.bind("body"),
//             hints: n.bind("hints"),
//             id: n.bind("id"),
//             image: n.bind("image"),
//             popup: n.bind("popup"),
//             summary: n.bind("summary"),
//             time: n.bind("time"),
//             urgency: n.bind("urgency"),
//             close: () => n.close(),
//           }),
//         ),
//       ),
//     }),
//   }),
// });

export const toggleNotifications = () => {
  // NotificationCenter.visible = !NotificationCenter.visible;
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

export const NotificationPopups = Widget.Window({
  name: "notificationsPopupsWindow",
  anchor: ["top", "right"],
  visible: true,
  child: Widget.Scrollable({
    hscroll: "never",
    vscroll: "always",
    // rather make this dynamic, but works for now
    css: "min-height: 925px;",
    child: Widget.Box({
      vertical: true,
      spacing: 8,
      children: notifications.bind("notifications").as((ns) =>
        ns
          .filter((n) => !n.popup)
          .reverse()
          .map((n) =>
            Notification({
              actions: n.bind("actions"),
              appEntry: n.bind("app_entry"),
              appIcon: n.bind("app_icon"),
              appName: n.bind("app_name"),
              body: n.bind("body"),
              hints: n.bind("hints"),
              id: n.bind("id"),
              image: n.bind("image"),
              popup: n.bind("popup"),
              summary: n.bind("summary"),
              time: n.bind("time"),
              urgency: n.bind("urgency"),
              close: () => n.close(),
            }),
          ),
      ),
    }),
  }),
});
