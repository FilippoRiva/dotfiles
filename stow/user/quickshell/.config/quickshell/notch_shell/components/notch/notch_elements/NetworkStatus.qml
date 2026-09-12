import './' as Elements
import QtQuick.Layouts
import Quickshell.Networking
import QtQuick
import '../../../'

Elements.NotchElement {
    id: root
    implicitHeight: 30
    implicitWidth: 210

    required property var notch

    property string font: "Jetbrains Mono"
    property string iconFont: "Material Symbols Rounded"
    property string networkName: ""
    property string iconText: "wifi_off"
    property var currentDevice: root.findDevice()

    function findDevice() {
        for (let device of Array.from(Networking.devices.values)) {
            if (device.type === DeviceType.None) continue
            for (let network of Array.from(device.networks.values)) {
                if (network.connected) return device
            }
        }
        return null
    }

    function findConnectedNetwork() {
        let device = root.currentDevice
        if (!device) return null
        for (let network of Array.from(device.networks.values)) {
            if (network.connected) return network
        }
        return null
    }

    property bool devicesAvailable: false

    function anyDevices() {
        for (let device of Array.from(Networking.devices.values)) {
            if (device.type !== DeviceType.None) return true
        }
        return false
    }

    function refresh() {
        root.devicesAvailable = root.anyDevices()
        root.currentDevice = root.findDevice()
        if (root.currentDevice) root.currentDevice.scannerEnabled = true
        let network = root.findConnectedNetwork()
        root.networkName = network ? network.name : ""
        if (root.currentDevice) {
            if (root.currentDevice.type === DeviceType.Wifi) root.iconText = "wifi"
            else if (root.currentDevice.type === DeviceType.Ethernet) root.iconText = "lan"
            else root.iconText = "signal_cellular_alt"
        } else {
            root.iconText = "wifi_off"
        }
    }

    Connections {
        target: Networking.devices
        function onValuesChanged() { root.refresh() }
    }

    Timer {
        id: refreshTimer
        triggeredOnStart: true
        interval: 3000
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()

    property bool connected: root.networkName !== ""
    property bool scanning: !root.devicesAvailable && !root.connected
    property string label: root.connected ? root.networkName : root.scanning ? "Scanning..." : "Disconnected"
    property string textColor: root.connected ? Colors.foreground : root.scanning ? Colors.color6 : Colors.color6

    Rectangle {
        anchors.fill: parent
        color: Colors.background
        border.color: Colors.background2
        radius: 5

        RowLayout {
            anchors.fill: parent
            spacing: 0
            Text {
                leftPadding: 5
                rightPadding: 5
                font.family: root.iconFont
                text: root.iconText
                font.pixelSize: 24
                color: root.textColor
            }
            Text {
                font.family: root.font
                text: root.label
                font.pixelSize: 14
                elide: Text.ElideRight
                Layout.fillWidth: true
                color: root.textColor
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.notch.view = root.notch.networkPanelView
            }            
        }
    }

}