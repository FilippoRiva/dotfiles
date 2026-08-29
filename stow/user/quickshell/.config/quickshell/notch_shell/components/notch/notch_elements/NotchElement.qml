import QtQuick

Item {
    opacity: visible ? 1 : 0

    transitions: [
        Transition {
            from: "0"
            to: "1"

            NumberAnimation {
                property: "opacity"
                duration: 3000
                easing.type: Easing.OutCubic
            }
        },
        Transition {
            from: "1"
            to: "0"

            NumberAnimation {
                property: "opacity"
                duration: 3000
                easing.type: Easing.OutCubic
            }
        }
    ]
}