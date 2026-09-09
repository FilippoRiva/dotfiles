pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland
import '.' as Elements
import "../../.."

Elements.NotchElement {
    id: root
    width: content.width
    height: content.height

    property int refreshToken: 0

    Connections {
        target: Hyprland.toplevels
        function onValuesChanged() { root.refreshToken++ }
    }
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() { root.refreshToken++ }
    }

    Row {
        id: content
        spacing: 4
        leftPadding: 6
        rightPadding: 6

        Repeater {
            model: 8

            Rectangle {
                required property int index
                property int wsId: index + 1
                property bool isActive: wsId === Hyprland.focusedWorkspace?.id
                property bool pulsePhase: false
                property bool hasWindows: {
                    root.refreshToken
                    for (let tl of Hyprland.toplevels.values) {
                        if (tl.workspace?.id === wsId) return true
                    }
                    return false
                }

                width: 8
                height: 8
                radius: 4
                color: {
                    if (isActive) return pulsePhase ? Colors.color1 : Colors.foreground
                    if (hasWindows) return Colors.color2
                    return Colors.color6
                }

                Behavior on color {
                    ColorAnimation { duration: 350; easing.type: Easing.OutCubic }
                }

                Timer {
                    running: parent.isActive
                    interval: 800
                    repeat: true
                    onTriggered: parent.pulsePhase = !parent.pulsePhase
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprland.dispatch("hl.dsp.focus({ workspace = " + parent.wsId + " })")
                    }
                }
            }
        }
    }
}