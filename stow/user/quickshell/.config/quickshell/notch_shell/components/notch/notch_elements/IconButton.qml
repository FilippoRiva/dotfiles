import './' as Elements
import QtQuick
import '../../../'

Elements.TextButton {
    required property string icon
    font: "Material Symbols Rounded"
    text: icon
}