import QtQuick
import QtQuick.Layouts
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView {
    id: notch_view
    spacing : 0

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Elements.Clock {
            Layout.margins: 10
        }
    }

    RowLayout {
        Layout.bottomMargin: 20
        Layout.alignment: Qt.AlignHCenter
        Elements.HyprlandWorkspace {}
        Elements.AppLauncher {
            appName: "zen"
            appCommand: "zen-browser"
        }
        Elements.AppLauncher {
            appName: "kitty"
            appCommand: "kitty"
        }
        Elements.AppLauncher {
            appName: "code"
            appCommand: "vscodium"
        }
        Elements.ViewSwitcher {
            viewName: "↑" 
            view: notch_view.notch.defaultView
            notch: notch_view.notch
        }
    }
}