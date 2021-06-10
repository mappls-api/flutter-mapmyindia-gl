
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:mapmyindia_nearby_plugin/mapmyindia_nearby_plugin.dart';

class NearbyUIWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NearbyUIState();
  }
}

class NearbyUIState extends State {
  NearbyResult? _nearbyResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColor.colorPrimary,
          brightness: Brightness.dark,
          title: Text(
            'Nearby UI',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.2,
        ),
        body: Center(
            child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(_nearbyResult?.distance == null? 'Distance: ':'Distance: ${_nearbyResult?.distance}'),
                  SizedBox(height: 20),
                  Text(_nearbyResult?.eLoc == null? 'ELoc: ':'ELoc: ${_nearbyResult?.eLoc}'),
                  SizedBox(height: 20),
                  Text(_nearbyResult?.placeName == null? 'Place Name: ':'Place Name: ${_nearbyResult?.placeName}'),
                  SizedBox(height: 20),
                  Text(_nearbyResult?.placeAddress == null? 'Place Address: ':'Place Address: ${_nearbyResult?.placeAddress}'),
                  SizedBox(height: 20),
                  Text(_nearbyResult?.orderIndex == null? 'Index: ':'Index: ${_nearbyResult?.orderIndex}'),
                  SizedBox(height: 20),
                  TextButton(
                      child: Text('Open Nearby Search Widget'),
                      onPressed: () => {
                        openMapmyIndiaNearbyWidget(),
                      })
                ]
            )
        ));
  }

  void openMapmyIndiaNearbyWidget() async {
    NearbyResult nearbyResult;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {

      nearbyResult = await openNearbyWidget();
    } on PlatformException {
      nearbyResult = NearbyResult();
    }
    print(json.encode(nearbyResult.toJson()));

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _nearbyResult = nearbyResult;
    });
  }

}