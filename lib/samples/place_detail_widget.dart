import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

class PlaceDetailWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlaceDetailWidgetState();
  }
}

class PlaceDetailWidgetState extends State {
  PlaceDetailResponse? place;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColor.colorPrimary,
          brightness: Brightness.dark,
          title: Text(
            'Place Detail API',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.2,
        ),
        body: Center(
            child: Column(children: [
          TextFormField(
            controller: controller,
            maxLength: 6,
            decoration: InputDecoration(
                hintText: "ELOC(e.g., MMI000)", fillColor: Colors.white),
          ),
          SizedBox(height: 10),
          TextButton(
              onPressed: () {
                callPlaceDetail();
              },
              child: Text("Submit")),
          SizedBox(height: 10),
          place?.eLoc == null
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('ELoc: ${place?.eLoc}')),
          place?.latitude == null
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('Latitude: ${place?.latitude}')),
          place?.longitude == null
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('Latitude: ${place?.longitude}')),
          place?.state == null
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('STATE: ${place?.state}')),
          place?.city == null
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('City: ${place?.city}')),
          place?.address == null
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('Address: ${place?.address}')),
          place?.placeName == null
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('Place Name: ${place?.placeName}')),
          place?.type == null
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text('Type: ${place?.type}')),
        ])));
  }

  void callPlaceDetail() async {
    if (controller.text.length > 0) {
      PlaceDetailResponse? placeDetailResponse;
      try {
        placeDetailResponse = await MapmyIndiaPlaceDetail(eLoc: controller.text)
            .callPlaceDetail();
      } on PlatformException catch (e) {
        Fluttertoast.showToast(msg: '${e.code}----${e.message}');
      }

      setState(() {
        place = placeDetailResponse;
      });
    }
  }
}
