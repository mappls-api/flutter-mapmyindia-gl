import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';

import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class LocationCameraOption extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationCameraOptionState();
  }
}

class LocationCameraOptionState extends State {
  MapboxMapController mapController;
  bool isMapLoded;
  MyLocationTrackingMode _myLocationTrackingMode;
  MyLocationRenderMode _myLocationRenderMode;
  String _slectedRenderModeText;
  List<MyLocationRenderMode> renderModeList = [
    MyLocationRenderMode.NORMAL,
    MyLocationRenderMode.COMPASS,
    MyLocationRenderMode.GPS,
  ];
  List<String> renderModeTextList = [
    "Normal",
    "Compass",
    "GPS",
  ];
  String _selectedTrackingModeText;
  List<MyLocationTrackingMode> trackingModeList = [
    MyLocationTrackingMode.None,
    MyLocationTrackingMode.NONE_COMPASS,
    MyLocationTrackingMode.NONE_GPS,
    MyLocationTrackingMode.Tracking,
    MyLocationTrackingMode.TrackingCompass,
    MyLocationTrackingMode.TrackingGPS,
    MyLocationTrackingMode.TRACKING_GPS_NORTH,
  ];
  List<String> trackingModeTextList = [
    "None",
    "None Compass",
    "None GPS",
    "Tracking",
    "Tracking Compass",
    "Tracking GPS",
    "Tracking GPS North",
  ];

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    mapController = null;
    setState(() {
      isMapLoded = false;
      _myLocationRenderMode = renderModeList[0];
      _slectedRenderModeText = renderModeTextList[0];
      _myLocationTrackingMode = trackingModeList[3];
      _selectedTrackingModeText = trackingModeTextList[3];
    });
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    setState(() {
      isMapLoded = true;
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColor.colorPrimary,
          brightness: Brightness.dark,
          title: Text(
            'Location Camera Option',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.2,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: MapmyIndiaMap(
              initialCameraPosition: _kInitialPosition,
              myLocationEnabled: true,
              myLocationTrackingMode: _myLocationTrackingMode,
              myLocationRenderMode: _myLocationRenderMode,
              onMapCreated: _onMapCreated,

            )),
            isMapLoded
                ? Container(
                    child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      renderModeWidget(),
                      SizedBox(
                        width: 4,
                      ),
                      cameraModeWidget(),
                      SizedBox(
                        width: 4,
                      )
                    ],
                  ),
            color: MyColor.colorPrimaryDark,)
                : Container(),
          ],
        ));
  }

  renderModeWidget() {
    return Expanded(
        flex: 2,
        child: Row(children: [
          PopupMenuButton<int>(
            onSelected: (int index) => {
              setState(() => {
                    _myLocationRenderMode = renderModeList[index],
                    _slectedRenderModeText = renderModeTextList[index]
                  }),
              Fluttertoast.showToast(msg: renderModeTextList[index], toastLength: Toast.LENGTH_LONG)
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                child: Text(renderModeTextList[0]),
                value: 0,
              ),
              PopupMenuItem(
                child: Text(renderModeTextList[1]),
                value: 1,
              ),
              PopupMenuItem(
                child: Text(renderModeTextList[2]),
                value: 2,
              )
            ],
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(12),
              child: Text(
                'Render:  ' + _slectedRenderModeText,
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              color: MyColor.colorPrimaryDark,
            ),
          )
        ]));
  }

  cameraModeWidget() {
    return Expanded(
        flex: 3,
        child: Row(children: [
          PopupMenuButton<int>(
            onSelected: (int index) => {
              setState(() => {
                    _myLocationTrackingMode = trackingModeList[index],
                    _selectedTrackingModeText = trackingModeTextList[index]
                  }),
              Fluttertoast.showToast(msg: trackingModeTextList
              [index], toastLength: Toast.LENGTH_LONG)
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                child: Text(trackingModeTextList[0]),
                value: 0,
              ),
              PopupMenuItem(
                child: Text(trackingModeTextList[1]),
                value: 1,
              ),
              PopupMenuItem(
                child: Text(trackingModeTextList[2]),
                value: 2,
              ),
              PopupMenuItem(
                child: Text(trackingModeTextList[3]),
                value: 3,
              ),
              PopupMenuItem(
                child: Text(trackingModeTextList[4]),
                value: 4,
              ),
              PopupMenuItem(
                child: Text(trackingModeTextList[5]),
                value: 5,
              ),
              PopupMenuItem(
                child: Text(trackingModeTextList[6]),
                value: 6,
              )
            ],
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(12),
              child: Text(
                'Tracking:  ' + _selectedTrackingModeText,
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              color: MyColor.colorPrimaryDark,
            ),
          )
        ]));
  }
}
