import QtQuick 2.9
import Eos.Window 0.1

import "components"

WebOSWindow {
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

        //onImageCaptured: (preview) => { captureOverlayItem.setLastCapturedImage(preview); }
        onCaptureDone: (filepath) => {
                           captureOverlayItem.setLastCapturedImage(filepath);
                           capturedFilesModel.addFileToGallery(filepath);
                       }
    }

    CaptureOverlay {
        id: captureOverlayItem

        width: parent.width
        height: parent.height

        captureSession: cameraViewItem.captureSessionItem
        prefs: preferences

//        onGalleryButtonClicked: switcherListView.currentIndex = 2
    }

    PreferencesOverlay {
        id: preferencesOverlay

        width: parent.width
        height: parent.height

        prefs: preferences
    }
}
