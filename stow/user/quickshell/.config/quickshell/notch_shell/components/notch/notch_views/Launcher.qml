import QtQuick
import QtQuick.Layouts
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView {
    id: notch_view
    spacing : 0
    focus: true

    Keys.onEscapePressed: (event) => {
        notch_view.notch.setView('default')
        event.accepted = true
    }

    RowLayout {
        Layout.fillWidth: true
        Elements.Launcher {
            notch: notch_view.notch
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Elements.Divider { Layout.fillWidth: true }
    }

    RowLayout {
        Layout.topMargin: 0
        Layout.leftMargin: 5
        Layout.rightMargin: 5
        Layout.fillWidth: true
        Elements.WorkspaceDots {}
        Item { Layout.fillWidth: true }
        Elements.IconButton {
            backgroundColor: "transparent"
            fontSize: 12
            icon: "home"
            button_enabled: true
            onActivate: () => notch_view.notch.setView('default')
        }
    }
}