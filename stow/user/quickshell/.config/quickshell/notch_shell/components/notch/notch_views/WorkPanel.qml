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

    Elements.WorkspaceOpener {
        notch: root.notch 
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 5
    }

    Elements.Divider { Layout.fillWidth: true }

    Elements.FocusTimer {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: 10
    }

    // Elements.Divider { Layout.fillWidth: true }

    // RowLayout {
    //     Layout.fillWidth: true
    //     Layout.margins: 5
    //     Item { Layout.fillWidth: true }
    //     Elements.IconButton {
    //         backgroundColor: "transparent"
    //         fontSize: 12
    //         icon: "home"
    //         button_enabled: true
    //         onActivate: () => root.notch.view = root.notch.defaultView
    //     }
    // }
} 