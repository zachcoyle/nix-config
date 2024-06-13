import { NotificationButton } from "./notifications.js";

export const Right = Widget.Box({
  children: [Widget.Box({ hexpand: true }), NotificationButton],
});
