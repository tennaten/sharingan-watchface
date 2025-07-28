class WatchFaceApp extends WatchUi.WatchFace {

    function initialize() {
        WatchUi.WatchFace.initialize();
    }

    function onLayout(dc) {
        return new WatchFaceView();
    }
}
