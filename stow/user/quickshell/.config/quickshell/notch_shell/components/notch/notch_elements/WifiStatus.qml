import './' as Elements
import QtQuick.Layouts
import Quickshell.Networking
import QtQuick
import '../../../'

Elements.NotchElement {
    id: root
    implicitHeight: 30
    implicitWidth: 210

    property string font: "Jetbrains Mono"
    property string iconFont: "Material Symbols Rounded"
    property string ssid: ""
    property var wifiDevice: root.findWifiDevice()

    function findWifiDevice() {
        for (let device of Array.from(Networking.devices.values)) {
            if (device.type === DeviceType.Wifi) return device
        }
        return null
    }

    function findConnectedSsid() {
        let device = root.wifiDevice
        if (!device) return ""
        for (let network of Array.from(device.networks.values)) {
            if (network.connected && network.name) return network.name
        }
        return ""
    }

    function refresh() {
        root.wifiDevice = root.findWifiDevice()
        if (root.wifiDevice) root.wifiDevice.scannerEnabled = true
        root.ssid = root.findConnectedSsid()
    }

    Connections {
        target: Networking.devices
        function onValuesChanged() { root.refresh() }
    }

    Timer {
        id: refreshTimer
        interval: 3000
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()

    property bool connected: root.ssid !== ""
    property string label: root.connected ? root.ssid : "N/A"
    property string textColor: root.connected ? Colors.foreground : Colors.color6

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
                text: root.connected ? "wifi" : "wifi_off"
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
    }
}