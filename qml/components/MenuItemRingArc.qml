import QtQuick 2.0

import LunaNext.Common 0.1

Item {
    id: root
    property real arcLength: Math.PI/3
    property real arcOffset: 0
    property real ringWidth: Units.gu(6);

    property Item backgroundImage

    property ExclusiveGroup group: ExclusiveGroup { currentIndexInGroup: -1 }
    property int indexInGroup: 0
    property bool isSelected: group.currentIndexInGroup === root.indexInGroup

    property string text: ""
    property string menuImageUrl: ""

    signal clicked

    ShaderEffectSource {
        // draws an arc of the desired arc-length
        id: canvasItem
        anchors.fill: parent

        // rotate the arc to be at the wanted offset
        rotation: root.arcOffset*180/Math.PI
        transformOrigin: Item.Center

        sourceItem: backgroundImage

        property real outterRadius: canvasItem.width/2-Units.gu(0.5)
        property real innerRadius: outterRadius-ringWidth

        Item {
            x: canvasItem.width/2 + Math.cos(arcLength)*canvasItem.innerRadius
            y: canvasItem.height/2
            width: canvasItem.outterRadius - Math.cos(arcLength)*canvasItem.innerRadius
            height: Math.tan(arcLength)*canvasItem.innerRadius
            rotation: -canvasItem.rotation

            Text {
                visible: root.text !== ""

                anchors.fill: parent
                text: root.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Image {
                visible: menuImageUrl !== ""

                height: 0.75*Math.cos(arcLength)*Math.min(parent.width, parent.height);
                width: height
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: menuImageUrl
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    group.currentIndexInGroup = root.indexInGroup;
                    root.clicked()
                }
            }
        }
    }
}
