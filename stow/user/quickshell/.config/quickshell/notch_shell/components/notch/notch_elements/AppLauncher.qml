import Quickshell
import QtQuick
import '.' as Elements

Elements.NotchElement {
    required property string appName
    required property string appCommand

    width: content.width
    height: content.height

    Rectangle {
        id: content

        width: 50
        height: 50
        radius: 15
        color: "#302c38"

        scale: mouse.pressed ? 0.9 : 1

        Behavior on scale {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }

        Text {
            anchors.centerIn: parent
            font.family: "Geistmono Nerd Font"
            text: appName
            color: "white"
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                console.log("Launching " + appName)
                Quickshell.execDetached([appCommand])
            }
        }
    }
}