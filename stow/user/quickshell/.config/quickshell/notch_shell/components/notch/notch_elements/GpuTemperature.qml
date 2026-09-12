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
    property bool gpuAvailable: false
    property int gpuTemp: -1

    visible: root.gpuAvailable

    Process {
        id: gpuProbe
        stdout: StdioCollector {
            onStreamFinished: root.gpuAvailable = this.text.trim() !== ""
        }
    }

    Process {
        id: gpuProc
        stdout: StdioCollector {
            onStreamFinished: root.gpuTemp = parseInt(this.text.trim())
        }
    }

    Timer {
        id: gpuTimer
        interval: root.pollInterval
        triggeredOnStart: true
        repeat: true
        running: root.gpuAvailable
        onTriggered: gpuProc.exec(["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"])
    }

    property string gpuText: root.gpuTemp < 0 ? "--" : root.gpuTemp + "°C"
    property string gpuColor: root.gpuTemp >= 85 ? Colors.color1 : Colors.foreground

    Component.onCompleted: {
        gpuProbe.exec(["sh", "-c", "command -v nvidia-smi"])
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.background
        border.color: Colors.background2
        radius: 5
        Layout.margins:  5

        RowLayout {
            anchors.fill: parent
            spacing: 0
            Text {
                Layout.margins:  5
                font.family: root.iconFont
                text: "thermostat"
                font.pixelSize: 24
                color: root.gpuColor
            }
            Text {
                font.family: root.font
                text: root.gpuText
                font.pixelSize: 14
                Layout.fillWidth: true
                color: root.gpuColor
            }
        }
    }
}