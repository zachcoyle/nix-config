import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Scope {
  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        // color: "transparent"
        // color: "#80282828"
        color: "#AF282828"

        property var modelData
        screen: modelData

        anchors {
          top: true
          left: true
          right: true
        }

        height: 40

        Left { }
        Center { }
        Right { }
      }
    }
  }
}
