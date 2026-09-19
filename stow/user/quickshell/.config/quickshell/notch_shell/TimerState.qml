pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    property int timeLeft: 0
    property bool active: false
    property string soundEffectPath: "/.config/quickshell/notch_shell/resources/Ding_-_Sound_Effect.wav"
    property int totalTime: 0

    // Pomodoro state
    property bool pomodoroMode: false
    property bool isFocusPhase: true
    property int focusTime: selectedFocusTime
    property int pauseTime: selectedPauseTime
    property int selectedFocusTime: 25 * 60
    property int selectedPauseTime: 5 * 60
    property int completedPomodoros: 0
    property int totalFocusTime: 0
    property string phaseLabel: isFocusPhase ? "Focus" : "Pause"

    Timer {
        id: countdownTimer
        interval : 1000
        repeat: true
        running: root.active

        onTriggered: {
            if (TimerState.timeLeft > 0 ) {
                TimerState.timeLeft -= 1
                TimerState.totalTime += 1
            } else {
                if (root.pomodoroMode) {
                    if (root.isFocusPhase) {
                        // Focus complete → switch to pause
                        root.completedPomodoros += 1
                        root.totalFocusTime += root.focusTime
                        root.isFocusPhase = false
                        root.timeLeft = root.pauseTime
                        Quickshell.execDetached(["pw-play", Quickshell.env("HOME") + soundEffectPath])
                    } else {
                        // Pause complete → switch to focus
                        root.isFocusPhase = true
                        root.timeLeft = root.focusTime
                        Quickshell.execDetached(["pw-play", Quickshell.env("HOME") + soundEffectPath])
                    }
                } else {
                    root.active = false
                    Quickshell.execDetached(["pw-play", Quickshell.env("HOME") + soundEffectPath])
                }
            }
        }
    }

    function toggle() {
        if ( root.active ) {
            stop()
        } else {
            start()
        }
    }

    function start() {
        root.active = true
    }

    function stop() {
        root.active = false
    }

    function setTime(time) {
        root.timeLeft = time
        root.stop()
    }

    function addTime(time) {
        if (root.timeLeft + time < 0) {
            root.timeLeft = 0
        } else {
            root.timeLeft = root.timeLeft + time
        }
    }

    // Pomodoro functions
    function togglePomodoro() {
        if (root.pomodoroMode) {
            stopPomodoro()
        } else {
            startPomodoro()
        }
    }

    function startPomodoro() {
        root.pomodoroMode = true
        root.isFocusPhase = true
        root.timeLeft = root.focusTime
        root.active = true
    }

    function stopPomodoro() {
        root.pomodoroMode = false
        root.active = false
        root.isFocusPhase = true
    }

    function resetPomodoro() {
        root.completedPomodoros = 0
        root.totalFocusTime = 0
        root.isFocusPhase = true
        if (root.pomodoroMode) {
            root.timeLeft = root.focusTime
            root.active = false
        }
    }

    function setFocusTime(minutes) {
        root.selectedFocusTime = minutes * 60
        root.focusTime = root.selectedFocusTime
        if (root.pomodoroMode && root.isFocusPhase) {
            root.timeLeft = root.focusTime
        }
    }

    function setPauseTime(minutes) {
        root.selectedPauseTime = minutes * 60
        root.pauseTime = root.selectedPauseTime
        if (root.pomodoroMode && !root.isFocusPhase) {
            root.timeLeft = root.pauseTime
        }
    }
}
