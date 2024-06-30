import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Controls

Scope {
  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        // color: "transparent"
        color: "#80282828"

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
