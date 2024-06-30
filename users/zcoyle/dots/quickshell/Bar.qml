import QtQuick
import Quickshell
import Quickshell.Io


Scope {
  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        color: "transparent"

        property var modelData
        screen: modelData

        anchors {
          top: true
          left: true
          right: true
        }

        height: 30

        ClockWidget {
          anchors.centerIn: parent
        }
      }
    }
  }
}
