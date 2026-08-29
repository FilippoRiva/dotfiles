import Quickshell
import QtQuick
import Quickshell.Hyprland
import '.' as Elements
import "../../.."

Elements.NotchElement {
    width: content.width
    height: content.height

    Rectangle {
        id: content

        width: 25
        height: 25
        color: "transparent"

        Text {
            font.family: "Geistmono Nerd Font"
            anchors.centerIn: parent
            text: Hyprland.focusedWorkspace?.id ?? "?"
            color: Colors.color2
            font.pixelSize: 10
        }
    }
}