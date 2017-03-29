import QtQuick 2.0

Canvas {
    // draws an arc of the desired arc-length
    id: canvasItem

    property real arcLength: Math.PI/3
    property real ringWidth: 50;
    property real shadowRadius: 5

    property color innerGradientColor: isSelected ? Qt.rgba(0.42, 0.63, 0.76, 1.0) : Qt.rgba(0.93, 0.93, 0.93, 0.67);
    property color outerGradientColor: isSelected ? Qt.rgba(0.11, 0.28, 0.44, 1.0) : Qt.rgba(0.81, 0.81, 0.81, 0.60);
    property bool isSelected: false

    property real outterRadius: canvasItem.width/2-shadowRadius
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
            context.shadowBlur = shadowRadius;
            context.shadowOffsetX = 0;
            context.shadowOffsetY = 0;
        }

        function setRadialGradient(sgc, bgc){
            var grd = context.createRadialGradient(X, Y, innerRadius + shadowRadius, X, Y, outterRadius);
            grd.addColorStop(0,sgc);
            grd.addColorStop(1,bgc);
            context.fillStyle = grd;
        }
    }
}
