import QtQuick
import QtQuick.Layouts
import '.' as Elements
import "../../.."

Elements.NotchElement {
    id: root
    implicitHeight: layout.height
    implicitWidth: layout.width
    property int buttonWidth: 100
    property int fontSize: 12

    RowLayout {
        id: layout
        Text {
            font.family: "Geistmono Nerd Font"
            font.pixelSize: root.fontSize
            text: Math.floor(TimerState.timeLeft / 60) + ":" + ( (TimerState.timeLeft % 60 < 10) ? '0'+TimerState.timeLeft % 60: TimerState.timeLeft % 60)
            color: Colors.foreground
        }
        Elements.IconButton {
            icon: TimerState.active ? "pause" : "play_arrow"
            button_enabled: true
            onActivate: () => TimerState.toggle()
        }
        Elements.TextButton {
            icon: "10 min"
            buttonWidth: root.buttonWidth
            fontSize: root.fontSize
            button_enabled: true
            onActivate: () => TimerState.setTime(10*60)
        }
        Elements.TextButton {
            icon: "25 min"
            buttonWidth: root.buttonWidth
            fontSize: root.fontSize
            button_enabled: true
            onActivate: () => TimerState.setTime(25*60)
        }
        Elements.TextButton {
            icon: "+5 min"
            buttonWidth: root.buttonWidth
            fontSize: root.fontSize
            button_enabled: true
            onActivate: () => TimerState.addTime(5*60)
        }
        Elements.TextButton {
            icon: "-5 min"
            buttonWidth: root.buttonWidth
            fontSize: root.fontSize
            button_enabled: true
            onActivate: () => TimerState.addTime(-5*60)
        }
    }
}