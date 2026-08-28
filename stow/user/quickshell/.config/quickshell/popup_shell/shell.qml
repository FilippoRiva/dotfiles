import Quickshell

// wrapper for multi screen layout
ShellRoot{
  Variants {
    model: Quickshell.screens
    Overlay {
      property var modelData
      screen: modelData
    }
  }
}