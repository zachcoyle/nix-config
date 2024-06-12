import { Left } from "./left.js";
import { Center } from "./center.js";
import { Right } from "./right.js";

export const Bar = Widget.Window({
  name: "bar",
  anchor: ["top", "left", "right"],
  child: Widget.CenterBox({
    vertical: false,
    startWidget: Left,
    centerWidget: Center,
    endWidget: Right,
  }),
  exclusivity: "exclusive",
});
