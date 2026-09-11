import QtQuick
import Quickshell.Hyprland
import '.' as Elements
import "../../.."

Elements.NotchElement {
    id: root
    width: content.width
    height: content.height
    property int fontSize: 12 
    property string font: "Jetbrains Mono"

    Rectangle {
        id: content

        width: 25
        height: 25
        color: "transparent"
        scale: 1

        Text {
            id: label
            font.family: root.font
            anchors.centerIn: parent
            text: Hyprland.focusedWorkspace?.id ?? "?"
            color: Colors.color2
            font.pixelSize: root.fontSize

            property int prevId: Hyprland.focusedWorkspace?.id ?? 1

            onTextChanged: {
                let newId = Hyprland.focusedWorkspace?.id ?? 1
                if (newId > prevId) {
                    rotAnim.to = 360
                } else {
                    rotAnim.to = -360
                }
                prevId = newId
                switchAnimation.restart()
            }
        }

        ParallelAnimation {
            id: switchAnimation

            onFinished: label.rotation = 0

            SequentialAnimation {
                NumberAnimation {
                    target: label
                    property: "opacity"
                    to: 0
                    duration: 150
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: label
                    property: "opacity"
                    to: 1
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            NumberAnimation {
                id: rotAnim
                target: label
                property: "rotation"
                from: 0
                to: 360
                duration: 300
                easing.type: Easing.OutCubic
            }
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
                if ( mouseArea.pressedButtons == Qt.RightButton ) {
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