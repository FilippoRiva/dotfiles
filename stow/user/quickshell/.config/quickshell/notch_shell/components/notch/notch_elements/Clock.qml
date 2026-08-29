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

        onTriggered: clock_element.currentTime = new Date()
    }

    Text {
        id: content

        font.family: "Geistmono Nerd Font"
        text: Qt.formatTime(clock_element.currentTime, clock_element.format)
        color: "white"
        font.pixelSize: clock_element.size
    }
}