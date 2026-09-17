import QtQuick
import QtQuick.Layouts
import '../notch_elements' as Elements
import '.' as Views

Views.NotchView {
    id: root
    spacing: 0
    focus: true
    property int gridWidth: 5
    property int cellWidth: 90
    property int cellHeight: 50

    Keys.onEscapePressed: (event) => {
        root.notch.setView('default')
        event.accepted = true
    }

    Elements.MusicController {  
        Layout.margins: 10 
        implicitHeight: root.cellHeight
        implicitWidth: root.cellWidth * root.gridWidth
    }

    Elements.Divider { Layout.fillWidth: true }

    Elements.AudioController { 
        id: audioController
        Layout.margins: 10 
        implicitHeight: root.cellHeight
        implicitWidth: root.cellWidth * root.gridWidth
    }

    Elements.Divider { Layout.fillWidth: true }

    RowLayout {
        Layout.margins: 10
        Layout.alignment: Qt.AlignHCenter
        spacing: 5
        Elements.NetworkStatus {
            notch : root.notch
            implicitHeight: root.cellHeight
            implicitWidth: root.cellWidth * (root.gridWidth - 2)
        }
        Elements.Battery {
            implicitHeight: root.cellHeight
            implicitWidth: root.cellWidth 
        }
        Elements.CpuTemperature {
            implicitHeight: root.cellHeight
            implicitWidth: root.cellWidth 
        }
        Elements.GpuTemperature {
            implicitHeight: root.cellHeight
            implicitWidth: root.cellWidth 
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Elements.Divider { Layout.fillWidth: true }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.margins: 5
        Elements.WorkspaceDots {}
        Item { Layout.fillWidth: true }
        Elements.IconButton {
            backgroundColor: "transparent"
            fontSize: 12
            icon: "home"
            button_enabled: true
            onActivate: () => root.notch.setView('default')
        }
    }
}