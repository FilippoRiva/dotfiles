import Quickshell
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

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "transparent"

        Notch { 
          id: notch 
        }

        mask: Region {
            item: notch
        }
    }
  }
}