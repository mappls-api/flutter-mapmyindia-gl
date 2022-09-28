import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:turf/bearing.dart';
import 'package:turf/helpers.dart';

class TrackingPlugin {
  static const String CAR = "car_icon";
  static const String POLYLINE_SOURCE = "polyline-source";
  static const String POLYLINE_LAYER = "polyline-layer";
  static const String CAR_SOURCE = "car-source";
  static const String CAR_LAYER = "car-layer";
  static const String PROPERTY_BEARING = "bearing";

  late MapmyIndiaMapController controller;
  Animation<double>? _animation;
  AnimationController? _animationController;
  bool _isCallbackSent = false;
  late TickerProvider _tickerProvider;

  TrackingPlugin(
      MapmyIndiaMapController controller, TickerProvider tickerProvider) {
    this.controller = controller;
    this._tickerProvider = tickerProvider;
    initSource();
  }

  void initSource() async {
    await addImageFromAsset(CAR, "assets/symbols/car.png");
    await addSource();
    await addLayer();
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  Future<void> addSource() async {
    await controller.addSource(
        POLYLINE_SOURCE,
        GeojsonSourceProperties(
            data: {"type": "FeatureCollection", "features": []}));
    return await controller.addSource(
        CAR_SOURCE,
        GeojsonSourceProperties(
            data: {"type": "FeatureCollection", "features": []}));
  }

  Future<void> addLayer() async {
    await controller.addLineLayer(
        POLYLINE_SOURCE,
        POLYLINE_LAYER,
        LineLayerProperties(
            // lineColor: Colors.black.toHexStringRGB(),
            lineWidth: 4,
            lineJoin: "round",
            lineCap: "round"));
    return await controller.addSymbolLayer(
        CAR_SOURCE,
        CAR_LAYER,
        SymbolLayerProperties(
            iconImage: CAR,
            iconRotate: [Expressions.get, PROPERTY_BEARING],
            iconSize: 0.2,
            iconAllowOverlap: true,
            iconIgnorePlacement: true,
            iconRotationAlignment: "map"));
  }

  void drawPolyline(List<LatLng> latLngList) async {
    if (!_isCallbackSent) {
      List<List<double>> coordinates =
          latLngList.map((e) => [e.longitude, e.latitude]).toList();

      await controller.setGeoJsonSource(POLYLINE_SOURCE, {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {"type": "LineString", "coordinates": coordinates},
          }
        ]
      });
    }
  }

  void addMarker(LatLng latLng) async {
    await controller.setGeoJsonSource(CAR_SOURCE, {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [latLng.longitude, latLng.latitude]
          },
          "properties": {PROPERTY_BEARING: 0}
        }
      ]
    });
  }

  Future<void> animateMarker(LatLng start, LatLng next) async {
    _animationController = AnimationController(
        duration: const Duration(seconds: 5), vsync: _tickerProvider);
    Tween<double> tween = Tween(begin: 0, end: 1);

    double bearingData = bearing(
            Point(coordinates: Position(next.longitude, next.latitude)),
            Point(coordinates: Position(start.longitude, start.latitude)))
        .toDouble();
    _animation = tween.animate(_animationController!)
      ..addListener(() async {
        if (!_isCallbackSent) {
          final v = _animation!.value;

          double lng = v * next.longitude + (1 - v) * start.longitude;
          double lat = v * next.latitude + (1 - v) * start.latitude;
          LatLng newPos = LatLng(lat, lng);
          controller.setGeoJsonSource(CAR_SOURCE, {
            "type": "FeatureCollection",
            "features": [
              {
                "type": "Feature",
                "geometry": {
                  "type": "Point",
                  "coordinates": [newPos.longitude, newPos.latitude],
                },
                "properties": {PROPERTY_BEARING: bearingData}
              }
            ]
          });
        } else {
          _animationController?.removeListener(() {});
        }
      });

    return await _animationController?.forward();
  }

  void dispose() async {
    _isCallbackSent = true;
    _animationController?.reset();
    _animationController?.stop(canceled: false);
    _animationController?.dispose();
  }
}
