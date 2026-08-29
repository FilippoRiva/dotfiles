import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "notch_views" as Views
import "../../"

Rectangle {
    id: root

    // Positioning
    anchors {
        top: parent.top
        topMargin: 5
        horizontalCenter: parent.horizontalCenter
    }

    width: loader.item?.implicitWidth ?? 0
    height: loader.item?.implicitHeight ?? 0

    // Styling
    color: Colors.background
    radius : 10

    // Components 
    Component {
        id: defaultViewComponent
        Views.Default { notch : root } 
    }

    Component {
        id: expandedViewComponent
        Views.Expanded { notch: root }
    }

    property Component defaultView: defaultViewComponent
    property Component expandedView: expandedViewComponent

    // Content
    property Component view: defaultView

    Loader {
        id: loader
        sourceComponent: root.view
        anchors.centerIn: parent
    }

    // Shortcuts
    GlobalShortcut {
        name: "toggleNotch"

        onPressed: {
            root.view = root.view == defaultView ? expandedView : defaultView
        }
    }

    // Animations
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