import QtQuick 2.0
import QtMultimedia 5.5

import LunaNext.Common 0.1

import "components"

Rectangle {
    color: "transparent"
    //color: "#E5E5E5"

    property PreferencesModel preferencesModel;

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
            Repeater {
                model: [ "Front", "Back" ]
                delegate: LuneOSButtonElement {
                    height: parent.height
                    width: Units.gu(6)
                    imageSource: ""; text: modelData
                    group: exclusiveGroupSide
                }
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
            Repeater {
                model: [ "0s", "3s", "10s", "15s" ]
                delegate:  LuneOSButtonElement {
                    height: parent.height
                    width: height
                    imageSource: Qt.resolvedUrl("images/self_timer.svg");
                    group: exclusiveGroupTimer

                    Text {
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        text: modelData
                        font.bold: true
                        font.pixelSize: parent.height*0.3
                    }
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
            Repeater {
                model: [ "", Qt.resolvedUrl("images/grid_lines.svg") ]
                delegate: LuneOSButtonElement {
                    height: parent.height
                    width: Units.gu(6)
                    imageSource: modelData; text: modelData === "" ? "None" : ""
                    group: exclusiveGroupGrid
                }
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
            Repeater {
                model: [ Qt.resolvedUrl("images/shutter_stills@27.png"), Qt.resolvedUrl("images/record_video@27.png") ]
                delegate: LuneOSButtonElement {
                height: parent.height
                    width: parent.height
                    //width: Units.gu(6)
                    //imageSource: ""; text: "Photo"
                    imageSource: modelData
                    group: exclusiveGroupPhotoVideo
                }
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
            Repeater {
                model: ListModel {
                    ListElement { width: 6; text: "Auto" }
                    ListElement { width: 9; text: "No Flash" }
                    ListElement { width: 6; text: "Flash" }
                }

                delegate: LuneOSButtonElement {
                    height: parent.height
                    width: Units.gu(model.width)
                    imageSource: ""; text: model.text
                    group: exclusiveGroupFlash
                }
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
            Repeater {
                model: ListModel {
                    ListElement { width: 6; text: "Low" }
                    ListElement { width: 9; text: "Medium" }
                    ListElement { width: 6; text: "High" }
                }

                delegate: LuneOSButtonElement {
                    height: parent.height
                    width: Units.gu(model.width)
                    imageSource: ""; text: model.text
                    group: exclusiveGroupQuality
                }
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
            Repeater {
                model: ListModel {
                    ListElement { width: 6; text: "Auto" }
                    ListElement { width: 7; text: "Sepia" }
                    ListElement { width: 9; text: "Cloudy" }
                }

                delegate: LuneOSButtonElement {
                    height: parent.height
                    width: Units.gu(model.width)
                    imageSource: ""; text: model.text
                    group: exclusiveGroupEffect
                }
            }
        }
    }
}
