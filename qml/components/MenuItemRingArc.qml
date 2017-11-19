import QtQuick 2.0
import QtGraphicalEffects 1.0

import LunaNext.Common 0.1

import CameraApp 0.1

Item {
    id: root
    property real arcOffset: 0
    property real arcLength: Math.PI/3;
    property real innerRadius: Units.gu(6);

    property color gradientMainColor: isSelected ? Qt.rgba(0.42, 0.63, 0.76, 1.0) : Qt.rgba(0.93, 0.93, 0.93, 0.67);

    property ExclusiveGroup group: ExclusiveGroup { currentIndexInGroup: -1 }
    property int indexInGroup: 0
    property bool isSelected: group.currentIndexInGroup === root.indexInGroup

    property string text: ""
    property string menuImageUrl: ""

    signal clicked

    Item {
        // draws an arc of the desired arc-length
        id: canvasItem
        anchors.fill: parent

        // rotate the arc to be at the wanted offset
        rotation: root.arcOffset*180/Math.PI
        transformOrigin: Item.Center

        property real outterRadius: canvasItem.width/2-Units.gu(0.5)

        MenuPieSlice {
            id: thePieSlice
            anchors.fill: parent
            visible: false

            innerRadius: root.innerRadius
            arcLength: root.arcLength*180/Math.PI
            shadowRadius: pieSliceDropShadow.radius
            color: gradientMainColor
        }
        DropShadow {
            id: pieSliceDropShadow
            anchors.fill: thePieSlice
            horizontalOffset: 0
            verticalOffset: 0
            radius: Units.gu(0.5)
            samples: 6
            color: "#333"
            source: thePieSlice
        }

        Item {
            x: canvasItem.width/2 + Math.cos(root.arcLength)*root.innerRadius
            y: canvasItem.height/2
            width: canvasItem.outterRadius - Math.cos(root.arcLength)*root.innerRadius
            height: Math.tan(root.arcLength)*root.innerRadius
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

                height: 0.75*Math.cos(root.arcLength)*Math.min(parent.width, parent.height);
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
