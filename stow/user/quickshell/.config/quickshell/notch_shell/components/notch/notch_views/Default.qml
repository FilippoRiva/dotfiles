import QtQuick
import QtQuick.Layouts
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView{
    id : notch_view
    RowLayout {
        spacing: 0
        Elements.IconButton {
            backgroundColor: "transparent"
            fontSize: 10
            icon: "search"
            button_enabled: true
            onActivate: () => notch_view.notch.view = notch_view.notch.launcherView
        }
        Elements.Clock {
            size: 10
            format: "HH:mm"
        }
        Elements.IconButton {
            backgroundColor: "transparent"
            fontSize: 10
            icon: "settings"
            button_enabled: true
            onActivate: () => notch_view.notch.view = notch_view.notch.controlPanelView
        }
    }
}
