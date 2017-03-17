import QtQuick 2.0

import LunaNext.Common 0.1

import "components"

Rectangle {
    id: galleryViewItem
    color: "#343434"

    property alias model: flowRepeater.model

    Flickable {
        anchors.fill: parent

        flickableDirection: Flickable.VerticalFlick
        contentHeight: flowView.height

        clip: true

        Flow {
            id: flowView
            width: parent.width
            spacing: Units.gu(0.5)

            Repeater {
                id: flowRepeater

                delegate: Item {
                    width: galleryViewItem.width/3 - flowView.spacing
                    height: width
                    Image {
                        id: filePreviewImage
                        anchors.fill: parent
                        source: filepath
                        visible: false
                    }
                    CornerShader {
                        id: cornerShader
                        z: 2 // above image
                        anchors.fill: filePreviewImage
                        sourceItem: filePreviewImage
                        radius: 5*filePreviewImage.height/90
                    }
                }
            }
        }
    }

/*
    Component {
        id: appDelegate
        Item {
            id: appDelegateItem

            width: galleryViewItem.width * 0.9
            height: width

            scale: PathView.itemScale
            z: PathView.itemZ

            property real rotX: PathView.itemAngle
            transform: Rotation {
                axis { x: 1; y: 0; z: 0 }
                angle: appDelegateItem.rotX;
                origin { x: 32; y: 32; }
            }

            Image {
                anchors.fill: parent
                source: filepath
            }

            MouseArea {
                anchors.fill: parent
                onClicked: view.currentIndex = index
            }
        }
    }

    PathView {
        id: view
        anchors.fill: parent

        delegate: appDelegate

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("click!");
                galleryViewItem.exitGalleryView();
            }
        }
        path: Path {
            startX: galleryViewItem.width/2
            startY: 0

            PathAttribute { name: "itemZ"; value: 0 }
            PathAttribute { name: "itemAngle"; value: -45.0; }
            PathAttribute { name: "itemScale"; value: 0.7; }
            PathLine { x: galleryViewItem.width/2; y: galleryViewItem.height*0.4; }
            PathPercent { value: 0.48; }
            PathLine { x: galleryViewItem.width/2; y: galleryViewItem.height*0.5; }
            PathAttribute { name: "itemAngle"; value: 0.0; }
            PathAttribute { name: "itemScale"; value: 1.0; }
            PathAttribute { name: "itemZ"; value: 100 }
            PathLine { x: galleryViewItem.width/2; y: galleryViewItem.height*0.6; }
            PathPercent { value: 0.52; }
            PathLine { x: galleryViewItem.width/2; y: galleryViewItem.height; }
            PathAttribute { name: "itemAngle"; value: 45.0; }
            PathAttribute { name: "itemScale"; value: 0.7; }
            PathAttribute { name: "itemZ"; value: 0 }
            PathPercent { value: 1.0; }
        }

        pathItemCount: 4
    }
    */
}
