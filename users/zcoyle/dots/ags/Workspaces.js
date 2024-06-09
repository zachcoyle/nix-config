const hyprland = await Service.import("hyprland");

const Workspace = ({ /** @type {string} */ label }) =>
  Widget.Box({
    children: [
      Widget.Label({
        label,
      }),
    ],
  });

export const Workspaces = Widget.Box({
  children: [],
});
