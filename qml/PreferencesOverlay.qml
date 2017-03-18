import QtQuick 2.0
import QtMultimedia 5.5

import LunaNext.Common 0.1

import "components"

Rectangle {
    color: "transparent"
    //color: "#E5E5E5"

    property QtObject prefs;

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
                readonly property var prefsMapping: [ Camera.FrontFace, Camera.BackFace ]
                currentIndexInGroup: prefsMapping.indexOf(prefs.position);
                onCurrentIndexInGroupChanged: prefs.position = prefsMapping[currentIndexInGroup]
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
                readonly property var prefsMapping: [ 0, 3, 10, 15 ]
                currentIndexInGroup: prefsMapping.indexOf(prefs.selfTimerDelay);
                onCurrentIndexInGroupChanged: prefs.selfTimerDelay = prefsMapping[currentIndexInGroup]
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
                readonly property var prefsMapping: [ false, true ]
                currentIndexInGroup: prefsMapping.indexOf(prefs.gridEnabled);
                onCurrentIndexInGroupChanged: prefs.gridEnabled = prefsMapping[currentIndexInGroup]
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
                readonly property var prefsMapping: [ Camera.CaptureStillImage, Camera.CaptureVideo ]
                currentIndexInGroup: prefsMapping.indexOf(prefs.captureMode);
                onCurrentIndexInGroupChanged: prefs.captureMode = prefsMapping[currentIndexInGroup]
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

            visible: prefs.captureMode === Camera.CaptureStillImage

            ExclusiveGroup {
                id: exclusiveGroupFlashPhoto
                readonly property var prefsMapping: [ Camera.FlashAuto, Camera.FlashOff, Camera.FlashOn ]
                currentIndexInGroup: prefsMapping.indexOf(prefs.flashMode);
                onCurrentIndexInGroupChanged: prefs.flashMode = prefsMapping[currentIndexInGroup]
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
                    group: exclusiveGroupFlashPhoto
                }
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            visible: prefs.captureMode === Camera.CaptureVideo

            ExclusiveGroup {
                id: exclusiveGroupFlashVideo
                readonly property var prefsMapping: [ Camera.FlashAuto, Camera.FlashOff, Camera.FlashOn ]
                currentIndexInGroup: prefsMapping.indexOf(prefs.videoFlashMode);
                onCurrentIndexInGroupChanged: prefs.videoFlashMode = prefsMapping[currentIndexInGroup]
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
                    group: exclusiveGroupFlashVideo
                }
            }
        }
        Row {
            id: photoOptionsRow
            anchors.horizontalCenter: parent.horizontalCenter
            height: Units.gu(6)

            visible: prefs.captureMode === Camera.CaptureStillImage && prefs.photoResolutionOptionsModel.count>0

            function sizeToMegapixels(size) {
                var megapixels = (size.width * size.height) / 1000000;
                return parseFloat(megapixels.toFixed(1))
            }

            function sizeToAspectRatio(size) {
                var ratio = Math.max(size.width, size.height) / Math.min(size.width, size.height);
                var maxDenominator = 12;
                var epsilon;
                var numerator;
                var denominator;
                var bestDenominator;
                var bestEpsilon = 10000;
                for (denominator = 2; denominator <= maxDenominator; denominator++) {
                    numerator = ratio * denominator;
                    epsilon = Math.abs(Math.round(numerator) - numerator);
                    if (epsilon < bestEpsilon) {
                        bestEpsilon = epsilon;
                        bestDenominator = denominator;
                    }
                }
                numerator = Math.round(ratio * bestDenominator);
                return "%1:%2".arg(numerator).arg(bestDenominator);
            }

            ExclusiveGroup {
                id: exclusiveGroupQuality
                readonly property ListModel prefsMapping: prefs.photoResolutionOptionsModel
                currentIndexInGroup: Math.max(prefsMapping.indexOf(prefs.photoResolution), 0);
                onCurrentIndexInGroupChanged: prefs.setPhotoResolution(prefsMapping.get(currentIndexInGroup).resolution)
            }
            Repeater {
                model: prefs.photoResolutionOptionsModel

                delegate: LuneOSButtonElement {
                    height: parent.height
                    width: Units.gu(9)
                    imageSource: ""; text: "%1 (%2MP)".arg(photoOptionsRow.sizeToAspectRatio(model.resolution))
                                                      .arg(photoOptionsRow.sizeToMegapixels(model.resolution))
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
