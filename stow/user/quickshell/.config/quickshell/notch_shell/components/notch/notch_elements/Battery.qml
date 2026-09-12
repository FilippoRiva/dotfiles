import './' as Elements
import QtQuick.Layouts
import Quickshell.Services.UPower
import QtQuick
import '../../../'

Elements.NotchElement {
    id: root
    implicitHeight: 30
    implicitWidth: 70

    property var device: UPower.displayDevice
    property bool hasBattery: device?.isLaptopBattery ?? false
    property bool ready: device?.ready ?? false
    property real percentage: ready ? device.percentage : 0
    property bool charging: ready && (device.state === UPowerDeviceState.Charging || device.state === UPowerDeviceState.PendingCharge)
    property bool lowBattery: ready && percentage < 0.15
    property string textColor: lowBattery ? Colors.color1 : Colors.foreground
    property string font: "Jetbrains Mono"
    property string iconFont: "Material Symbols Rounded"

    visible: root.hasBattery

    function icon() {
        if (root.charging) return "battery_charging_full"
        if (root.percentage >= 0.9) return "battery_full"
        if (root.percentage >= 0.65) return "battery_5_bar"
        if (root.percentage >= 0.40) return "battery_4_bar"
        if (root.percentage >= 0.15) return "battery_2_bar"
        if (root.ready) return "battery_alert"
        return "battery_unknown"
    }

    Rectangle{
        color: Colors.background2
        radius: 5

        RowLayout {
            anchors.fill: parent
            spacing: 0
            Text {
                font.family: root.iconFont
                text: root.icon()
                font.pixelSize: 24
                color: root.textColor
            }
            Text {
                font.family: root.font
                text: root.ready ? Math.round(root.percentage*100) + "%" : "--"
                font.pixelSize: 14
                color: root.textColor
            }
        }
    }
}