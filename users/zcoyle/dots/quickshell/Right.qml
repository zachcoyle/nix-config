import QtQuick
import Quickshell
import QtQuick.Controls

Rectangle {
  ClockWidget {
    id: clock
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.rightMargin: 8
  }
  Button {
    text: "Ok"
    anchors.right: clock.left
  }
  anchors.top: parent.top
  anchors.right: parent.right
  anchors.bottom: parent.bottom
}
