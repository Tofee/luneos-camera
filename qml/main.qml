import QtQuick 2.6
import QtQuick.Window 2.2

// for StackView
import QtQuick.Controls 1.4

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

        y: 0
        x: switcherListView.contentX > switcherListView.width ? switcherListView.width - switcherListView.contentX : 0

        prefs: preferences

        onImageCaptured: captureOverlayItem.setLastCapturedImage(preview);
        onCaptureDone: capturedFilesModel.addFileToGallery(filepath);
    }

    ListView {
        id: switcherListView

        anchors.fill: parent

        boundsBehavior: ListView.StopAtBounds
        orientation: ListView.Horizontal
        currentIndex: 1
        highlightFollowsCurrentItem: true
        preferredHighlightBegin: 0
        preferredHighlightEnd: switcherListView.width
        highlightRangeMode: ListView.StrictlyEnforceRange
        snapMode: ListView.SnapOneItem

        model: VisualItemModel {
            PreferencesOverlay {
                id: preferencesOverlay
                height: switcherListView.height; width: switcherListView.width

                prefs: preferences
            }
            CaptureOverlay {
                id: captureOverlayItem
                height: switcherListView.height; width: switcherListView.width

                camera: cameraViewItem.cameraItem
                prefs: preferences

                onGalleryButtonClicked: switcherListView.currentIndex = 2
            }
            /* Gallery component to visualize this session's captured media */
            GalleryView {
                id: galleryView
                height: switcherListView.height; width: switcherListView.width

                model: capturedFilesModel
            }
        }
    }
}
