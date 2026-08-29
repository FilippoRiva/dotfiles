import QtQuick 
import '.' as Elements

Elements.NotchElement {
    id : clock_element
    width: content.width
    height: content.height
    property int size: 48

    property date currentTime: new Date()
    property string format: "HH:mm:ss"

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: currentTime = new Date()
    }

    Text {
        id: content

        text: Qt.formatTime(currentTime, clock_element.format)
        color: "white"
        font.pixelSize: size
    }
}