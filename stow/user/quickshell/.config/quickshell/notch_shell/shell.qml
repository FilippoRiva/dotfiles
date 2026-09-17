import Quickshell
import Quickshell.Hyprland._FocusGrab
import QtQuick
import "components/notch"

// wrapper for multi screen layout importing main components
ShellRoot{
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
          screen: panel.modelData
          panelWindow: panel
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

        // Masking
        mask: Region {
            item: notch
        }
    }
  }
}