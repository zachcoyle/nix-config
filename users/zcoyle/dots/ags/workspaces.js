const hyprland = await Service.import("hyprland");

const focusedTitle = Widget.Label({
  label: hyprland.active.client.bind("title"),
  visible: hyprland.active.client.bind("address").as((addr) => !!addr),
});

const dispatch = (ws) => hyprland.messageAsync(`dispatch workspace ${ws}`);

export const Workspaces = () =>
  Widget.EventBox({
    onScrollUp: () => dispatch("+1"),
    onScrollDown: () => dispatch("-1"),
    child: Widget.Box({
      spacing: 8,
      children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
        Widget.Button({
          className: "workspaceButton",
          attribute: i,
          label: `${i}`,
          onClicked: () => dispatch(i),
        }),
      ),

      setup: (self) =>
        self.hook(hyprland, () =>
          self.children.forEach((btn) => {
            btn.visible = hyprland.workspaces.some(
              (ws) => ws.id === btn.attribute,
            );
          }),
        ),
    }),
  });
