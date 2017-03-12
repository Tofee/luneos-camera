import QtQuick 2.6
import QtMultimedia 5.5

import LunaNext.Common 0.1

import CameraApp 0.1
import "components"

Item {
    id: cameraViewRoot

    signal imageCaptured(variant preview);
    signal captureDone(string filepath);
    signal galleryButtonClicked();

    property alias cameraItem: camera

    Camera {
        id: camera

        captureMode: Camera.CaptureStillImage
        position: Camera.BackFace

        focus.focusMode: Camera.FocusContinuous

        imageCapture {
            onImageCaptured: {
                cameraViewRoot.imageCaptured(preview)
            }
            onImageSaved: {
                cameraViewRoot.captureDone(path);
            }
        }
        videoRecorder {
            outputLocation: StorageLocations.videosLocation;
        }

        imageProcessing {
            colorFilter: CameraImageProcessing.ColorFilterGrayscale
            whiteBalanceMode: CameraImageProcessing.WhiteBalanceTungsten
            contrast: 0.66
            saturation: -0.5
        }
        onError: console.warn("Camera ERROR " + errorCode + ": " + errorString);
    }

    VideoOutput {
        id: videoOutputView
        source: camera
        anchors.fill: parent
        focus: visible
        fillMode: VideoOutput.PreserveAspectCrop

        orientation: camera.orientation
    }
}
