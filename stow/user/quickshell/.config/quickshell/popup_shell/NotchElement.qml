import QtQuick

Item {
    required property bool visibleInNotch

    opacity: visibleInNotch ? 1 : 0

    transitions: [
        Transition {
            from: "0"
            to: "1"

            NumberAnimation {
                property: "opacity"
                duration: 400
                easing.type: Easing.OutCubic
            }
        },
        Transition {
            from: "1"
            to: "0"

            NumberAnimation {
                property: "opacity"
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    ]
}