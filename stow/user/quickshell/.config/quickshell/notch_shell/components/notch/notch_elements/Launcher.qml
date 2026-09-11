pragma ComponentBehavior: Bound

import QtQuick
import QtQml.Models
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import '.' as Elements
import "../../.."

Elements.NotchElement {
    id: root

    width: launcher.width
    height: launcher.height

    required property var notch
    property var terminalCommand: ["kitty", "-e"]
    property string font: "Geistmono Nerd Font"


    Rectangle {
        id: launcher

        width: 500
        height: 300
        radius: 16
        color: Colors.background

        function launchEntry(entry) {
            if (entry.runInTerminal) {
                Quickshell.execDetached(root.terminalCommand.concat(entry.command))
            } else {
                entry.execute()
            }
            root.notch.view = root.notch.defaultView
        }

        property var allApps: DesktopEntries.applications.values
        property var appResults: []
        property ListModel filteredApps: ListModel {}

        function fuzzyScore(query, target) {
            if (!query || !target) return 0

            const q = query.toLowerCase()
            const t = target.toLowerCase()
            let qIdx = 0, score = 0, gap = 0, consecutive = 0

            for (let tIdx = 0; tIdx < t.length && qIdx < q.length; tIdx++) {
                if (t[tIdx] === q[qIdx]) {
                    score += 1
                    consecutive++
                    score += consecutive * consecutive * 2
                    if (tIdx === 0 || /[\s\-_.\/]/.test(t[tIdx - 1]))
                        score += 8
                    if (target[tIdx] === query[qIdx])
                        score += 3
                    gap = 0
                    qIdx++
                } else {
                    consecutive = 0
                    gap++
                    if (gap > 2) score -= 1
                }
            }

            if (qIdx < q.length) return 0
            score = score / t.length
            return Math.max(0, score)
        }

        property var hiddenIds: [
            "avahi-discover",
            "cmake-gui",
            "lstopo",
            "mpv",
            "qv4l2",
            "qvidcap",
            "bssh",
            "bvnc"
        ]

        function search() {
            let query = searchBox.text.trim()
            let appsList = allApps

            appResults = []

            if (query.length === 0) {
                appResults = Array.from(appsList).sort((a, b) => a.name.localeCompare(b.name))
            } else {
                let scored = []

                for (let entry of appsList) {
                    let score = fuzzyScore(query, entry.name)
                    if (entry.genericName) {
                        let genScore = fuzzyScore(query, entry.genericName) * 0.5
                        if (genScore > score) score = genScore
                    }
                    if (score > 0)
                        scored.push({ entry, score })
                }

                scored.sort((a, b) => b.score - a.score)
                appResults = scored.map(r => r.entry)
            }

            appResults = appResults.filter(entry =>
                !entry.noDisplay && !hiddenIds.includes(entry.id)
            )

            filteredApps.clear()
            for (let entry of appResults) {
                filteredApps.append({ name: entry.name, genericName: entry.genericName, icon: entry.icon, runInTerminal: entry.runInTerminal })
            }

            list.currentIndex = 0
        }

        // Updates reacts on new apps
        Connections {
            target: DesktopEntries.applications
            function onObjectInsertedPost(object, index) {
                launcher.search()
            }
        }

        // Populates the list at creation time
        Component.onCompleted: launcher.search()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 40
                radius: 12
                color: Colors.background

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Text {
                        font.family: root.font
                        text: "󰘳"
                        color: Colors.color6
                        font.pixelSize: 16
                    }

                    TextField {
                        id: searchBox

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        background: Item {}
                        placeholderText: "Search applications..."
                        placeholderTextColor: Colors.color6
                        color: Colors.foreground
                        font.pixelSize: 14
                        focus: true

                        Component.onCompleted: searchBox.forceActiveFocus()

                        onTextChanged: launcher.search()

                        Keys.onReturnPressed: (event) => {
                            let app = launcher.appResults[list.currentIndex]
                            if (app) launcher.launchEntry(app)
                            event.accepted = true
                        }

                        Keys.onDownPressed: (event) => {
                            list.incrementCurrentIndex()
                            event.accepted = true
                        }
                        Keys.onUpPressed: (event) => {
                            list.decrementCurrentIndex()
                            event.accepted = true
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: list

                    anchors.fill: parent

                    currentIndex: 0

                    model: launcher.filteredApps
                    clip: true
                    spacing: 4

                    delegate: Rectangle {
                        id: entry
                        required property var modelData
                        required property int index

                        width: list.width
                        implicitHeight: 44
                        radius: 12

                        color: index === list.currentIndex ? Colors.foreground : "transparent"
                        scale: index === list.currentIndex ? 1 : 0.98

                        Behavior on scale {
                            NumberAnimation {
                                duration: 80
                                easing.type: Easing.OutCubic
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                                easing.type: Easing.OutCubic
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 10

                            Image {
                                Layout.preferredWidth: 28
                                Layout.preferredHeight: 28

                                source: Quickshell.iconPath(entry.modelData.icon)
                                fillMode: Image.PreserveAspectFit
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6

                                    Text {
                                        text: entry.modelData.name
                                        color: entry.index === list.currentIndex ? Colors.background : Colors.foreground
                                        font.pixelSize: 13
                                        font.bold: true
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        font.family: root.font
                                        text: ""
                                        color: entry.index === list.currentIndex ? Colors.background : Colors.color6
                                        font.pixelSize: 11
                                        visible: entry.modelData.runInTerminal
                                    }
                                }

                                Text {
                                    text: entry.modelData.genericName
                                    color: entry.index === list.currentIndex ? Colors.background : Colors.color6
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                    visible: entry.modelData.genericName
                                }
                            }
                        }

                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                let app = launcher.appResults[entry.index]
                                console.log("Launching " + app.name)
                                launcher.launchEntry(app)
                            }
                            onEntered: list.currentIndex = entry.index
                        }
                    }
                }

                Rectangle {
                    z: 2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 50
                    opacity: list.contentY > 0 ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Colors.background }
                        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0) }
                    }
                }

                Rectangle {
                    z: 2
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 50
                    opacity: list.contentY < list.contentHeight - list.height ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 100 } }
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0) }
                        GradientStop { position: 1.0; color: Colors.background }
                    }
                }
            }
        }
    }
}