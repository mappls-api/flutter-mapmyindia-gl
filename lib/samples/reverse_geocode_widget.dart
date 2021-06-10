import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';

class ReverseGeocodeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReverseGeocodeWidgetState();
  }
}

class ReverseGeocodeWidgetState extends State {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColor.colorPrimary,
          brightness: Brightness.dark,
          title: Text(
            'Reverse Geocode API',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.2,
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: MapmyIndiaMap(
            initialCameraPosition: _kInitialPosition,
            onMapLongClick: (point, latlng) => {reverseGeocode(latlng)},
          ))
        ]));
  }

  reverseGeocode(LatLng latlng) async {
    try {
      ReverseGeocodeResponse? result = await MapmyIndiaReverseGeocode(
          location: latlng).callReverseGeocode();
      if (result != null && result.results != null &&
          result.results!.length > 0) {
        Fluttertoast.showToast(msg: result.results![0].formattedAddress!);
      }
      print(result);
    } catch (e) {
      if (e is PlatformException) {
        Fluttertoast.showToast(msg: '${e.code} --- ${e.message}');
      }
    }
  }
}
