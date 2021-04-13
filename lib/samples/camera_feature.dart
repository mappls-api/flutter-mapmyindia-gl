import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';


class CameraFeature extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CameraFeatureState();
  }
}

class CameraFeatureState extends State {
  MapboxMapController mapController;
  bool isMapLoded;

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
            'Camera Feature',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.2,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: MapmyIndiaMap(
              initialCameraPosition: _kInitialPosition,
              onMapCreated: _onMapCreated,
            )),
            isMapLoded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: FlatButton(
                        onPressed: () {
                          if (mapController != null) {
                            mapController.moveCamera(CameraUpdate.newLatLngZoom(
                                LatLng(22.553147478403194, 77.23388671875),
                                14));
                          }
                        },
                        child: Text(
                          'Move Camera',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: MyColor.colorPrimaryDark,
                      )),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: FlatButton(
                        onPressed: () {
                          if (mapController != null) {
                            mapController.easeCamera(CameraUpdate.newLatLngZoom(
                                LatLng(28.704268, 77.103045), 14));
                          }
                        },
                        child: Text('Ease Camera',
                            style: TextStyle(color: Colors.white)),
                        color: MyColor.colorPrimaryDark,
                      )),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: FlatButton(
                        onPressed: () {
                          if (mapController != null) {
                            mapController.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    LatLng(28.698791, 77.121243), 14));
                          }
                        },
                        child: Text(
                          'Animate Camera',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        color: MyColor.colorPrimaryDark,
                      )),
                      SizedBox(
                        width: 4,
                      )
                    ],
                  )
                : Container(),
          ],
        ));
  }
}
