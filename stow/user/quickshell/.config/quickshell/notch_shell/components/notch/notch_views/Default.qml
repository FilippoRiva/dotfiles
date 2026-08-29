import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView{
    id : notch_view
    RowLayout {
        spacing: 0
        Elements.HyprlandWorkspace {
        }
        Elements.Clock {
            Layout.margins: 10
            size: 10
            format: "HH:mm"
        }
        Elements.ViewSwitcher {
            notch : notch_view.notch
            view : notch_view.notch.expandedView
            viewName : "↓"
        }
    }
}
