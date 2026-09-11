import QtQuick
import QtQuick.Layouts
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView {
    id: notch_view
    spacing: 0
    focus: true

    Keys.onEscapePressed: (event) => {
        notch_view.notch.view = notch_view.notch.defaultView
        event.accepted = true
    }

    RowLayout {
        Layout.margins: 10
        Layout.fillWidth: true
        Elements.MusicController {}
    }

    RowLayout {
        Layout.fillWidth: true
        Elements.Divider { Layout.fillWidth: true }
    }

    RowLayout {
        Layout.margins: 10
        Layout.alignment: Qt.AlignHCenter
        Elements.AudioController {}
    }

    RowLayout {
        Layout.fillWidth: true
        Elements.Divider { Layout.fillWidth: true }
    }

    RowLayout {
        Layout.margins: 10
        Layout.alignment: Qt.AlignHCenter
        Elements.Battery {}
        Elements.Battery {}
        Elements.Battery {}
        Elements.Battery {}
    }

    RowLayout {
        Layout.fillWidth: true
        Elements.Divider { Layout.fillWidth: true }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.margins: 5
        Elements.WorkspaceDots {}
        Item { Layout.fillWidth: true }
        Elements.IconButton {
            backgroundColor: "transparent"
            fontSize: 12
            icon: "home"
            button_enabled: true
            onActivate: () => notch_view.notch.view = notch_view.notch.defaultView
        }
    }
}