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
            text: root.formatTime(TimerState.timeLeft)
            color: Colors.foreground
        }
        Elements.IconButton {
            icon: TimerState.active ? "pause" : "play_arrow"
            button_enabled: true
            onActivate: () => TimerState.toggle()
        }
        Elements.Button {
            text: "10 min"
            buttonWidth: root.buttonWidth
            fontSize: root.fontSize
            button_enabled: true
            onActivate: () => TimerState.setTime(10*60)
        }
        Elements.Button {
            text: "25 min"
            buttonWidth: root.buttonWidth
            fontSize: root.fontSize
            button_enabled: true
            onActivate: () => TimerState.setTime(25*60)
        }
        Elements.Button {
            text: "+10 min"
            buttonWidth: root.buttonWidth
            fontSize: root.fontSize
            button_enabled: true
            onActivate: () => TimerState.addTime(10*60)
        }
        Elements.Button {
            text: "-10 min"
            buttonWidth: root.buttonWidth
            fontSize: root.fontSize
            button_enabled: true
            onActivate: () => TimerState.addTime(-10*60)
        }
        Text {
            font.family: "Geistmono Nerd Font"
            font.pixelSize: root.fontSize
            text: root.formatTime(TimerState.totalTime)
            color: Colors.foreground
        }
    }
    function formatTwoDigits(number) {
        return number < 10 ? "0"+number : number
    }

    function formatTime (time) {
        let seconds = formatTwoDigits(time % 60)
        let minutes = formatTwoDigits(Math.floor(((time - seconds)%3600)/60))
        let hours = formatTwoDigits(Math.floor((time - seconds - minutes*60)/60/60))
        if (hours > 0 ) return hours + ":" + minutes + ":" + seconds
        return minutes + ":" + seconds
    }
}
