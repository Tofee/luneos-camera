import QtQuick 2.6
import QtMultimedia 5.5

import LunaNext.Common 0.1

import CameraApp 0.1
import "components"

Item {
    signal captureDone(string filepath);

    Camera {
        id: camera

        captureMode: Camera.CaptureStillImage
        position: Camera.BackFace

        focus.focusMode: Camera.FocusContinuous

        imageCapture {
            onImageCaptured: {
                lastCaptureImage.source = preview
            }
            onImageSaved: {
                captureDone(path);
            }
        }
        videoRecorder {
            outputLocation: StorageLocations.videosLocation;
        }

        onError: console.warn("Camera ERROR " + errorCode + ": " + errorString);
    }

    VideoOutput {
        id: videoOutputView
        source: camera
        anchors.fill: parent
        focus: visible
        fillMode: VideoOutput.PreserveAspectCrop
    }
//    Rectangle {
//        anchors.fill: videoOutputView
//        color: "lightgreen"
//        opacity: 0.6
//    }

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
        }

        // Switch back/front
        Image {
            source: "images/flipcamera.svg"
            height: Units.gu(5);
            width: Units.gu(5);
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    camera.cameraState = Camera.LoadedState;
                    camera.position = (camera.position === Camera.BackFace) ? Camera.FrontFace : Camera.BackFace
                    camera.cameraState = Camera.ActiveState;
                }
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
                    // capture the image!
                    camera.searchAndLock();

                    var outputPath =  StorageLocations.picturesLocation;
                    var dateAsString = new Date().toLocaleString(Qt.locale(), "yyyy-MM-dd-hh-mm-ss");
                    outputPath += "/" + dateAsString;

                    console.log("image storage : " + outputPath);
                    camera.imageCapture.captureToLocation(outputPath);
                }
            }
        }
    }
}
