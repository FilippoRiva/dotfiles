import './' as Elements
import QtQuick
import QtQuick.Layouts
import '../../../'

Elements.NotchElement {
    id: root

    property string icon
    property string text
    property bool button_enabled: true
    property var onActivate
    property string backgroundColor: Colors.background2
    property int fontSize: 18
    property string font: "Geistmono Nerd Font"
    property string iconFont: "Material Symbols Rounded"
    property int buttonWidth: 25
    property int buttonHeigth: 25

    width: content.width
    height: content.height

    Rectangle {
        id: content

        width: root.buttonWidth
        height: root.buttonHeigth
        radius: 15
        color: root.backgroundColor

        scale: mouse.pressed ? 0.9 : 1

        Behavior on scale {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }

        // Icon-only mode
        Text {
            id: iconOnlyText
            anchors.centerIn: parent
            font.family: root.iconFont
            text: root.icon
            color: root.button_enabled ? Colors.foreground : Colors.color6
            font.pixelSize: root.fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: root.icon !== "" && root.text === ""
        }

        // Text-only mode
        Text {
            id: textOnlyText
            anchors.centerIn: parent
            font.family: root.font
            text: root.text
            color: root.button_enabled ? Colors.foreground : Colors.color6
            font.pixelSize: root.fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: root.text !== "" && root.icon === ""
        }

        // Icon + text mode
        RowLayout {
            anchors.centerIn: parent
            spacing: 2
            visible: root.icon !== "" && root.text !== ""

            Text {
                font.family: root.iconFont
                text: root.icon
                color: root.button_enabled ? Colors.foreground : Colors.color6
                font.pixelSize: root.fontSize
            }
            Text {
                font.family: root.font
                text: root.text
                color: root.button_enabled ? Colors.foreground : Colors.color6
                font.pixelSize: root.fontSize
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                if (root.button_enabled && root.onActivate) root.onActivate()
            }
        }
    }
}
