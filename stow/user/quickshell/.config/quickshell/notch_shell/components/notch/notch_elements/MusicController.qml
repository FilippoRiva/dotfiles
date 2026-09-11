import './' as Elements
import QtQuick.Layouts
import Quickshell.Services.Mpris
import QtQuick
import '../../../'

Elements.NotchElement {
    id: root
    implicitHeight: 60
    implicitWidth: 300

    function findPlayer() {
        const players = Array.from(Mpris.players.values)
        for (let p of players) {
            if (p.playbackState === MprisPlaybackState.Playing) return p
        }
        return players.length > 0 ? players[0] : null
    }

    property var player: root.findPlayer()
    property bool hasPlayer: root.player != null
    property bool canPrev: root.player?.canGoPrevious ?? false
    property bool canNext: root.player?.canGoNext ?? false
    property bool canToggle: root.player?.canTogglePlaying ?? false
    property bool playing: root.player?.isPlaying ?? false

    property string title: root.hasPlayer ? (root.player?.trackTitle || "Unknown Title") : "Nothing playing"
    property string artist: root.hasPlayer ? (root.player?.trackArtist || "") : ""

    Connections {
        target: Mpris.players
        function onValuesChanged() { root.player = root.findPlayer() }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10

        Text {
            font.family: "Material Symbols Rounded"
            text: "music_note"
            font.pixelSize: 20
            color: Colors.color2
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                Layout.fillWidth: true
                font.family: "Geistmono Nerd Font"
                text: root.title
                font.pixelSize: 14
                color: root.hasPlayer ? Colors.foreground : Colors.color6
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                font.family: "Geistmono Nerd Font"
                text: root.artist
                font.pixelSize: 11
                color: Colors.color6
                elide: Text.ElideRight
                visible: root.artist !== ""
            }
        }

        Elements.IconButton {
            icon: "skip_previous"
            button_enabled: root.canPrev
            onActivate: () => root.player.previous()
        }

        Elements.IconButton {
            icon: root.playing ? "pause" : "play_arrow"
            button_enabled: root.canToggle
            onActivate: () => root.player.togglePlaying()
        }

        Elements.IconButton {
            icon: "skip_next"
            button_enabled: root.canNext
            onActivate: () => root.player.next()
        }
    }
}