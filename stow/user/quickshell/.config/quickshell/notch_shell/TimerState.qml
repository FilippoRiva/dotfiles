pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    property int timeLeft: 0
    property bool active: false
    property string soundEffectPath: "/.config/quickshell/notch_shell/resources/Ding_-_Sound_Effect.wav"
    property int totalTime: 0


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
                root.active = false
                Quickshell.execDetached(["pw-play", Quickshell.env("HOME") + soundEffectPath])
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
}