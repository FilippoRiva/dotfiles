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
        Layout.alignment: Qt.AlignHCenter
        Elements.AudioController {}
    }

    RowLayout {
        Layout.fillWidth: true
        Elements.WorkspaceDots {}
        Item { Layout.fillWidth: true }
        Elements.ViewSwitcher {
            viewName: "\u2191"
            view: notch_view.notch.defaultView
            notch: notch_view.notch
        }
    }
}