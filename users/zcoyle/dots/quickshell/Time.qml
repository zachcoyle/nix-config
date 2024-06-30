pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  property var date: new Date()
  // property string time: date.toLocaleString(Qt.locale())
  property string time: date.toLocaleString('en-US', { timeZone: 'UTC-5' })

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: date = new Date()
  }
}
