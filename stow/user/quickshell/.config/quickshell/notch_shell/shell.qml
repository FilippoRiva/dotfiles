import Quickshell
import Quickshell.Hyprland
import Quickshell.Hyprland._FocusGrab
import QtQuick
import "components/notch"
import "components/notch/notch_elements" as Elements

// wrapper for multi screen layout importing main components
ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens
        // qmllint disable uncreatable-type
        PanelWindow {
            id: panel

            property var modelData
            property var exclusive: true
            color: "transparent"

            // Positioning
            screen: modelData
            implicitHeight: modelData.height // occupies entire height

            anchors {
                top: true
                left: true
                right: true
            }

            exclusiveZone: exclusive ? 25 : 0

            // Notch
            Notch {
                id: notch
                anchors {
                    top: parent.top
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                }
                screen: panel.modelData
                panelWindow: panel
            }

            // Workspace bar (top-left, aligned with notch)
            Rectangle {
                id: workspaceBar
                anchors {
                    top: parent.top
                    topMargin: 5
                    left: parent.left
                    leftMargin: 10
                }
                color: Colors.background
                border.color: Colors.background2
                radius: 10
                width: workspaceDots.width + 20
                height: 24

                transform: Translate {
                    y: notch.hidden && notch.view == notch.defaultView ? -40 : 0

                    Behavior on y {
                        NumberAnimation {
                            duration: notch.animationSpeed
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Elements.MonitorWorkspaceDots {
                    id: workspaceDots
                    monitor: Hyprland.monitorFor(panel.modelData)
                    anchors.centerIn: parent
                }
            }

            // Focus
            focusable: true
            Connections {
                target: panel.contentItem
                function onActiveFocusItemChanged() {
                    if (!panel.contentItem.activeFocusItem && notch.isExpanded) {
                        notch.setView('default')
                    }
                }
            }
            HyprlandFocusGrab {
                active: notch.isExpanded
                windows: [panel]
            }

            // Masking — covers both notch and workspace bar
            mask: Region {
                item: maskContainer
            }

            Item {
                id: maskContainer
                x: 0
                y: Math.min(notch.y, workspaceBar.y)
                width: panel.width
                height: Math.max(notch.y + notch.height, workspaceBar.y + workspaceBar.height) - y
            }
        }
    }
}
