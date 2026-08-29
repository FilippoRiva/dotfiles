import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView{
    id : notch_view
    RowLayout {
        height: 10
        width: 10
        spacing: 0
        Elements.Clock {
            Layout.margins: 10
            size: 10
        }
        Elements.ViewSwitcher {
            notch : notch_view.notch
            view : notch_view.notch.expandedView
            viewName : "↓"
            Layout.rightMargin: 9
        }
    }
}
