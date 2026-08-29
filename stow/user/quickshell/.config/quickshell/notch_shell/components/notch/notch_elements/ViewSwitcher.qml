import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import '../notch_elements' as Elements
import '.' as Views
import "../../.."

Elements.NotchElement {
    required property var notch
    required property Component view
    required property string viewName

    width: content.width
    height: content.height

    Rectangle {
        id: content

        width: 25
        height: 25
        radius: 15
        color: "transparent"

        scale: mouse.pressed ? 0.9 : 1

        Behavior on scale {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }

        Text {
            font.family: "Geistmono Nerd Font"
            anchors.centerIn: parent
            text: viewName
            color: Colors.color2
            font.pixelSize: 10
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                notch.view = view
            }
        }
    }
}