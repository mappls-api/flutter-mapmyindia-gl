
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class AddPolygonWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPolygonState();
  }

}

class AddPolygonState extends State {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 10.0,
  );

  late MapmyIndiaMapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.colorPrimary,
        brightness: Brightness.dark,
        title: Text(
          'Add Polygon',
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
          addPolygon()
        },
      ),
    );
  }


  void addPolygon() async {
    List<List<LatLng>> latlng = [<LatLng>[
      LatLng(28.703900, 77.101318),
      LatLng(28.703331, 77.102155),
      LatLng(28.703905, 77.102761),
      LatLng(28.704248, 77.102370),
      LatLng(28.703900, 77.101318),
    ]];
    LatLngBounds latLngBounds = boundsFromLatLngList(latlng.first);
    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds));
    controller.addFill(FillOptions(geometry: latlng, fillColor: "#3bb2d0"));

  }

  boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}
