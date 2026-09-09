pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire


Singleton {
    id: root

    property bool ready: Pipewire.defaultAudioSink?.ready ?? false
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource
    property real value: sink?.audio.volume ?? 0

    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    function setVolume(volume) {
        Audio.sink.audio.volume = volume
    }
}