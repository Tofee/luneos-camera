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

    property PreferencesModel prefs;
    property alias cameraItem: camera

    Camera {
        id: camera

        captureMode: prefs.captureMode
        position: prefs.position

        flash {
            mode: camera.captureMode === Camera.CaptureStillImage ? prefs.flashMode :
                     camera.captureMode === Camera.CaptureVideo ? prefs.videoFlashMode :
                        CameraFlash.FlashOff
        }

        focus.focusMode: Camera.FocusContinuous

        Component.onCompleted: {
            updateResolutionOptions();
        }


        imageCapture {
            resolution: prefs.photoResolutionOptionsModel.getAsSize(prefs.photoResolutionIndex)

            onResolutionChanged: {
                // FIXME: this is a necessary workaround because:
                // - Neither camera.viewfinder.resolution nor camera.advanced.resolution
                //   emit a changed signal when the underlying AalViewfinderSettingsControl's
                //   resolution changes
                // - we know that qtubuntu-camera changes the resolution of the
                //   viewfinder automatically when the capture resolution is set
                // - we need camera.viewfinder.resolution to hold the right
                //   value
                camera.viewfinder.resolution = camera.advanced.resolution;
            }

            onImageCaptured: {
                cameraViewRoot.imageCaptured(preview)
            }
            onImageSaved: {
                cameraViewRoot.captureDone(path);
            }
        }
        videoRecorder {
            outputLocation: StorageLocations.videosLocation;
            resolution: prefs.videoResolutionOptionsModel.getAsSize(prefs.videoResolutionIndex)

            onResolutionChanged: {
                // FIXME: see workaround setting camera.viewfinder.resolution above
                camera.viewfinder.resolution = camera.advanced.resolution;
            }
        }

        imageProcessing {
            colorFilter: CameraImageProcessing.ColorFilterGrayscale
            whiteBalanceMode: CameraImageProcessing.WhiteBalanceTungsten
            contrast: 0.66
            saturation: -0.5
        }

        property AdvancedCameraSettings advanced: AdvancedCameraSettings {
            camera: cameraViewRoot.cameraItem
            hdrEnabled: prefs.hdrEnabled
            encodingQuality: prefs.encodingQuality

            onVideoSupportedResolutionsChanged: prefs.updateVideoResolutionOptions(camera.advanced.videoSupportedResolutions);
            onFittingResolutionChanged: prefs.updatePhotoResolutionOptions(camera.advanced.maximumResolution, camera.advanced.fittingResolution);
            onMaximumResolutionChanged: prefs.updatePhotoResolutionOptions(camera.advanced.maximumResolution, camera.advanced.fittingResolution);
        }

        function updateResolutionOptions() {
            prefs.updateVideoResolutionOptions(camera.advanced.videoSupportedResolutions);
            prefs.updatePhotoResolutionOptions(camera.advanced.maximumResolution, camera.advanced.fittingResolution);
            // FIXME: see workaround setting camera.viewfinder.resolution above
            camera.viewfinder.resolution = camera.advanced.resolution;
        }

        onDeviceIdChanged: {
            updateResolutionOptions();
        }

        onCaptureModeChanged: {
            // FIXME: see workaround setting camera.viewfinder.resolution above
            camera.viewfinder.resolution = camera.advanced.resolution;
        }

        onError: console.warn("Camera ERROR " + errorCode + ": " + errorString);
    }

    VideoOutput {
        id: videoOutputView
        source: camera
        anchors.fill: parent
        focus: visible
        fillMode: VideoOutput.PreserveAspectCrop

        orientation: camera.position === Camera.BackFace ? -camera.orientation : camera.orientation
    }
    GridLines {
        anchors.fill: parent
        visible: prefs.gridEnabled
    }
}
