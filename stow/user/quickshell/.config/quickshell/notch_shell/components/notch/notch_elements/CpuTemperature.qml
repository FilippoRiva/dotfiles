import './' as Elements
import QtQuick.Layouts
import Quickshell.Io
import QtQuick
import '../../../'

Elements.NotchElement {
    id: root
    implicitHeight: 30
    implicitWidth: 70

    property string font: "Jetbrains Mono"
    property string iconFont: "Material Symbols Rounded"
    property int pollInterval: 5000
    property string cpuTempPath: ""

    Process {
        id: cpuProbe
        stdout: StdioCollector {
            onStreamFinished: root.cpuTempPath = this.text.trim()
        }
    }

    FileView {
        id: cpuFile
        path: root.cpuTempPath
        printErrors: false
    }

    Timer {
        id: cpuTimer
        interval: root.pollInterval
        repeat: true
        onTriggered: cpuFile.reload()
    }

    property int cpuTemp: {
        let s = cpuFile.text().trim()
        return s === "" ? -1 : parseInt(s) / 1000
    }
    property string cpuText: root.cpuTemp < 0 ? "--" : root.cpuTemp + "°C"
    property string cpuColor: root.cpuTemp >= 85 ? Colors.color1 : Colors.foreground

    Component.onCompleted: {
        cpuProbe.exec(["sh", "-c", "for d in /sys/class/hwmon/hwmon*; do n=$(cat \"$d/name\" 2>/dev/null); case \"$n\" in coretemp|k10temp) echo \"$d/temp1_input\"; exit 0;; esac; done"])
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.background
        border.color: Colors.background2
        radius: 5

        RowLayout {
            anchors.fill: parent
            spacing: 0
            Text {
                font.family: root.iconFont
                text: "memory"
                font.pixelSize: 24
                color: root.cpuColor
            }
            Text {
                font.family: root.font
                text: root.cpuText
                font.pixelSize: 14
                Layout.fillWidth: true
                color: root.cpuColor
            }
        }
    }
}