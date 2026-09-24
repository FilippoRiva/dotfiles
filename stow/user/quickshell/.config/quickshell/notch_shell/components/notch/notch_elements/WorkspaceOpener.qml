pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import '.' as Elements
import '../../../'

Elements.NotchElement {
    id: root
    required property var notch
    implicitHeight: 30

    property var configs: [
        {
            label: "thesis",
            icon: "school",
            commands: [
                "codium -d $(echo $HOME)/projects/thesis"
            ]
        },
        {
            label: "arco",
            icon: "code",
            commands: [
                "session=$(mktemp); printf '%s\\n' 'cd ~/projects/arco' 'launch --title nvim zsh -lic \"exec nvim\"' 'new_tab pi' 'cd ~/projects/arco' 'launch zsh -lic \"exec pi\"' 'new_tab terminal' 'cd ~/projects/arco' 'launch' > \"$session\"; kitty --session \"$session\"; rm -f \"$session\""
            ]
        },
        {
            label: "dotfiles",
            icon: "settings",
            commands: [
                "session=$(mktemp); printf '%s\\n' 'cd ~/dotfiles' 'launch --title nvim zsh -lic \"exec nvim\"' 'new_tab pi' 'cd ~/dotfiles' 'launch zsh -lic \"exec pi\"' 'new_tab terminal' 'cd ~/dotfiles' 'launch' > \"$session\"; kitty --session \"$session\"; rm -f \"$session\""
            ]
        },
        {
            label: "reload",
            icon: "refresh",
            onTriggered: ()=>{Quickshell.reload(true)}
        }
    ]

    RowLayout {
        anchors.centerIn: parent
        spacing: 5

        Repeater {
            model: root.configs

            delegate: Elements.Button {
                required property var modelData
                property var config: modelData
                icon: config.icon
                text: config.label
                fontSize: 14
                backgroundColor: Colors.background2
                button_enabled: true
                buttonWidth: 100

                onActivate: () => {
                    if ( config.commands ) {
                        for (var i = 0; i < config.commands.length; i++) {
                            Quickshell.execDetached(["sh", "-c", config.commands[i]])
                        }
                    } else if (config.onTriggered) {
                        config.onTriggered()
                    }
                    root.notch.setView('default')
                }
            }
        }
    }
}