import QtQuick 2.0

import LunaNext.Common 0.1

Item {
    id: root

    property ExclusiveGroup group: ExclusiveGroup { currentIndexInGroup: Positioner.index }

    property string text: ""
    property string imageSource
    property bool checked: group.currentIndexInGroup == Positioner.index
    property bool canBeUnchecked: false

    property real margins: 6

    opacity: enabled ? 1 : 0.2

    property bool _isFirst: Positioner.isFirstItem
    property bool _isLast: Positioner.isLastItem
    readonly property bool _isSingle: _isFirst && _isLast

    // background
    BorderImage {
        property string _positionButton: _isSingle ? "single" :
                                         _isFirst ? "first" :
                                         _isLast ? "last" : "middle"
        property string _pressed: (mouseArea.pressed || root.checked) ? "-pressed" : ""
        source: "images/radiobutton-"+_positionButton+_pressed+".png"
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
        anchors.fill: parent
    }

    // content
    Image {
        source: imageSource
        anchors.fill: parent
        anchors.margins: root.margins;
    }
    Text {
        visible: root.text !== ""
        text: root.text
        anchors.fill: parent

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        color: (mouseArea.pressed || root.checked) ? "#26282a" : "#353637"
        elide: Text.ElideRight

        font.family: "Prelude"
        font.pixelSize: FontUtils.sizeToPixels("medium")
        font.weight: Font.Light
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if(root.checked && root.canBeUnchecked)
            {
                group.currentIndexInGroup = -1;
            }
            else
            {
                group.currentIndexInGroup = root.Positioner.index;
            }
        }
    }
}
