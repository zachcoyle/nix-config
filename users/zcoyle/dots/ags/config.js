import { Bar } from "./bar.js";
import { PowerMenu } from "./powermenu.js";
import { Notifications } from "./notifications.js";

const css = `/tmp/ags-style.css`;

const reloadCss = () => {
  const scss = `${App.configDir}/style.scss`;
  Utils.exec(`sass --no-source-map ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
};

reloadCss();

App.config({
  windows: [Bar, PowerMenu, Notifications],
});
