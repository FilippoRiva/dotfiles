import QtQuick 
import '.' as Elements

Elements.NotchElement {
    id : root
    width: content.width
    height: content.height
    property int size: 48
    property string font: "Jetbrains Mono"

    property date currentTime: new Date()
    property string format: "HH:mm:ss"

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: root.currentTime = new Date()
    }

    Text {
        id: content

        font.family: root.font
        text: Qt.formatTime(root.currentTime, root.format)
        color: "white"
        font.pixelSize: root.size
    }
}