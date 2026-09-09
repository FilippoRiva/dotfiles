import Quickshell
import Quickshell.Hyprland._FocusGrab
import "components/notch"

// wrapper for multi screen layout importing main components
ShellRoot{
  Variants {
    model: Quickshell.screens
    // qmllint disable uncreatable-type
    PanelWindow {
        property var modelData
        screen: modelData
        id: root
        focusable: true

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "transparent"

        Notch { 
          id: notch
          screen: root.screen
        }

        HyprlandFocusGrab {
            active: notch.isExpanded
            windows: [root]
        }

        mask: Region {
            item: notch
        }
    }
  }
}