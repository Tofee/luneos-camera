import QtQuick 2.0
import QtMultimedia 5.5

import LunaNext.Common 0.1

import "components"

Rectangle {
    color: "transparent"
    //color: "#E5E5E5"

    property Camera camera
    property CaptureOverlay captureOverlay

    // Possible preferences:
    //  - front/back
    //  - timer
    //  - grid
    //  - photo/video
    //  - flash
    //  - ISO quality
    //  - effect
    QtObject {
        id: prefs
        /* 0: front, 1: back */
        property int side: 1;
        /* 0: 0s, 1: 3s, 2: 10s, 3: 15s */
        property int timer: 0
        /* 0: no grid, 1: grid */
        property int grid: 0
        /* 0: photo, 1: video */
        property int photoVideo: 0
        /* 0: automatic, 1: no flash, 2: flash */
        property int flash: 0
        /* 0: low, 1: medium, 2: high */
        property int isoQuality: 2
        /* 0: automatic, 1: sepia, 2:  */
        property int effect: 0

        onSideChanged: {
            if(side === 0) camera.position = Camera.FrontFace
            else if(side === 1) camera.position = Camera.BackFace
        }
        onTimerChanged: {
            if(timer === 0) captureOverlay.captureTimeout = 0
            else if(timer === 1) captureOverlay.captureTimeout = 3
            else if(timer === 2) captureOverlay.captureTimeout = 10
            else if(timer === 3) captureOverlay.captureTimeout = 15
        }
        onGridChanged: {
            captureOverlay.showGrid = (grid === 1);
        }
    }

    Column {
        width: parent.width
        spacing: Units.gu(0.5)
        Text {
            text: "Preferences"
            font.pixelSize: Units.gu(4);
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            ExclusiveGroup {
                id: exclusiveGroupSide
                currentIndexInGroup: prefs.side
                onCurrentIndexInGroupChanged: prefs.side = currentIndexInGroup
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "Front"
                group: exclusiveGroupSide
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "Back"
                group: exclusiveGroupSide
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            ExclusiveGroup {
                id: exclusiveGroupTimer
                currentIndexInGroup: prefs.timer
                onCurrentIndexInGroupChanged: prefs.timer = currentIndexInGroup
            }
            LuneOSButtonElement {
                height: parent.height
                width: height
                imageSource: Qt.resolvedUrl("images/self_timer.svg");
                group: exclusiveGroupTimer

                Text {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    text: "0"
                    font.bold: true
                    font.pixelSize: parent.height*0.3
                }
            }
            LuneOSButtonElement {
                height: parent.height
                width: height
                imageSource: Qt.resolvedUrl("images/self_timer.svg");
                group: exclusiveGroupTimer

                Text {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    text: "3"
                    font.bold: true
                    font.pixelSize: parent.height*0.3
                }
            }
            LuneOSButtonElement {
                height: parent.height
                width: height
                imageSource: Qt.resolvedUrl("images/self_timer.svg");
                group: exclusiveGroupTimer

                Text {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    text: "10"
                    font.bold: true
                    font.pixelSize: parent.height*0.3
                }
            }
            LuneOSButtonElement {
                height: parent.height
                width: height
                imageSource: Qt.resolvedUrl("images/self_timer.svg");
                group: exclusiveGroupTimer

                Text {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    text: "15"
                    font.bold: true
                    font.pixelSize: parent.height*0.3
                }
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            ExclusiveGroup {
                id: exclusiveGroupGrid
                currentIndexInGroup: prefs.grid
                onCurrentIndexInGroupChanged: prefs.grid = currentIndexInGroup
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "None"
                group: exclusiveGroupGrid
            }
            LuneOSButtonElement {
                height: parent.height
                width: height
                imageSource: Qt.resolvedUrl("images/grid_lines.svg");
                group: exclusiveGroupGrid
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            ExclusiveGroup {
                id: exclusiveGroupPhotoVideo
                currentIndexInGroup: prefs.photoVideo
                onCurrentIndexInGroupChanged: prefs.photoVideo = currentIndexInGroup
            }
            LuneOSButtonElement {
                height: parent.height
                width: parent.height
                //width: Units.gu(6)
                //imageSource: ""; text: "Photo"
                imageSource: Qt.resolvedUrl("images/shutter_stills@27.png")
                group: exclusiveGroupPhotoVideo
            }
            LuneOSButtonElement {
                height: parent.height
                width: parent.height
                //width: Units.gu(6)
                //imageSource: ""; text: "Photo"
                imageSource: Qt.resolvedUrl("images/record_video@27.png")
                group: exclusiveGroupPhotoVideo
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            ExclusiveGroup {
                id: exclusiveGroupFlash
                currentIndexInGroup: prefs.flash
                onCurrentIndexInGroupChanged: prefs.flash = currentIndexInGroup
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "Auto"
                group: exclusiveGroupFlash
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(9)
                imageSource: ""; text: "No Flash"
                group: exclusiveGroupFlash
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "Flash"
                group: exclusiveGroupFlash
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            ExclusiveGroup {
                id: exclusiveGroupQuality
                currentIndexInGroup: prefs.isoQuality
                onCurrentIndexInGroupChanged: prefs.isoQuality = currentIndexInGroup
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "Low"
                group: exclusiveGroupQuality
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(9)
                imageSource: ""; text: "Medium"
                group: exclusiveGroupQuality
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "High"
                group: exclusiveGroupQuality
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            ExclusiveGroup {
                id: exclusiveGroupEffect
                currentIndexInGroup: prefs.effect
                onCurrentIndexInGroupChanged: prefs.effect = currentIndexInGroup
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "Auto"
                group: exclusiveGroupEffect
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(9)
                imageSource: ""; text: "Sepia"
                group: exclusiveGroupEffect
            }
            LuneOSButtonElement {
                height: parent.height
                width: Units.gu(6)
                imageSource: ""; text: "Cloudy"
                group: exclusiveGroupEffect
            }
        }
    }
}
