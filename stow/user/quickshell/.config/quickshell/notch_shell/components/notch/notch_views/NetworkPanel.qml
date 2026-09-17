import QtQuick
import QtQuick.Layouts
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView {
    id: root
    spacing: 0
    focus: true

    Keys.onEscapePressed: (event) => {
        root.notch.setView('default')
        event.accepted = true
    }

    Elements.NetworkList {
        Layout.margins: 10
        notch: root.notch
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    RowLayout {
        Layout.fillWidth: true
        Elements.Divider { Layout.fillWidth: true }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.margins: 5
        Item { Layout.fillWidth: true }
        Elements.IconButton {
            backgroundColor: "transparent"
            fontSize: 12
            icon: "home"
            button_enabled: true
            onActivate: () => root.notch.setView('default')
        }
    }
}