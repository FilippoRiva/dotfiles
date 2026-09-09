pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import Quickshell
import "notch_views" as Views
import "../../"

Rectangle {
    id: notch_root
    clip: true
    property int animationSpeed: 300
    required property ShellScreen screen

    // Positioning
    anchors {
        top: parent.top
        topMargin: 5
        horizontalCenter: parent.horizontalCenter
    }
    
    property int widthPadding : 2
    property int heightPadding : 0

    width: {
        let visualItem = loader.item as Item
        return (visualItem ? visualItem.implicitWidth : 0) + notch_root.widthPadding * 2
    }
    height: {
        let visualItem = loader.item as Item
        return (visualItem ? visualItem.implicitHeight : 0) + notch_root.heightPadding * 2
    }

    // Styling
    color: Colors.background
    radius : 10

    // Components 
    Component {
        // qmllint disable import
        id: defaultViewComponent
        // qmllint enable import
        Views.Default { notch : notch_root } 
    }

    Component {
        id: launcherViewComponent
        Views.Launcher { notch: notch_root }
    }

    Component {
        id: controlPanelViewComponent
        Views.ControlPanel { notch: notch_root }
    }

    property Component defaultView: defaultViewComponent
    property Component launcherView: launcherViewComponent
    property Component controlPanelView: controlPanelViewComponent
    readonly property bool isExpanded: view !== defaultView

    // Content
    property Component view: defaultView

    Loader {
        id: loader
        sourceComponent: notch_root.defaultView
        anchors.centerIn: parent
    }

    // Shortcuts
    GlobalShortcut { // qmllint disable unresolved-type
        name: "toggleNotch"

        onPressed: {
            if (notch_root.screen.name != Hyprland.focusedMonitor.name) return
            if (notch_root.view == notch_root.defaultView) {
                notch_root.view = notch_root.launcherView
            } else if (notch_root.view == notch_root.launcherView) {
                notch_root.view = notch_root.controlPanelView
            } else {
                notch_root.view = notch_root.defaultView
            }
        }
    }

    onViewChanged: {
        loader.sourceComponent = notch_root.view
        var win = notch_root.Window.window
        if (win) win.requestActivate()
    }

    // Notch Animations
    Behavior on width {
        NumberAnimation {
            duration: notch_root.animationSpeed / 2
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: notch_root.animationSpeed / 2
            easing.type: Easing.OutCubic
        }
    }
}