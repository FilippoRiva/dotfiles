import Quickshell
import QtQuick
import Quickshell.Hyprland
import '.' as Elements

Elements.NotchElement {
    width: content.width
    height: content.height

    Rectangle {
        id: content

        width: 25
        height: 25
        radius: 15
        color: "#302c38"

        Text {
            anchors.centerIn: parent
            text: Hyprland.focusedWorkspace?.id ?? "?"
            color: "white"
            font.pixelSize: 10
        }
    }
}