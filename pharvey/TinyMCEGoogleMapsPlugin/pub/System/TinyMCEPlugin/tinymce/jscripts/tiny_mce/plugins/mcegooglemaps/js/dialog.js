tinyMCEPopup.requireLangPack();

var ExampleDialog = {

    init: function() {
        var f = document.forms[0];

        var dlg_ApiKey = tinyMCEPopup.getWindowArg("plugin_googleMaps_apiKey");
        var dlg_initialCoords = tinyMCEPopup.getWindowArg("plugin_googleMaps_coordinates");
        var dlg_showCoords = tinyMCEPopup.getWindowArg("plugin_googleMaps_showCoordinates");
        var dlg_locationLookupEnabled = tinyMCEPopup.getWindowArg("plugin_googleMaps_locationLookupEnabled");

        //document.forms[0].akey.value = tinyMCEPopup.getWindowArg("plugin_googleMaps_apiKey");
        //document.forms[0].coords.value = tinyMCEPopup.getWindowArg("plugin_googleMaps_coordinates");

        dialogInit(dlg_ApiKey, dlg_initialCoords, dlg_showCoords, dlg_locationLookupEnabled);

        // Get the selected contents as text and place it in the input
        //f.someval.value = tinyMCEPopup.editor.selection.getContent({format : 'text'});
        //f.somearg.value = tinyMCEPopup.getWindowArg('akey');
    },

    insert: function() {
        // Insert the contents from the input into the document

        var frm = document.forms[0];

        var strHtml = '';
        var akey = frm.akey.value;
        var coords = frm.coords.value;
        var width = frm.width.value;
        var height = frm.height.value;
        var zoom = frm.zoomLevel.value;
        var hud = frm.cmbHud.value;
        var showScale = frm.chkScale.checked;
        var showOverview = frm.chkOverview.checked;
        var mapType = frm.mapType.value;             

        if (width == "")
            width = 100;

        if (height == "")
            height = 100;

        //if (divnaam == "")
        //divnaam = 'map';

        if (akey == "" || coords == "") {
            alert(tinyMCEPopup.getLang('googlemaps_dlg.missing_stuff'));
        }
        else {

            tinyMCEPopup.execCommand('mceInsertGoogleMap', false, {
                akey: akey,
                coordinates: coords,                
                hud: hud,
                zoom: zoom,
                width: width,
                height: height,
                showScale : showScale,
                showOverview : showOverview,
                mapType: mapType                
            });

            tinyMCEPopup.close();
        }
    }
};

tinyMCEPopup.onInit.add(ExampleDialog.init, ExampleDialog);
