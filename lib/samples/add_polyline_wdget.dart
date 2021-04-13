import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';


class AddPolylineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPolylineState();
  }

}

class AddPolylineState extends State {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 10.0,
  );

  MapboxMapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.colorPrimary,
        brightness: Brightness.dark,
        title: Text(
          'Add Polyline',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.2,
      ),
      body: MapmyIndiaMap(
        initialCameraPosition: _kInitialPosition,
        onMapCreated: (map) =>
        {
          controller = map,
        },
        onStyleLoadedCallback: () => {
          addMarker()
        },
      ),
    );
  }


  void addMarker() async {
 //   await addImageFromAsset("icon", "assets/symbols/custom-icon.png");
    List<LatLng> latlng = <LatLng>[
      LatLng(28.705436, 77.100462),
      LatLng(28.705191, 77.100784),
      LatLng(28.704646, 77.101514),
      LatLng(28.704194, 77.101171),
      LatLng(28.704083, 77.101066),
      LatLng(28.703900, 77.101318)
    ];
    LatLngBounds latLngBounds = boundsFromLatLngList(latlng);
    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds));
    controller.addLine(LineOptions(geometry: latlng, lineColor: "#3bb2d0", lineWidth: 4));

  }

  boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }
}
