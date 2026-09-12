pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import '.' as Elements
import "../../.."

Elements.NotchElement {
    id: root

    property int listWidth: 350
    property int listHeight: 300

    implicitWidth: root.listWidth
    implicitHeight: root.listHeight

    required property var notch
    property string font: "Geistmono Nerd Font"
    property string iconFont: "Material Symbols Rounded"

    property var networkItems: []

    function refresh() {
        let items = []
        for (let device of Array.from(Networking.devices.values)) {
            if (device.type === DeviceType.None) continue
            for (let network of Array.from(device.networks.values)) {
                items.push({
                    name: network.name || "Unknown",
                    connected: network.connected,
                    state: network.state,
                    deviceType: device.type,
                    network: network,
                    signalStrength: device.type === DeviceType.Wifi ? network.signalStrength : 0,
                    iconName: device.type === DeviceType.Wifi ? "wifi" : "lan",
                    security: device.type === DeviceType.Wifi ? network.security : -1,
                    stateChanging: network.stateChanging
                })
            }
        }
        items.sort((a, b) => {
            if (a.connected !== b.connected) return a.connected ? -1 : 1
            return (a.name || "").localeCompare(b.name || "")
        })
        root.networkItems = items
        list.currentIndex = 0
    }

    Connections {
        target: Networking.devices
        function onValuesChanged() { root.refresh() }
    }

    Timer {
        interval: 3000
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()

    function activateNetwork(item) {
        let net = item.network
        if (net.stateChanging) return
        if (net.connected) {
            console.log("Disconnecting from " + net.name)
            net.disconnect()
        } else {
            console.log("Connecting to " + net.name)
            net.connect()
        }
    }

    Rectangle {
        id: panel

        implicitWidth: root.listWidth
        implicitHeight: root.listHeight
        radius: 16
        color: Colors.background

        focus: true
        Keys.onReturnPressed: (event) => {
            let item = root.networkItems[list.currentIndex]
            if (item) root.activateNetwork(item)
            event.accepted = true
        }
        Keys.onDownPressed: (event) => {
            list.incrementCurrentIndex()
            event.accepted = true
        }
        Keys.onUpPressed: (event) => {
            list.decrementCurrentIndex()
            event.accepted = true
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: list
                    anchors.fill: parent
                    currentIndex: 0
                    model: root.networkItems
                    clip: true
                    spacing: 4

                    delegate: Rectangle {
                        id: entry
                        required property var modelData
                        required property int index

                        width: list.width
                        implicitHeight: 44
                        radius: 12

                        color: {
                            if (index === list.currentIndex) return Colors.foreground
                            if (entry.modelData.network.connected) return Colors.background2
                            return "transparent"
                        }
                        scale: index === list.currentIndex ? 1 : 0.98

                        Behavior on scale {
                            NumberAnimation {
                                duration: 80
                                easing.type: Easing.OutCubic
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                                easing.type: Easing.OutCubic
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 10

                            Text {
                                property int animationSpeed: 300
                                id: textIcon
                                font.family: root.iconFont
                                text: entry.modelData.iconName
                                font.pixelSize: 22
                                color: entry.index === list.currentIndex ? Colors.background : Colors.foreground
                                NumberAnimation {
                                    target: textIcon
                                    property: "rotation"
                                    running: entry.modelData.network.stateChanging
                                    from: 0
                                    to: 360
                                    duration: textIcon.animationSpeed
                                    loops: Animation.Infinite
                                    onRunningChanged: {
                                        if (!running) returnAnimation.start()
                                    }
                                }
                                NumberAnimation {
                                    id: returnAnimation
                                    target: textIcon
                                    property: "rotation"
                                    from: textIcon.rotation
                                    to: 360
                                    duration: textIcon.animationSpeed - textIcon.rotation/360*textIcon.animationSpeed
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6

                                    Text {
                                        text: entry.modelData.name
                                        color: entry.index === list.currentIndex ? Colors.background : Colors.foreground
                                        font.pixelSize: 13
                                        font.bold: true
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Row {
                                        spacing: 2
                                        visible: entry.modelData.deviceType === DeviceType.Wifi

                                        Repeater {
                                            model: 4

                                            Rectangle {
                                                width: 4
                                                height: {
                                                    let bars = [6, 9, 12, 15]
                                                    return bars[index]
                                                }
                                                radius: 2
                                                anchors.verticalCenter: parent.verticalCenter
                                                color: {
                                                    let strength = entry.modelData.signalStrength
                                                    let threshold = (index + 1) * 25
                                                    let filled = strength >= threshold
                                                    if (entry.index === list.currentIndex) {
                                                        return filled ? Colors.background : Qt.rgba(0, 0, 0, 0.2)
                                                    } else {
                                                        return filled ? Colors.foreground : Colors.color6
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Text {
                                        font.family: root.iconFont
                                        text: {
                                            let sec = entry.modelData.security
                                            if (sec === -1) return ""
                                            let openVal = WifiSecurityType.Open
                                            if (sec === openVal) return ""
                                            return "lock"
                                        }
                                        font.pixelSize: 14
                                        color: entry.index === list.currentIndex ? Colors.background : Colors.color6
                                        visible: text !== ""
                                    }
                                }

                                Text {
                                    text: {
                                        let item = entry.modelData.network
                                        let baseText = item.connected ? "Connected" : "Disconnected"
                                        if (item.stateChanging) {
                                            baseText = item.state === ConnectionState.Connecting ? "Connecting..." : "Disconnecting..."
                                        }
                                        return baseText
                                    }
                                    color: {
                                        if (entry.modelData.network.connected) {
                                            return entry.index === list.currentIndex ? Colors.background : Colors.color4
                                        } else if (entry.modelData.network.stateChanging) {
                                            return entry.index === list.currentIndex ? Colors.background : Colors.color6
                                        } else {
                                            return entry.index === list.currentIndex ? Colors.background : Colors.color6
                                        }
                                    }
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                let item = root.networkItems[entry.index]
                                root.activateNetwork(item)
                            }
                            onEntered: list.currentIndex = entry.index
                        }
                    }
                }

                Rectangle {
                    z: 2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 50
                    opacity: list.contentY > 0 ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Colors.background }
                        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
                    }
                }

                Rectangle {
                    z: 2
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 50
                    opacity: list.contentY < list.contentHeight - list.height ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0) }
                        GradientStop { position: 1.0; color: Colors.background }
                    }
                }
            }
        }
    }
}