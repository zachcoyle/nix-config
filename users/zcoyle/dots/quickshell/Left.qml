import QtQuick
import QtQuick.Controls
import Quickshell

Rectangle {
  id: left
  Button {
    id: b1
    icon.name: "nix"
    icon.source: "nix.svg"
    icon.width: 26
    icon.height: 26
    background: Rectangle { opacity: 0 }
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
  }
  Button {
    icon.name: "hyprland"
    icon.source: "hyprland.svg"
    icon.width: 20
    icon.height: 26
    background: Rectangle { opacity: 0 }
    anchors.left: b1.right
    anchors.verticalCenter: parent.verticalCenter
  }
  anchors.top: parent.top
  anchors.left: parent.left
  anchors.bottom: parent.bottom
}
