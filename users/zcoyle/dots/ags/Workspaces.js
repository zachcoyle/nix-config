const WorkspaceButton = ({
  /** @type{number} */ id,
  /** @type{string} */ label,
}) => Widget.Button({});

const Workspace = ({ /** @type{number} */ id, /** @type{string} */ label }) =>
  Widget.Box({
    children: [
      Widget.Label({
        label,
      }),
    ],
  });

const Workspaces2Inner = Widget.Box({});

export const Workspaces2 = ({}) =>
  Widget.EventBox({
    child: Workspaces2Inner,
  });
