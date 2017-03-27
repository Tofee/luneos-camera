import QtQuick 2.6
import QtMultimedia 5.5

import LunaNext.Common 0.1

import CameraApp 0.1
import "components"

Item {
    property Camera camera

    property QtObject prefs;
    property int captureTimeout: prefs.selfTimerDelay

    signal galleryButtonClicked();
    function setLastCapturedImage(preview) {
        lastCaptureImage.source = preview
    }

    function startCapture() {
        camera.searchAndLock();

        var outputPath =  StorageLocations.picturesLocation;
        var dateAsString = new Date().toLocaleString(Qt.locale(), "yyyy-MM-dd-hh-mm-ss");
        outputPath += "/" + dateAsString;

        console.log("image storage : " + outputPath);

        // start he capture !capture the image!
        timeOutTimer.startTimeout(captureTimeout, function() {
                camera.imageCapture.captureToLocation(outputPath);
                camera.unlock();
            }
        );
    }

    TimeoutTimerText {
        id: timeOutTimer
        anchors.centerIn: parent
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left

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
                imageSource: modelData
                group: exclusiveGroupPhotoVideo
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            height: Units.gu(8);
            width: Units.gu(8);
            Image {
                id: lastCaptureImage
                anchors.fill: parent
                visible: false
            }
            CornerShader {
                id: cornerShader
                z: 2 // above image
                anchors.fill: lastCaptureImage
                sourceItem: lastCaptureImage
                radius: 5*lastCaptureImage.height/90
            }
            MouseArea {
                anchors.fill: parent
                onClicked: galleryButtonClicked();
            }
        }

        // take a photo
        Image {
            source: "images/shutter.svg"
            height: Units.gu(8);
            width: Units.gu(8);
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    startCapture();
                }
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right

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
}
