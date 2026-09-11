import './' as Elements
import QtQuick
import '../../../'

Elements.NotchElement {
    id: root

    required property string icon
    property bool button_enabled: true
    property var onActivate
    property string backgroundColor: Colors.background2
    property int fontSize: 18
    property string iconFont: "Material Symbols Rounded"

    width: content.width
    height: content.height

    Rectangle {
        id: content

        width: 25
        height: 25
        radius: 15
        color: root.backgroundColor

        scale: mouse.pressed ? 0.9 : 1

        Behavior on scale {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }

        Text {
            font.family: root.iconFont
            anchors.centerIn: parent
            text: root.icon
            color: root.button_enabled ? Colors.foreground : Colors.color6
            font.pixelSize: root.fontSize
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                if (root.button_enabled && root.onActivate) root.onActivate()
            }
        }
    }
}