import QtQuick 2.9
import QtGraphicalEffects 1.0

import LunaNext.Common 0.1

import CameraApp 0.1

Item {
    id: root

    property ExclusiveGroup group: ExclusiveGroup { currentIndexInGroup: -1 }
    property int indexInGroup: 0
    property bool isSelected: group.currentIndexInGroup === root.indexInGroup

    property string text: ""
    property string menuImageUrl: ""

    signal selected
    signal clicked

    Text {
        visible: root.text !== ""

        anchors.fill: parent
        text: root.text
        font.pixelSize: FontUtils.sizeToPixels("16pt")
        font.family: "Prelude"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Image {
        visible: menuImageUrl !== ""

        height: FontUtils.sizeToPixels("16pt")
        width: height
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        source: menuImageUrl
    }
}
