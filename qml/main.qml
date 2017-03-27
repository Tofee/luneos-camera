import QtQuick 2.9
import QtQuick.Window 2.2

import LunaNext.Common 0.1

import "components"

Window {
    visible: true

    width: 600
    height: 800

    PreferencesModel {
        id: preferences
    }
    /* Model of the captured phots/videos during this session */
    ListModel {
        id: capturedFilesModel

        function addFileToGallery(iPath)
        {
            capturedFilesModel.append({filepath: iPath});
            console.log("file added: "+iPath);
        }
    }

    CameraView {
        id: cameraViewItem

        width: parent.width
        height: parent.height

        prefs: preferences

        onImageCaptured: captureOverlayItem.setLastCapturedImage(preview);
        onCaptureDone: capturedFilesModel.addFileToGallery(filepath);
    }

    CaptureOverlay {
        id: captureOverlayItem

        width: parent.width
        height: parent.height

        camera: cameraViewItem.cameraItem
        prefs: preferences

        onGalleryButtonClicked: switcherListView.currentIndex = 2
    }

    PreferencesOverlay {
        id: preferencesOverlay

        width: parent.width
        height: parent.height

        prefs: preferences
    }
}
