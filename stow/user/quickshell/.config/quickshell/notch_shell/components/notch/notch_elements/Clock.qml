import QtQuick 
import '.' as Elements

Elements.NotchElement {
    width: content.width
    height: content.height
    property int size: 48

    property date currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: currentTime = new Date()
    }

    Text {
        id: content

        text: Qt.formatTime(currentTime, "HH:mm:ss")
        color: "white"
        font.pixelSize: size
    }
}