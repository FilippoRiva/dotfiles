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

    ColumnLayout {
        id: layout
        spacing: 8

        // Row 1: Timer controls (always visible)
        RowLayout {
            id: timerRow
            spacing: 6

            Text {
                font.family: "Geistmono Nerd Font"
                font.pixelSize: root.fontSize
                text: root.formatTime(TimerState.timeLeft)
                color: TimerState.pomodoroMode
                    ? (TimerState.isFocusPhase ? Colors.color2 : Colors.color4)
                    : Colors.foreground
            }

            Elements.Button {
                icon: TimerState.active ? "pause" : "play_arrow"
                button_enabled: true
                onActivate: () => TimerState.toggle()
            }

            Elements.Button {
                text: "10 min"
                buttonWidth: root.buttonWidth
                fontSize: root.fontSize
                button_enabled: !TimerState.pomodoroMode
                onActivate: () => TimerState.setTime(10*60)
            }

            Elements.Button {
                text: "25 min"
                buttonWidth: root.buttonWidth
                fontSize: root.fontSize
                button_enabled: !TimerState.pomodoroMode
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

            Elements.Button {
                icon: "cognition"
                button_enabled: true
                backgroundColor: TimerState.pomodoroMode ? Colors.color2 : Colors.background2
                onActivate: () => TimerState.togglePomodoro()
            }
        }

        // Row 2: Pomodoro controls (only when pomodoro mode active)
        RowLayout {
            id: pomodoroRow
            spacing: 8
            visible: TimerState.pomodoroMode
            opacity: visible ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            // Phase indicator
            Rectangle {
                width: phaseLabel.width + 12
                height: phaseLabel.height + 6
                radius: 8
                color: TimerState.isFocusPhase ? Colors.color2 : Colors.color4
                opacity: 0.25

                Text {
                    id: phaseLabel
                    anchors.centerIn: parent
                    font.family: "Geistmono Nerd Font"
                    font.pixelSize: root.fontSize
                    text: TimerState.phaseLabel
                    color: Colors.foreground
                }
            }

            // Focus time setter
            RowLayout {
                spacing: 4

                Text {
                    font.family: "Geistmono Nerd Font"
                    font.pixelSize: root.fontSize
                    text: "Focus:"
                    color: Colors.foreground
                }

                Elements.Button {
                    text: "25"
                    buttonWidth: 35
                    fontSize: root.fontSize
                    button_enabled: true
                    backgroundColor: TimerState.selectedFocusTime === 25 * 60 ? Colors.color2 : Colors.background2
                    onActivate: () => TimerState.setFocusTime(25)
                }

                Elements.Button {
                    text: "45"
                    buttonWidth: 35
                    fontSize: root.fontSize
                    button_enabled: true
                    backgroundColor: TimerState.selectedFocusTime === 45 * 60 ? Colors.color2 : Colors.background2
                    onActivate: () => TimerState.setFocusTime(45)
                }

                Elements.Button {
                    text: "60"
                    buttonWidth: 35
                    fontSize: root.fontSize
                    button_enabled: true
                    backgroundColor: TimerState.selectedFocusTime === 60 * 60 ? Colors.color2 : Colors.background2
                    onActivate: () => TimerState.setFocusTime(60)
                }
            }

            // Pause time setter
            RowLayout {
                spacing: 4

                Text {
                    font.family: "Geistmono Nerd Font"
                    font.pixelSize: root.fontSize
                    text: "Pause:"
                    color: Colors.foreground
                }

                Elements.Button {
                    text: "5"
                    buttonWidth: 35
                    fontSize: root.fontSize
                    button_enabled: true
                    backgroundColor: TimerState.selectedPauseTime === 5 * 60 ? Colors.color4 : Colors.background2
                    onActivate: () => TimerState.setPauseTime(5)
                }

                Elements.Button {
                    text: "10"
                    buttonWidth: 35
                    fontSize: root.fontSize
                    button_enabled: true
                    backgroundColor: TimerState.selectedPauseTime === 10 * 60 ? Colors.color4 : Colors.background2
                    onActivate: () => TimerState.setPauseTime(10)
                }

                Elements.Button {
                    text: "15"
                    buttonWidth: 35
                    fontSize: root.fontSize
                    button_enabled: true
                    backgroundColor: TimerState.selectedPauseTime === 15 * 60 ? Colors.color4 : Colors.background2
                    onActivate: () => TimerState.setPauseTime(15)
                }
            }

            Elements.Button {
                icon: "restart_alt"
                button_enabled: true
                onActivate: () => TimerState.resetPomodoro()
            }

            Item { Layout.fillWidth: true }

            // Pomodoro stats
            RowLayout {
                spacing: 6

                // Completed pomodoros count
                RowLayout {
                    spacing: 2

                    Text {
                        font.family: "Material Symbols Rounded"
                        font.pixelSize: root.fontSize
                        text: "alarm"
                        color: Colors.color2
                        visible: TimerState.completedPomodoros > 0
                    }

                    Text {
                        font.family: "Geistmono Nerd Font"
                        font.pixelSize: root.fontSize
                        text: TimerState.completedPomodoros > 0 ? TimerState.completedPomodoros : ""
                        color: Colors.color2
                        visible: TimerState.completedPomodoros > 0
                    }
                }

                Text {
                    font.family: "Geistmono Nerd Font"
                    font.pixelSize: root.fontSize
                    text: TimerState.completedPomodoros > 0
                        ? (TimerState.completedPomodoros + " × " + root.formatTime(TimerState.totalFocusTime))
                        : ""
                    color: Colors.color8
                    visible: TimerState.completedPomodoros > 0
                }
            }
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
