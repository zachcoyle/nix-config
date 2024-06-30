import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Rectangle {
  ClockWidget {
    id: clock
    anchors.right: notification_button.left
    anchors.rightMargin: 8
    anchors.verticalCenter: parent.verticalCenter
  }
  Button {
    id: notification_button
    background: Rectangle { opacity: 0; width: 32; height: 32 }
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    onClicked: swaync_client_toggle.running = true
    anchors.rightMargin: 24
    Text {
      color: "#ebdbb2"
      font.family: "Fira Sans Nerd Font"
      font.weight: Font.Black
      font.pixelSize: 32
      text: ""
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
    }
  }
  Process {
    id: swaync_client_toggle
    command: ["swaync-client", "-t"]
    running: false
  }
  anchors.right: parent.right
  anchors.verticalCenter: parent.verticalCenter
}
