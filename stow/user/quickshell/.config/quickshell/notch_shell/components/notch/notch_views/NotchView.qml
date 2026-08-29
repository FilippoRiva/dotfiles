import QtQuick
import QtQuick.Layouts

ColumnLayout {
    required property var notch 
    id: view
    z: 1
    anchors {
        top: parent. top
        horizontalCenter: parent.horizontalCenter
    }
}