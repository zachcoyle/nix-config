const mpris = await Service.import("mpris");

/** @param {import('types/service/mpris').MprisPlayer} player */
const Player = (player) =>
  Widget.Box({
    className: "player",
    spacing: 4,
    children: [
      Widget.Overlay({
        child: Widget.Icon({
          className: "albumArt",
          size: 42,
        }).hook(player, (icon) => {
          icon.icon = player.cover_path;
        }),
        overlays: [
          Widget.Button({
            className: "playPause",
            onClicked: () => player.playPause(),
            child: Widget.Label({
              label: "",
            }).hook(player, (label) => {
              const isPlaying = player.play_back_status === "Playing";
              label.label = isPlaying ? "󰏤" : "󰐊";
            }),
          }),
        ],
      }),
      Widget.Box({
        vertical: true,
        children: [
          Widget.Box({
            children: [
              Widget.Label({
                className: "artist",
                truncate: "end",
              }).hook(player, (label) => {
                const { track_title } = player;
                label.label = track_title;
              }),
              Widget.Box({ hexpand: true }),
            ],
          }),
          Widget.Box({
            children: [
              Widget.Label({
                className: "track",
                truncate: "end",
              }).hook(player, (label) => {
                const { track_artists } = player;
                label.label = `${track_artists.join(", ")}`;
              }),
              Widget.Box({ hexpand: true }),
            ],
          }),
        ],
      }),
    ],
  });

const Players = Widget.Box({
  spacing: 10,
  children: mpris.bind("players").as((p) => p.map(Player)),
});

export const Center = Widget.Box({
  children: [Players],
});
