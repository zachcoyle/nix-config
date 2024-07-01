import QtQuick
import Quickshell
import QtQuick.Controls

Rectangle {
  ClockWidget {
    id: clock
    anchors.right: parent.right
    anchors.rightMargin: 8
    anchors.verticalCenter: parent.verticalCenter
  }
  Button {
    text: "Ok"
    anchors.right: clock.left
  }
  anchors.right: parent.right
  anchors.verticalCenter: parent.verticalCenter
}
