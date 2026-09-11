pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import Quickshell
import "notch_views" as Views
import "../../"

Rectangle {
    id: root
    clip: true

    property int animationSpeed: 300
    property bool hidden: false
    property Component lastView : defaultView
    required property PanelWindow panelWindow
    required property ShellScreen screen

    enum Position { Top, Center, Bottom }
    property int position: Notch.Position.Top

    // Positioning
    anchors {
        top: parent.top
        topMargin: root.position == Notch.Position.Top ? 5 : 0
        horizontalCenter: parent.horizontalCenter
    }

    transform : Translate {
        id: translation

        y: root.hidden  && root.view == root.defaultView ? -40 : 0

        Behavior on y {
            NumberAnimation {
                duration: root.animationSpeed
                easing.type: Easing.OutCubic
            }
        }
    }
    
    property int widthPadding : 2
    property int heightPadding : 0

    width: {
        let visualItem = loader.item as Item
        return (visualItem ? visualItem.implicitWidth : 0) + root.widthPadding * 2
    }

    height: {
        let visualItem = loader.item as Item
        return (visualItem ? visualItem.implicitHeight : 0) + root.heightPadding * 2
    }

    // Styling
    color: Colors.background
    border.color: Colors.background2
    radius : 10

    // Components (for dynamic load)
    Component {
        id: defaultViewComponent
        Views.Default { notch : root } 
    }

    Component {
        id: launcherViewComponent
        Views.Launcher { notch: root }
    }

    Component {
        id: controlPanelViewComponent
        Views.ControlPanel { notch: root }
    }

    property Component defaultView: defaultViewComponent
    property Component launcherView: launcherViewComponent
    property Component controlPanelView: controlPanelViewComponent
    readonly property bool isExpanded: view !== defaultView

    // Content
    property Component view: defaultView

    Loader {
        id: loader
        sourceComponent: root.defaultView
        anchors.centerIn: parent
    }

    function toggleView (viewToToggle) {
        if (root.screen.name != Hyprland.focusedMonitor.name) return
        if (root.view == root.defaultView) {
            root.view = viewToToggle
        } else {
            root.view = root.defaultView
        }
    }


    // Shortcuts
    GlobalShortcut { // qmllint disable unresolved-type
        name: "toggleLauncher"

        onPressed: root.toggleView(root.launcherView)
    }

    GlobalShortcut { // qmllint disable unresolved-type
        name: "toggleControlPanel"

        onPressed: root.toggleView(root.controlPanelView)
    }

    GlobalShortcut { // qmllint disable unresolved-type
        name: "hideNotch"

        onPressed: {
            if ( root.hidden ) { 
                root.show()                
            } else { 
                root.hide()
            }
        }
    }


    onViewChanged: {
        loader.sourceComponent = root.view
        var win = root.Window.window
        if (win) win.requestActivate()
    }

    function hide() {
        panelWindow.exclusive = false
        root.hidden = true
        root.lastView = root.view
        root.view = root.defaultView
    }

    function show() { 
        panelWindow.exclusive = true
        root.hidden = false
        root.view = root.lastView
    }

    // Notch Animations
    Behavior on width {
        NumberAnimation {
            duration: root.animationSpeed / 2
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: root.animationSpeed / 2
            easing.type: Easing.OutCubic
        }
    }

}