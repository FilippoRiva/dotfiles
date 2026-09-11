import '.' as Elements
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick
import '../../../'

Elements.NotchElement {
    id: root
    implicitHeight: 30
    implicitWidth: 300
    property string iconFont: "Material Symbols Rounded"

    RowLayout {
        anchors.fill: parent
        spacing: 8
        Text {
            font.family: root.iconFont
            text: Audio.value >= 0.5 ? "volume_up" : (Audio.value === 0 ? "volume_off" : "volume_down")
            font.pixelSize: 24
            color: Colors.foreground
        }
        Slider {
            id: slider
            Layout.fillWidth: true
            Layout.minimumWidth: 50
            from: 0
            to: 1
            value: Audio.value
            onMoved: {
                Audio.setVolume(position)
            }

            background: Rectangle {
                height: 4
                radius: 2
                color: Colors.color6
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: parent.width * (slider.value / slider.to)
                    height: parent.height
                    radius: 2
                    color: Colors.foreground
                }
            }

            handle: Rectangle {
                x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                implicitWidth: 12
                implicitHeight: 12
                radius: 6
                color: slider.pressed ? Colors.color6 : Colors.foreground
            }
        }
    }
}