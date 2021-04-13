import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';

import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class MarkerDraggingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MarkerDraggingState();
  }
}

class MarkerDraggingState extends State {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(28.705436, 77.100462),
    zoom: 12.0,
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
          'Marker Dragging',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.2,
      ),
      body: MapmyIndiaMap(
        initialCameraPosition: _kInitialPosition,
        onMapCreated: (map) => {
          controller = map,
        },
        onStyleLoadedCallback: () => {addMarker()},
      ),
    );
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  void addMarker() async {
    await addImageFromAsset("icon", "assets/symbols/custom-icon.png");
    controller.addSymbol(SymbolOptions(
        geometry: LatLng(28.705436, 77.100462),
        iconImage: "icon",
        draggable: true));
    controller.setSymbolIconIgnorePlacement(false);
    controller.setSymbolIconAllowOverlap(true);

  }
}
