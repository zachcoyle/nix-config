import { Bar } from "./bar.js";
import { PowerMenuWindow } from "./powermenu.js";
import {
  // NotificationCenter,
  NotificationPopups as NotificationPopups2,
} from "./notifications.js";
import { NotificationPopups } from "./notificationPopups.js";

const css = `/tmp/ags-style.css`;

const reloadCss = () => {
  const scss = App.configDir + "/style.scss";
  Utils.exec(`sass --no-source-map ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
};

reloadCss();

App.config({
  windows: [
    Bar,
    PowerMenuWindow,
    // NotificationCenter,
    NotificationPopups(),
  ],
});
