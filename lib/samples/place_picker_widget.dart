import 'dart:convert';
import 'dart:typed_data';
import 'package:mapmyindia_place_widget/mapmyindia_place_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';

class PlacePickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlacePickerWidgetState();
  }
}

class PlacePickerWidgetState extends State {
  ReverseGeocodePlace _place = ReverseGeocodePlace();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.colorPrimary,
        brightness: Brightness.dark,
        title: Text(
          'Place Picker Widget',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.2,
      ),
      body: Center(child: Column(children: [
        SizedBox(height: 20,),
        Text(_place.formattedAddress == null? 'Address: ':'Address: ${_place.formattedAddress}' ),
        SizedBox(height: 20,),
        TextButton(onPressed: openMapmyIndiaPlacePickerWidget ,child:Text("Open Place picker")),
      ]))
    );
  }

  openMapmyIndiaPlacePickerWidget() async {
    ReverseGeocodePlace place;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      place = await openPlacePicker(
          PickerOption());
    } on PlatformException {
      place = ReverseGeocodePlace();
    }
    print(json.encode(place.toJson()));

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _place = place;
    });
  }

}
