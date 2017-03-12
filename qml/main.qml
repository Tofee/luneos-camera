import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true

    width: 600
    height: 800

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
            PreferencesView {
                height: switcherListView.height; width: switcherListView.width
            }
            CameraView {
                height: switcherListView.height; width: switcherListView.width

                onCaptureDone: galleryView.addFileToGallery(filepath);
            }
            GalleryView {
                id: galleryView
                height: switcherListView.height; width: switcherListView.width
            }
        }
    }
}
