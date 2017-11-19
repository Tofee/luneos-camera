import QtQuick 2.6
import QtQuick.Window 2.2

import LunaNext.Common 0.1

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

        //y: 0
        //x: switcherListView.contentX > switcherListView.width ? switcherListView.width - switcherListView.contentX : 0

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
        height: parent.height; width: parent.width

        prefs: preferences

        visible: opacity>0 ? true : false
        opacity: 1.0
        scale: 0
        transformOrigin: Item.Left

        state: "hidden"
        states: [
            State {
                name: "hidden"
                PropertyChanges { target: preferencesOverlay; opacity: 0; scale: 0 }
            },
            State {
                name: "visible"
                PropertyChanges { target: preferencesOverlay; opacity: 1; scale: 1 }
            }
        ]

        Behavior on scale { NumberAnimation { duration: 300 } }
        Behavior on opacity { NumberAnimation { duration: 200 } }

        onMenuInnerRadiusChanged: console.log("menuInnerRadius = "+menuInnerRadius);
    }
    Rectangle {
        x: preferencesOverlay.menuXOffset/1.5
        anchors.verticalCenter: parent.verticalCenter
        width: preferencesOverlay.menuInnerRadius*2
        height: width
        radius: width/2
        color: "grey"
        opacity: 0.3

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if( preferencesOverlay.state === "visible" )
                    preferencesOverlay.state = "hidden";
                else
                    preferencesOverlay.state = "visible";
            }
        }

        onXChanged: console.log("x="+x);
    }

    /*
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
            Item {
                height: switcherListView.height; width: switcherListView.width
            }
            // Gallery component to visualize this session's captured media
            GalleryView {
                id: galleryView
                height: switcherListView.height; width: switcherListView.width

                model: capturedFilesModel
            }
        }
    }
    */
}
