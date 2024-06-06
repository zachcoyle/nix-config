export const MiniStats = ({
  /** @type {string} */ label,
  /** @type {number} */ value,
}) =>
  Widget.Box({
    children: [
      Widget.Label({
        label,
        justification: "right",
      }),
      Widget.ProgressBar({
        value,
      }),
    ],
  });

export const Usage = Widget.Box({
  vertical: true,
  children: [
    MiniStats({
      label: "cpu",
      value: 0.5,
    }),
    MiniStats({
      label: "memory",
      value: 0.3,
    }),
    MiniStats({
      label: "disk",
      value: 0.7,
    }),
  ],
});
