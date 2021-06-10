import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:flutter_mapmyindia_gl_app/utils/polyline.dart';

class POIAlongRouteWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return POIAlongRouteWidgetState();
  }
}

class POIAlongRouteWidgetState extends State {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 10.0,
  );

  TextEditingController sourceController =
      TextEditingController(text: "28.594475,77.202432");
  TextEditingController destinationController =
      TextEditingController(text: "28.554676,77.186982");
  TextEditingController keywordController =
      TextEditingController(text: "FODCOF");

  List<SuggestedPOI> result = [];
  bool isShowList = false;

  late MapmyIndiaMapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.colorPrimary,
        brightness: Brightness.dark,
        title: Text(
          'POI Along Route API',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.2,
      ),
      body: Stack(children: <Widget>[
        MapmyIndiaMap(
          initialCameraPosition: _kInitialPosition,
          onMapCreated: (map) => {
            controller = map,
          },
          onStyleLoadedCallback: () {
            callDirection();
          },
          onMapLongClick: (point, latlng) {
            openDialog(latlng);
          },
        ),
        Container(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: sourceController,
                        decoration: InputDecoration(
                            hintText: "Source(e.g.,Lat,Lng/ELOC)",
                            fillColor: Colors.white),
                      )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: destinationController,
                        decoration: InputDecoration(
                            hintText: "Destination(e.g.,Lat,Lng/ELOC)",
                            fillColor: Colors.white),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: keywordController,
                          decoration: InputDecoration(
                              hintText: "e.g.,Tea", fillColor: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: TextButton(
                              onPressed: () => {
                                callDirection()
                              },
                              child: Text("Submit"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      MyColor.colorPrimary),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(color: Colors.white)))))
                    ],
                  ),
                ])),
        result.length > 0 && isShowList
            ? BottomSheet(
                onClosing: () => {},
                builder: (context) => Expanded(
                    child: ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(5),
                                focusColor: Colors.white,
                                title: Text(result[index].address ?? ''),
                              ));
                        })))
            : Container()
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            isShowList = !isShowList;
          })
        },
        child: isShowList ? Icon(Icons.map) : Icon(Icons.list),
      ),
    );
  }
  
  Future<void> openDialog(LatLng latLng) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Select Point as Source or Destination'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Source'),
              onPressed: () {
                sourceController.text = "${latLng.latitude},${latLng.longitude}";
                callDirection();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Destination'),
              onPressed: () {
                destinationController.text = "${latLng.latitude},${latLng.longitude}";
                callDirection();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  callDirection() async {
    try {
      setState(() {
        result = [];
      });
      controller.clearLines();
      controller.clearSymbols();
      LatLng? source;
      String? sourceEloc;
      LatLng? destination;
      String? destinationEloc;

      if (sourceController.text.length == 0 ||
          destinationController.text.length == 0 ||
          keywordController.text.length == 0) {
        return;
      }
      if (sourceController.text.contains(",")) {
        source = LatLng(
          double.parse(sourceController.text.split(",")[0]),
          double.parse(sourceController.text.split(",")[1]),
        );
      } else {
        sourceEloc = sourceController.text;
      }
      if (destinationController.text.contains(",")) {
        destination = LatLng(
          double.parse(destinationController.text.split(",")[0]),
          double.parse(destinationController.text.split(",")[1]),
        );
      } else {
        destinationEloc = destinationController.text;
      }

      DirectionResponse? directionResponse = await MapmyIndiaDirection(
              origin: source,
              originELoc: sourceEloc,
              destination: destination,
              destinationELoc: destinationEloc)
          .callDirection();
      if (directionResponse != null &&
          directionResponse.routes != null &&
          directionResponse.routes!.length > 0) {
        Polyline polyline = Polyline.Decode(
            encodedString: directionResponse.routes![0].geometry, precision: 6);
        List<LatLng> latLngList = [];
        if (polyline.decodedCoords != null) {
          polyline.decodedCoords?.forEach((element) {
            latLngList.add(LatLng(element[0], element[1]));
          });
        }
        drawPath(latLngList);
        callPOIAlongRoute(directionResponse.routes![0]);
      }
    } on PlatformException catch (e) {
      print(e.code);
    }
  }

  void drawPath(List<LatLng> latlngList) {
    controller.addLine(
        LineOptions(geometry: latlngList, lineColor: "#3bb2d0", lineWidth: 4));
    LatLngBounds latLngBounds = boundsFromLatLngList(latlngList);
    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds));
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
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  void callPOIAlongRoute(DirectionsRoute directionsRoute) async {
    await addImageFromAsset("icon", "assets/symbols/custom-icon.png");

    await controller.clearSymbols();
    PoiAlongRouteResponse? poiAlongRouteResponse =
        await MapmyIndiaPOIAlongRoute(
                path: directionsRoute.geometry!,
                category: keywordController.text,
                buffer: 300)
            .callPOIAlongRoute();
    if (poiAlongRouteResponse != null &&
        poiAlongRouteResponse.suggestedPOIs != null &&
        poiAlongRouteResponse.suggestedPOIs!.length > 0) {
      setState(() {
        result = poiAlongRouteResponse.suggestedPOIs!;
      });
      List<SymbolOptions> options = [];
      poiAlongRouteResponse.suggestedPOIs?.forEach((element) {
        // print('${element.placeName} (${element.distance})');
        print(json.encode(element.toJson()));
        options.add(SymbolOptions(
            geometry: LatLng(element.latitude!, element.longitude!), iconImage: 'icon'));
      });
      controller.addSymbols(options);
    }
  }
}
