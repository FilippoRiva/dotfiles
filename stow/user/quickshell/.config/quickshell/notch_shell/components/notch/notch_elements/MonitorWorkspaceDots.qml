pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland
import '.' as Elements
import "../../.."

Elements.NotchElement {
    id: root
    required property var monitor  // HyprlandMonitor

    width: content.width
    height: content.height

    property int refreshToken: 0

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() { root.refreshToken++ }
    }
    Connections {
        target: Hyprland.toplevels
        function onValuesChanged() { root.refreshToken++ }
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
                property var workspace: {
                    root.refreshToken
                    for (let ws of Hyprland.workspaces.values) {
                        if (ws.id === wsId) return ws
                    }
                    return null
                }
                property bool isActiveOnThisMonitor: workspace?.active && workspace?.monitor === root.monitor
                property bool isFocused: workspace?.focused ?? false
                property bool pulsePhase: false

                width: 8
                height: 8
                radius: 4
                color: {
                    if (isActiveOnThisMonitor) return pulsePhase ? Colors.color1 : Colors.foreground
                    if (workspace != null) return Colors.color2
                    return Colors.color6
                }

                Behavior on color {
                    ColorAnimation { duration: 350; easing.type: Easing.OutCubic }
                }

                Timer {
                    running: parent.isActiveOnThisMonitor
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
