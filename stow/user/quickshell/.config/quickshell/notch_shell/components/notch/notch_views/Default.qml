import QtQuick
import QtQuick.Layouts
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView{
    id : notch_view
    RowLayout {
        spacing: 0
        Elements.Button {
            backgroundColor: "transparent"
            fontSize: 10
            icon: "search"
            button_enabled: true
            onActivate: () => notch_view.notch.setView('launcher')
        }
        Elements.Clock {
            size: 12
            format: "HH:mm"
        }
        Elements.Button {
            backgroundColor: "transparent"
            fontSize: 10
            icon: "settings"
            button_enabled: true
            onActivate: () => notch_view.notch.setView('controlPanel')
        }
    }
}
