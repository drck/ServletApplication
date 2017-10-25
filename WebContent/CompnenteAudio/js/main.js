$(function () {
    var $uploadStatus = $('#upload_status'),
    $showLevelButton = $('.show_level'),
    $hideLevelButton = $('.hide_level'),
    $level = $('.control_panel .level');

    var CLASS_CONTROLS = "control_panel";
    var CLASS_RECORDING = "recording";
    var CLASS_PLAYBACK_READY = "playback_ready";
    var CLASS_PLAYING = "playing";
    var CLASS_PLAYBACK_PAUSED = "playback_paused";

    //  Embedding flash object ---------------------------------------------------------------------------------------------

    setUpFormOptions();
    var appWidth = 1;
    var appHeight = 1;
    var flashvars = { 'save_text': '' };

    var params = {};
    var attributes = { 'id': "recorderApp", 'name': "recorderApp" };
    swfobject.embedSWF("recorder.swf", "flashcontent", appWidth, appHeight, "11.0.0", "", flashvars, params, attributes);

    //  Handling FWR events ------------------------------------------------------------------------------------------------

    window.fwr_event_handler = function fwr_event_handler() {


        $('#status').prepend("<div class=\"recorder-event\">" + arguments[0] + "</div>");

//        for (var i = 0; i < arguments.length; i++) {
//            alert(' i: ' + i.toString() + ' - ' + arguments[i].toString());

//        }


        var name, $controls;
        switch (arguments[0]) {
            case "ready":
                var width = parseInt(arguments[1]);
                var height = parseInt(arguments[2]);
                FWRecorder.uploadFormId = "#uploadForm";
                FWRecorder.uploadFieldName = "upload_file[filename]";
                FWRecorder.connect("recorderApp", 0);
                FWRecorder.recorderOriginalWidth = width;
                FWRecorder.recorderOriginalHeight = height;
                FWRecorder.configure(44, 50, 0, 2000);
                FWRecorder.setUseEchoSuppression(true);

                break;

            case "no_microphone_found":
                alert("Microfono no encontrado");
                break;

            case "microphone_user_request":
                recorderEl().addClass("floating");
                FWRecorder.showPermissionWindow();
                break;

            case "microphone_connected":
                FWRecorder.isReady = true;
                $uploadStatus.css({ 'color': '#000' });
                FWRecorder.hide();
                break;

            case "permission_panel_closed":
                FWRecorder.defaultSize();
                //recorderEl().removeClass("floating");	
                recorderEl().addClass("floating_out");
                FWRecorder.hide();
                break;

            case "microphone_activity":
                $('#activity_level').text(arguments[1]);
                break;

            case "recording":
                name = arguments[1];
                $controls = controlsEl(name);
                FWRecorder.hide();
                setControlsClass($controls, CLASS_RECORDING);
                recorderEl().addClass("floating_out");
                
               

                break;

            case "recording_stopped":
                name = arguments[1];
                $controls = controlsEl(name);
                //var duration = arguments[2];
                // FWRecorder.show();
                setControlsClass($controls, CLASS_PLAYBACK_READY);
               // $('#duration').text(duration.toFixed(2));
                recorderEl().addClass("floating_out");

                break;

            case "microphone_level":
                $level.css({ width: arguments[1] * 50 + '%' });
                break;

            case "observing_level":
                // $showLevelButton.hide();
                // $hideLevelButton.show();
                break;

            case "observing_level_stopped":
                // $showLevelButton.show();
                // $hideLevelButton.hide();
                $level.css({ width: 0 });
                break;

            case "playing":
                name = arguments[1];
                $controls = controlsEl(name);
                setControlsClass($controls, CLASS_PLAYING);
                recorderEl().addClass("floating_out");
                break;

            case "playback_started":
                name = arguments[1];
                var latency = arguments[2];
                break;

            case "stopped":
                name = arguments[1];
                $controls = controlsEl(name);
                setControlsClass($controls, CLASS_PLAYBACK_READY);
                recorderEl().addClass("floating_out");

                break;

            case "playing_paused":
                name = arguments[1];
                $controls = controlsEl(name);
                setControlsClass($controls, CLASS_PLAYBACK_PAUSED);
                recorderEl().addClass("floating_out");

                break;

            case "save_pressed":
                FWRecorder.updateForm();
                break;

            case "saving":
                name = arguments[1];
                break;

            case "saved":
                name = arguments[1];
                var data = $.parseJSON(arguments[2]);
                if (data.saved) {
                    $('#upload_status').css({ 'color': '#0F0' }).text(name + " was saved");
                } else {
                    $('#upload_status').css({ 'color': '#F00' }).text(name + " was not saved");
                }
                break;

            case "save_failed":
                name = arguments[1];
                var errorMessage = arguments[2];
                $uploadStatus.css({ 'color': '#F00' }).text(name + " failed: " + errorMessage);
                break;

            case "save_progress":
                name = arguments[1];
                var bytesLoaded = arguments[2];
                var bytesTotal = arguments[3];
                $uploadStatus.css({ 'color': '#000' }).text(name + " progress: " + bytesLoaded + " / " + bytesTotal);
                break;
        }
    };

    //  Helper functions ---------------------------------------------------------------------------------------------------

    function setUpFormOptions() {
        var gain = $('#gain')[0];
        var silenceLevel = $('#silenceLevel')[0];
        for (var i = 0; i <= 100; i++) {
            gain.options[gain.options.length] = new Option(100 - i);
            silenceLevel.options[silenceLevel.options.length] = new Option(i);
        }
    }

    function setControlsClass($controls, className) {
        $controls.attr('class', CLASS_CONTROLS + ' ' + className);
    }

    function controlsEl(name) {
        return $('#recorder-' + name);
    }

    function recorderEl() {
        return $('#recorderApp');
    }


    //  Button actions -----------------------------------------------------------------------------------------------------

    window.microphonePermission = function () {
        recorderEl().addClass("floating");
        FWRecorder.showPermissionWindow({ permanent: true });
    };

    window.configureMicrophone = function () {
        if (!FWRecorder.isReady) {
            return;
        }
        FWRecorder.configure(44, 50, 0, 2000);
        //FWRecorder.configure($('#rate').val(), $('#gain').val(), $('#silenceLevel').val(), $('#silenceTimeout').val());
        FWRecorder.setUseEchoSuppression($('#useEchoSuppression').is(":checked"));
        FWRecorder.setLoopBack($('#loopBack').is(":checked"));
    };

    window.getDataBase64 = function () {

        var textoBase64 = FWRecorder.getBase64("audio");

        textoBase64 = textoBase64.replace("data:audio/wav;base64,", "");

        // Convert the Base64 string back to text.
        var byteString = atob(textoBase64);

        // Convert that text into a byte array.

        var ab = new ArrayBuffer(byteString.length);


        var ia = new Uint8Array(ab);


        for (var i = 0; i < byteString.length; i++) {
            ia[i] = byteString.charCodeAt(i);
        }


        // Blob for saving.
        var blob = new Blob([ia], { type: "audio/wav" });


        // Tell the browser to save as report.pdf.
        saveAs(blob, "audio.wav");

        //alert("Archivo generado con exito");


    };

});
