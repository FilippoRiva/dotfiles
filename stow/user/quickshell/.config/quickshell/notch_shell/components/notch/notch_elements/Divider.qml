import './' as Elements
import QtQuick
import '../../../'

Elements.NotchElement {
    id: root
    property int lineHeight: 1
    property int margin: 5
    implicitHeight: lineHeight

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.margin
        anchors.rightMargin: root.margin
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        height: root.lineHeight
        radius: 2
        color: Colors.background2
    }
}