import QtQuick 2.6
import QtMultimedia 5.5

import LunaNext.Common 0.1

import CameraApp 0.1
import "components"

Item {
    property Camera camera
    property int captureTimeout: 0
    property alias showGrid: bgGridImage.visible

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

    GridLines {
        id: bgGridImage
        anchors.fill: parent
        visible: false
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
}
