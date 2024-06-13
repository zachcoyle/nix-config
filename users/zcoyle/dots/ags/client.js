const hyprland = await Service.import("hyprland");

export const ActiveClient = Widget.Box({
  className: "activeClient",
  spacing: 10,
  children: [
    Widget.Icon({
      className: "activeClientIcon",
      size: 32,
      icon: hyprland.active.client.bind("class"),
      visible: hyprland.active.client.bind("address").as((addr) => !!addr),
    }),
    Widget.Label({
      className: "activeClientLabel",
      label: hyprland.active.client.bind("title"),
      visible: hyprland.active.client.bind("address").as((addr) => !!addr),
    }),
  ],
});
