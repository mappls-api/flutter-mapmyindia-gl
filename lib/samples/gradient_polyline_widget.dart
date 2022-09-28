import 'package:flutter/services.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:flutter/material.dart';

class GradientPolylineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GradientPolylineWidgetState();
  }
}

class GradientPolylineWidgetState extends State {
  late MapmyIndiaMapController mapController;
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(28.705436, 77.100462),
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.colorPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'Gradient Polyline',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.2,
      ),
      body: MapmyIndiaMap(
        initialCameraPosition: _kInitialPosition,
        onMapCreated: (mapController) => this.mapController = mapController,
        onStyleLoadedCallback: _onStyleLoadedCallback,
      ),
    );
  }

  _onStyleLoadedCallback() async {
    await mapController.addSource("gradient-line-source-id",
        GeojsonSourceProperties(data: _polylineFeature, lineMetrics: true, buffer: 2.0));

    await mapController.addLineLayer(
        "gradient-line-source-id",
        "gradient-line-layer-id",
        LineLayerProperties(
            lineGradient: [
              Expressions.interpolate,
              ['linear'], [Expressions.lineProgress],
              0,
              "#3dd2d0",
              1,
              "#FF20d0"
            ],
            lineWidth: 4.0));
  }

  final _polylineFeature = {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [77.100462, 28.705436],
            [77.100784, 28.705191],
            [77.101514, 28.704646],
            [77.101171, 28.704194],
            [77.101066, 28.704083],
            [77.101318, 28.703900]
          ]
        },
      }
    ]
  };
}
