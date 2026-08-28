import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    property bool hovering : false

    width: hovering ? 600 : 200
    height: hovering ? 300 : 10

    anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
    }

    color: "#242129"
    bottomLeftRadius : 10
    bottomRightRadius : 10
    border.color: '#000000'

    ColumnLayout {
        z: 1
        anchors {
            top: parent. top
            horizontalCenter: parent.horizontalCenter
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Clock {
                visibleInNotch: hovering
                Layout.margins: 10
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            AppLauncher {
                appName: "Zen"
                appCommand: "zen-browser"
                visibleInNotch: hovering
            }
            AppLauncher {
                appName: "kitty"
                appCommand: "kitty"
                visibleInNotch: hovering
            }
            AppLauncher {
                appName: "code"
                appCommand: "vscodium"
                visibleInNotch: hovering
            }
        }
    }

    GlobalShortcut {
    name: "toggleNotch"

    onPressed: {
        hovering = Hyprland.focusedMonitor?.name === screen.name ? !hovering : hovering
    }
}

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: hovering = true
        onExited: hovering = false
    }

    Behavior on width {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }
}