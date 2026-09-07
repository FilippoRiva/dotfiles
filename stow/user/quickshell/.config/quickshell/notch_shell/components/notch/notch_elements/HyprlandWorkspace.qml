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
        scale: 1

        Text {
            font.family: "Geistmono Nerd Font"
            anchors.centerIn: parent
            text: Hyprland.focusedWorkspace?.id ?? "?"
            color: Colors.color2
            font.pixelSize: 10
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPressed: {
                click_animation.start() 
                let focused = Hyprland.focusedWorkspace?.id
                let max_workspaces = 8
                let next = (focused + 1 )% max_workspaces
                let prev = focused > 1 ? focused - 1 : max_workspaces
                console.log(Hyprland.focusedWorkspace)
                if ( mouseArea.pressedButtons == Qt.LeftButton ) {
                    Hyprland.dispatch("hl.dsp.focus({ workspace = "+ next +" })")
                } else {
                    Hyprland.dispatch("hl.dsp.focus({ workspace = "+ prev +" })")
                }
            }
        }

        SequentialAnimation {
            id: click_animation
            NumberAnimation {
                target: content
                property: "scale"
                from: 1
                to: 0
                duration: 100
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: content
                property: "scale"
                from: 0
                to: 1
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
    }
}