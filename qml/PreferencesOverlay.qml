import QtQuick 2.9
import QtQml.Models 2.3

import LunaNext.Common 0.1

Item {
    property alias prefs: preferencesView.prefs

    // have a blur effect over the viewfinder when prefs are shown
    Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: prefsCarrousselListView.visibleArea.xPosition
    }

    ListView {
        id: prefsCarrousselListView
        anchors.fill: parent
        orientation: ListView.Horizontal
        preferredHighlightBegin: 0
        preferredHighlightEnd: width
        highlightRangeMode: ListView.StrictlyEnforceRange
        model: ObjectModel {
            Item {
                // placeholder to be used when viewfinder is in use
                width: prefsCarrousselListView.width
            }
            PreferencesView {
                id: preferencesView
                width: prefsCarrousselListView.width
                height: prefsCarrousselListView.height
            }
        }
    }
}
