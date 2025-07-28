class WatchFaceView extends WatchUi.WatchFaceView {

    var sharinganFrames = [];
    var currentFrame = 0;
    var animating = false;
    var animationTimer = null;

    function initialize() {
        WatchUi.WatchFaceView.initialize();

        // Wczytaj wszystkie klatki do listy
        for (var i = 0; i < 49; i++) {
            var frameName = "frame_" + Lang.format("%03d", [i]);
            sharinganFrames.add(WatchUi.loadResource(Rez.Image[frameName]));
        }
    }

    function onUpdate(dc) {
        // Tło animacji Sharingana (ostatnia klatka lub aktualna)
        if (animating && currentFrame < sharinganFrames.size()) {
            dc.drawBitmap(0, 0, sharinganFrames[currentFrame]);
        } else {
            dc.drawBitmap(0, 0, sharinganFrames[48]); // statyczna ostatnia klatka
        }

        // Rysowanie godziny
        var time = Time.now();
        var clockTime = time.format("%H:%M");
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 50, Graphics.FONT_XLARGE, clockTime, Graphics.TEXT_JUSTIFY_CENTER);

        // Rysuj inne dane
        drawData(dc, time);
    }

    function drawData(dc, time) {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(10, 140, Graphics.FONT_SMALL, "Date: " + time.format("%d.%m"));

        var hr = Sensor.getHeartRate();
        dc.drawText(10, 160, Graphics.FONT_SMALL, "HR: " + (hr != null ? hr : "--"));

        var steps = Activity.getActivityInfo().steps;
        dc.drawText(10, 180, Graphics.FONT_SMALL, "Steps: " + steps);

        var cals = Activity.getActivityInfo().calories;
        dc.drawText(10, 200, Graphics.FONT_SMALL, "Kcal: " + cals);

        var batt = System.getSystemStats().battery;
        dc.drawText(10, 220, Graphics.FONT_SMALL, "Batt: " + batt + "%");
    }

    function onWake() {
        // Start animacji Sharingana
        currentFrame = 0;
        animating = true;

        animationTimer = new Timer.Timer();
        animationTimer.start(method(:onFrame), 80); // co 80 ms
    }

    function onFrame() {
        if (currentFrame < sharinganFrames.size() - 1) {
            currentFrame += 1;
            WatchUi.requestUpdate();
            animationTimer.start(method(:onFrame), 80);
        } else {
            animating = false;
            currentFrame = 48;
            animationTimer = null;
        }
    }
}
