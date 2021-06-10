import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class AutoSuggestWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AutoSuggestWidgetState();
  }
}

class AutoSuggestWidgetState extends State {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(25.321684, 82.987289),
    zoom: 10.0,
  );
  late MapmyIndiaMapController controller;
  List<ELocation> _elocation = [];
  bool showAutoSuggestWidget = false;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.colorPrimary,
        brightness: Brightness.dark,
        title: Text(
          'AutoSuggest API',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.2,
      ),
      body: Stack(
        children: [
          MapmyIndiaMap(
            initialCameraPosition: _kInitialPosition,
            onMapCreated: (map) => {
              controller = map,
            },
            onStyleLoadedCallback: () => {
              setState(() {
                showAutoSuggestWidget = true;
              })
            },
          ),
          showAutoSuggestWidget ? autosuggestWidget() : Container(),
        ],
      ),
    );
  }

  Widget autosuggestWidget() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: TextFormField(
                controller: textController,
                decoration: InputDecoration(
                    hintText: "Search Here", fillColor: Colors.white),
                maxLines: 1,
                onChanged: (text) {
                  callAutoSuggest(text);
                })),
        SizedBox(
          height: 20,
        ),
        _elocation.length > 0
            ? Expanded(
                child: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                        itemCount: _elocation.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.all(12),
                            focusColor: Colors.white,
                            title: Text(_elocation[index].placeName ?? ''),
                            subtitle: Text(
                              _elocation[index].placeAddress ?? '',
                              maxLines: 2,
                            ),
                            onTap: () {
                              addMarker(_elocation[index]);
                              setState(() {
                                _elocation = [];
                              });
                              textController.text = '';
                            },
                          );
                        })))
            : Container()
      ],
    );
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  void addMarker(ELocation eLocation) async {
    await addImageFromAsset("icon", "assets/symbols/custom-icon.png");
    LatLng latLng = LatLng(
        double.parse(eLocation.latitude!), double.parse(eLocation.longitude!));
    controller.addSymbol(SymbolOptions(geometry: latLng, iconImage: 'icon'));
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
  }

  void callAutoSuggest(String text) async {
    if (text.length > 2) {
      try {
        AutoSuggestResponse? response =
            await MapmyIndiaAutoSuggest(query: text).callAutoSuggest();
        if (response != null && response.suggestedLocations != null) {
          setState(() {
            _elocation = response.suggestedLocations!;
          });
        } else {
          setState(() {
            _elocation = [];
          });
        }
      } catch (e) {
        if (e is PlatformException) {
          Fluttertoast.showToast(msg: '${e.code} --- ${e.message}');
        }
      }
    } else {
      setState(() {
        _elocation = [];
      });
    }
  }
}
