import QtQuick 2.6
import QtQuick.Window 2.2
import QtMultimedia 5.5

import LunaNext.Common 0.1

Window {
    visible: true

    width: 600
    height: 800

    Camera {
        id: camera

        captureMode: Camera.CaptureStillImage
        position: Camera.BackFace

        focus.focusMode: Camera.FocusContinuous

        onError: console.warn("Camera ERROR " + errorCode + ": " + errorString);
    }

    VideoOutput {
        source: camera
        anchors.fill: parent
        focus: visible
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

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

                }
            }
        }
    }
}
