import QtQuick 2.0

import LunaNext.Common 0.1

Item {
    id: root
    property real arcLength: Math.PI/3
    property real arcOffset: 0

    property real ringWidth: Units.gu(6);

    property color innerGradientColor: isSelected ? Qt.rgba(0.42, 0.63, 0.76, 1.0) : Qt.rgba(0.93, 0.93, 0.93, 0.67);
    property color outerGradientColor: isSelected ? Qt.rgba(0.11, 0.28, 0.44, 1.0) : Qt.rgba(0.81, 0.81, 0.81, 0.60);

    property ExclusiveGroup group: ExclusiveGroup { currentIndexInGroup: -1 }
    property int indexInGroup: 0
    property bool isSelected: group.currentIndexInGroup === root.indexInGroup
    onIsSelectedChanged: canvasItem.requestPaint();

    property string text: ""
    property string menuImageUrl: ""

    signal clicked

    Canvas {
        // draws an arc of the desired arc-length
        id: canvasItem
        anchors.fill: parent

        // rotate the arc to be at the wanted offset
        rotation: root.arcOffset*180/Math.PI
        transformOrigin: Item.Center

        property real outterRadius: canvasItem.width/2-Units.gu(0.5)
        property real innerRadius: outterRadius-ringWidth

        onPaint: {
            var X = canvasItem.width/2;
            var Y = canvasItem.height/2;

            // 2. get canvas context
            var context = getContext("2d");
            context.clearRect(0,0,canvasItem.width, canvasItem.height);

            // 3. draw donut chart
            setRadialGradient(innerGradientColor, outerGradientColor);
            drawDonut(0, arcLength);

            //*******************************************************//\
            // drawDonut() function drawes 2 full or partial circles inside each other one clockwise and the other is counter-clockwise
            function drawDonut(sRadian, eRadian){

                context.beginPath();
                context.arc(X, Y, outterRadius, sRadian, eRadian, false); // Outer: CCW
                context.arc(X, Y, innerRadius, eRadian, sRadian, true); // Inner: CW
                context.closePath();

                // add shadow
                addShadow();

                context.fill();
            }

            function addShadow(){
                context.shadowColor = "#333";
                context.shadowBlur = Units.gu(0.5);
                context.shadowOffsetX = 0;
                context.shadowOffsetY = 0;
            }

            function setRadialGradient(sgc, bgc){
                var grd = context.createRadialGradient(X, Y, innerRadius + Units.gu(0.5), X, Y, outterRadius);
                grd.addColorStop(0,sgc);
                grd.addColorStop(1,bgc);
                context.fillStyle = grd;
            }
        }

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
