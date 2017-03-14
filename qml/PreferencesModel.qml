import QtQuick 2.6
import QtMultimedia 5.5

Item {
    id: viewFinderOverlay

    property Camera camera
    property var settings: settings

    QtObject {
        id: settings

        property int flashMode: Camera.FlashAuto
        property bool gpsEnabled: false
        property bool hdrEnabled: false
        property int videoFlashMode: Camera.FlashOff
        property int selfTimerDelay: 0
        property int encodingQuality: 2 // QMultimedia.NormalQuality
        property bool gridEnabled: false
        property bool preferRemovableStorage: false
        property string videoResolution: "1920x1080"
        property bool playShutterSound: true
        property var photoResolutions

        Component.onCompleted: if (!photoResolutions) photoResolutions = {}
        onFlashModeChanged: if (flashMode != Camera.FlashOff) hdrEnabled = false;
        onHdrEnabledChanged: if (hdrEnabled) flashMode = Camera.FlashOff
    }

    Binding {
        target: camera.flash
        property: "mode"
        value: settings.flashMode
        when: camera.captureMode == Camera.CaptureStillImage
    }

    Binding {
        target: camera.flash
        property: "mode"
        value: settings.videoFlashMode
        when: camera.captureMode == Camera.CaptureVideo
    }

    Binding {
        target: camera.advanced
        property: "hdrEnabled"
        value: settings.hdrEnabled
    }

    Binding {
        target: camera.advanced
        property: "encodingQuality"
        value: settings.encodingQuality
    }

    Binding {
        target: camera.videoRecorder
        property: "resolution"
        value: settings.videoResolution
    }

    Binding {
        target: camera.imageCapture
        property: "resolution"
        value: settings.photoResolutions[camera.deviceId]
    }

    Connections {
        target: camera.imageCapture
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
    }

    Connections {
        target: camera.videoRecorder
        onResolutionChanged: {
            // FIXME: see workaround setting camera.viewfinder.resolution above
            camera.viewfinder.resolution = camera.advanced.resolution;
        }
    }

    Connections {
        target: camera
        onCaptureModeChanged: {
            // FIXME: see workaround setting camera.viewfinder.resolution above
            camera.viewfinder.resolution = camera.advanced.resolution;
        }
    }

    /*
    function resolutionToLabel(resolution) {
        // takes in a resolution string (e.g. "1920x1080") and returns a nicer
        // form of it for display in the UI: "1080p"
        return resolution.split("x").pop() + "p";
    }

    function sizeToString(size) {
        return size.width + "x" + size.height;
    }

    function stringToSize(resolution) {
        var r = resolution.split("x");
        return Qt.size(r[0], r[1]);
    }

    function sizeToAspectRatio(size) {
        var ratio = Math.max(size.width, size.height) / Math.min(size.width, size.height);
        var maxDenominator = 12;
        var epsilon;
        var numerator;
        var denominator;
        var bestDenominator;
        var bestEpsilon = 10000;
        for (denominator = 2; denominator <= maxDenominator; denominator++) {
            numerator = ratio * denominator;
            epsilon = Math.abs(Math.round(numerator) - numerator);
            if (epsilon < bestEpsilon) {
                bestEpsilon = epsilon;
                bestDenominator = denominator;
            }
        }
        numerator = Math.round(ratio * bestDenominator);
        return "%1:%2".arg(numerator).arg(bestDenominator);
    }

    function sizeToMegapixels(size) {
        var megapixels = (size.width * size.height) / 1000000;
        return parseFloat(megapixels.toFixed(1))
    }

    function updateVideoResolutionOptions() {
        // Clear and refill videoResolutionOptionsModel with available resolutions
        // Try to only display well known resolutions: 1080p, 720p and 480p
        videoResolutionOptionsModel.clear();
        var supported = camera.advanced.videoSupportedResolutions;
        var wellKnown = ["1920x1080", "1280x720", "640x480"];

        supported = supported.slice().sort(function(a, b) {
            return a.split("x")[0] - b.split("x")[0];
        });

        for (var i=0; i<supported.length; i++) {
            var resolution = supported[i];
            if (wellKnown.indexOf(resolution) !== -1) {
                var option = {"icon": "",
                              "label": resolutionToLabel(resolution),
                              "value": resolution};
                videoResolutionOptionsModel.insert(0, option);
            }
        }

        // If resolution setting chosen is not supported select the highest available resolution
        if (supported.length > 0 && supported.indexOf(settings.videoResolution) == -1) {
            settings.videoResolution = supported[supported.length - 1];
        }
    }

    function updatePhotoResolutionOptions() {
        // Clear and refill photoResolutionOptionsModel with available resolutions
        photoResolutionOptionsModel.clear();

        var optionMaximum = {"icon": "",
                             "label": "%1 (%2MP)".arg(sizeToAspectRatio(camera.advanced.maximumResolution))
                                                 .arg(sizeToMegapixels(camera.advanced.maximumResolution)),
                             "value": sizeToString(camera.advanced.maximumResolution)};

        var optionFitting = {"icon": "",
                             "label": "%1 (%2MP)".arg(sizeToAspectRatio(camera.advanced.fittingResolution))
                                                 .arg(sizeToMegapixels(camera.advanced.fittingResolution)),
                             "value": sizeToString(camera.advanced.fittingResolution)};

        photoResolutionOptionsModel.insert(0, optionMaximum);

        // Only show optionFitting if it's greater than 50% of the maximum available resolution
        var fittingSize = camera.advanced.fittingResolution.width * camera.advanced.fittingResolution.height;
        var maximumSize = camera.advanced.maximumResolution.width * camera.advanced.maximumResolution.height;
        if (camera.advanced.fittingResolution != camera.advanced.maximumResolution &&
            fittingSize / maximumSize >= 0.5) {
            photoResolutionOptionsModel.insert(1, optionFitting);
        }

        // If resolution setting is not supported select the resolution automatically
        var photoResolution = settings.photoResolutions[camera.deviceId];
        if (!isResolutionAnOption(photoResolution)) {
            setPhotoResolution(getAutomaticResolution());
        }
    }

    function setPhotoResolution(resolution) {
        var size = stringToSize(resolution);
        if (size.width > 0 && size.height > 0
            && resolution != settings.photoResolutions[camera.deviceId]) {
            settings.photoResolutions[camera.deviceId] = resolution;
            // FIXME: resetting the value of the property 'photoResolutions' is
            // necessary to ensure that a change notification signal is emitted
            settings.photoResolutions = settings.photoResolutions;
        }
    }

    function getAutomaticResolution() {
        var fittingResolution = sizeToString(camera.advanced.fittingResolution);
        var maximumResolution = sizeToString(camera.advanced.maximumResolution);
        if (isResolutionAnOption(fittingResolution)) {
            return fittingResolution;
        } else {
            return maximumResolution;
        }
    }

    function isResolutionAnOption(resolution) {
        for (var i=0; i<photoResolutionOptionsModel.count; i++) {
            var option = photoResolutionOptionsModel.get(i);
            if (option.value == resolution) {
                return true;
            }
        }
        return false;
    }

    function updateResolutionOptions() {
        updateVideoResolutionOptions();
        updatePhotoResolutionOptions();
        // FIXME: see workaround setting camera.viewfinder.resolution above
        camera.viewfinder.resolution = camera.advanced.resolution;
    }

    Connections {
        target: camera.advanced
        onVideoSupportedResolutionsChanged: updateVideoResolutionOptions();
        onFittingResolutionChanged: updatePhotoResolutionOptions();
        onMaximumResolutionChanged: updatePhotoResolutionOptions();
    }

    Connections {
        target: camera
        onDeviceIdChanged: {
            var hasPhotoResolutionSetting = (settings.photoResolutions[camera.deviceId] != "")
            // FIXME: use camera.advanced.imageCaptureResolution instead of camera.imageCapture.resolution
            // because the latter is not updated when the backend changes the resolution
            setPhotoResolution(sizeToString(camera.advanced.imageCaptureResolution));
            settings.videoResolution = sizeToString(camera.advanced.videoRecorderResolution);
            updateResolutionOptions();

            // If no resolution has ever been chosen, select one automatically
            if (!hasPhotoResolutionSetting) {
                setPhotoResolution(getAutomaticResolution());
            }
        }
    }
    */
}
