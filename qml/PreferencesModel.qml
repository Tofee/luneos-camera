import QtQuick 2.6
import QtMultimedia 5.5

// The goal of this object is to handle the storage of the settings, and
// keep them in sync with the camera state
QtObject {
    id: settings

    property int position: Camera.BackFace
    property int captureMode: Camera.CaptureStillImage
    property int flashMode: Camera.FlashAuto
    property int videoFlashMode: Camera.FlashOff
    property bool gpsEnabled: false
    property bool hdrEnabled: false
    property int selfTimerDelay: 0
    property size photoResolution: Qt.size(0,0)
    property size videoResolution: Qt.size(0,0)
    property int encodingQuality: 2 // QMultimedia.NormalQuality
    property bool gridEnabled: false
    property bool preferRemovableStorage: false
    property bool playShutterSound: true

    property ListModel photoResolutionOptionsModel: ListModel {
        function indexOf(resolution) {
            for(var i=0; i<count; ++i) {
                if(get(i).resolution === resolution) return i;
            }
            return -1;
        }
        function getAsSize(i) {
            var elt=get(i);
            return Qt.size(elt.width, elt.height);
        }
        function appendSize(size) {
            append({"resolution": {"width": size.width, "height": size.height }})
        }
        function insertSize(i, size) {
            insert(i, {"resolution": {"width": size.width, "height": size.height }})
        }
    }
    property ListModel videoResolutionOptionsModel: ListModel {
        function indexOf(resolution) {
            for(var i=0; i<count; ++i) {
                if(get(i).resolution === resolution) return i;
            }
            return -1;
        }
    }

    onFlashModeChanged: if (flashMode != Camera.FlashOff) hdrEnabled = false;
    onHdrEnabledChanged: if (hdrEnabled) flashMode = Camera.FlashOff

    function resolutionToLabel(resolution) {
        // takes in a resolution string (e.g. 1920x1080) and returns a nicer
        // form of it for display in the UI: "1080p"
        return resolution.height + "p";
    }


    function getAutomaticResolution(fittingResolution, maximumResolution) {
        if (isResolutionAnOption(fittingResolution)) {
            return fittingResolution;
        } else {
            return maximumResolution;
        }
    }

    function isResolutionAnOption(resolution) {
        for (var i=0; i<photoResolutionOptionsModel.count; i++) {
            var option = photoResolutionOptionsModel.getAsSize(i);
            if (option.value === resolution) {
                return true;
            }
        }
        return false;
    }

    function isWellKnown(resolution) {
        // Try to only display well known resolutions: 1080p, 720p and 480p
        return ( resolution === Qt.size(1920,1080) ||
                 resolution === Qt.size(1280,720)  ||
                 resolution === Qt.size(640,480) );
    }

    function setPhotoResolution(resolution) {
        if (resolution.width > 0 && resolution.height > 0)
            settings.photoResolution = resolution;
    }

    function updateVideoResolutionOptions(videoSupportedResolutions) {
        // Clear and refill videoResolutionOptionsModel with available resolutions
        videoResolutionOptionsModel.clear();
        var supported = videoSupportedResolutions;

        supported = supported.slice().sort(function(a, b) {
            return a.width - b.width;
        });

        var foundCurrentResolution = false;
        for (var i=0; i<supported.length; i++) {
            if (isWellKnown(supported[i])) {
                videoResolutionOptionsModel.insertSize(0, supported[i]);
                if(settings.videoResolution === supported[i]) foundCurrentResolution = true;
            }
        }

        // If resolution setting chosen is not supported select the highest available resolution
        if (supported.length > 0 && !foundCurrentResolution) {
            settings.videoResolution = supported.getAsSize(supported.count - 1);
        }
    }

    function updatePhotoResolutionOptions(maximumResolution, fittingResolution, cameraDeviceId) {
        // Clear and refill photoResolutionOptionsModel with available resolutions
        photoResolutionOptionsModel.clear();
/*
        var optionMaximum = {"icon": "",
                             "label": "%1 (%2MP)".arg(sizeToAspectRatio(maximumResolution))
                                                 .arg(sizeToMegapixels(maximumResolution)),
                             "value": sizeToString(maximumResolution)};

        var optionFitting = {"icon": "",
                             "label": "%1 (%2MP)".arg(sizeToAspectRatio(fittingResolution))
                                                 .arg(sizeToMegapixels(fittingResolution)),
                             "value": sizeToString(fittingResolution)};
*/
        photoResolutionOptionsModel.appendSize(maximumResolution);


        // Only show optionFitting if it's greater than 50% of the maximum available resolution
        var fittingSize = fittingResolution.width * fittingResolution.height;
        var maximumSize = maximumResolution.width * maximumResolution.height;
        if (fittingResolution !== maximumResolution &&
            fittingSize / maximumSize >= 0.5) {
            photoResolutionOptionsModel.appendSize(fittingResolution);
        }

        // If resolution setting is not supported select the resolution automatically
        if (!isResolutionAnOption(settings.photoResolution)) {
            setPhotoResolution(getAutomaticResolution(maximumResolution, fittingResolution));
        }
    }

}
