import QtQuick 2.0

import LunaNext.Common 0.1

Item {
    id: gridlines

    property color lineColor: Qt.rgba(0.8, 0.8, 0.8, 0.8)
    property Gradient lineGradient: Gradient {
        GradientStop { position: 0.0; color: "transparent" }
        GradientStop { position: 0.15; color: lineColor }
        GradientStop { position: 0.85; color: lineColor }
        GradientStop { position: 1.0; color: "transparent" }
    }
    property real thickness: Units.dp(1)

    Rectangle {
        rotation: -90
        transformOrigin: Item.TopLeft
        y: parent.height / 3
        height: parent.width
        width: gridlines.thickness
        gradient: gridlines.lineGradient
    }

    Rectangle {
        rotation: -90
        transformOrigin: Item.TopLeft
        y: 2 * parent.height / 3
        height: parent.width
        width: gridlines.thickness
        gradient: gridlines.lineGradient
    }

    Rectangle {
        x: parent.width / 3
        width: gridlines.thickness
        height: parent.height
        gradient: gridlines.lineGradient
    }

    Rectangle {
        x: 2 * parent.width / 3
        width: gridlines.thickness
        height: parent.height
        gradient: gridlines.lineGradient
    }
}
