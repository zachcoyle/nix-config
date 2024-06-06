const Workspace = ({ /** @type{string} */ name }) =>
  Widget.Box({
    children: [
      Widget.Label({
        label: name,
      }),
    ],
  });
