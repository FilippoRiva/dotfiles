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
    Connections {
        target: Hyprland.workspaces
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
                property bool hasWindows: {
                    root.refreshToken
                    for (let tl of Hyprland.toplevels.values) {
                        if (tl.workspace?.id === wsId) return true
                    }
                    return false
                }
                property bool isAssignedToThisMonitor: workspace?.monitor?.name === root.monitor?.name
                property bool isActiveOnThisMonitor: workspace?.active && isAssignedToThisMonitor
                property bool isFocused: workspace?.focused ?? false
                property bool pulsePhase: false

                visible: isAssignedToThisMonitor

                width: {
                  if (isActiveOnThisMonitor) return 8
                  return 8
                }
                height: 8
                radius: 4
                color: {
                    if (isActiveOnThisMonitor) return Colors.foreground
                    if (workspace != null & hasWindows) return Colors.color2
                    return Colors.color6
                }

                Behavior on width {
                    NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
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
