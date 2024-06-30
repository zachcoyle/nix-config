import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Controls

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

        Left { }
        Center { }
        Right { }
      }
    }
  }
}
