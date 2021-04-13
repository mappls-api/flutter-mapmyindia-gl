// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapmyindia_gl_app/model/feature_list.dart';
import 'package:flutter_mapmyindia_gl_app/samples/add_marker.dart';
import 'package:flutter_mapmyindia_gl_app/samples/add_polyline_wdget.dart';
import 'package:flutter_mapmyindia_gl_app/samples/camera_feature.dart';
import 'package:flutter_mapmyindia_gl_app/samples/current_location_widget.dart';
import 'package:flutter_mapmyindia_gl_app/samples/location_camera_option.dart';
import 'package:flutter_mapmyindia_gl_app/samples/map_click_event.dart';
import 'package:flutter_mapmyindia_gl_app/samples/map_long_click.dart';
import 'package:flutter_mapmyindia_gl_app/samples/marker_dragging_widget.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:flutter_mapmyindia_gl_app/utils/feature_type.dart';
import 'package:location/location.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

final List<FeatureList> mapEvents = <FeatureList>[
  FeatureList(
      "Map Tap", "Click on map and get Latitude Longitude", "/MapClick"),
  FeatureList("Map Long Click", "Long press on map and get Latitude Longitude",
      "/MapLongClick"),
];

final List<FeatureList> cameraFeatures = <FeatureList>[
  FeatureList('Camera Features', "Animate, Move or Ease Camera Position",
      '/CameraFeature'),
  FeatureList("Location Camera Options", "Location camera and render mode",
      '/LocationCameraOptions')
];

final List<FeatureList> markerFeatures = <FeatureList>[
  FeatureList('Add Marker', 'Way to add Marker on Map', '/AddMarker'),
  // FeatureList('Marker Dragging', 'Drag a marker', '/MarkerDragging')
];

final List<FeatureList> locationFeatures = <FeatureList>[
  FeatureList('Current Location', 'Location camera options for render and tracking modes', '/CurrentLocation')
];

final List<FeatureList> polylineFeatures = <FeatureList>[
  FeatureList('Draw Polyline', 'Draw a polyline with given list of latitude and longitude', '/AddPolyline')
];

class MapsDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapDemoState();
  }
}

void main() {
  runApp(MaterialApp(
    home: MapsDemo(),
    routes: <String, WidgetBuilder>{
      '/MapClick': (BuildContext context) => MapClickEvent(),
      '/MapLongClick': (BuildContext context) => MapLongClick(),
      '/CameraFeature': (BuildContext context) => CameraFeature(),
      '/LocationCameraOptions': (BuildContext context) => LocationCameraOption(),
      '/AddMarker': (BuildContext context) => AddMarkerWidget(),
      '/MarkerDragging': (BuildContext context) => MarkerDraggingWidget(),
      '/CurrentLocation': (BuildContext context) => CurrentLocationWidget(),
      '/AddPolyline': (BuildContext context) => AddPolylineWidget()
    },
  ));
}

class MapDemoState extends State {
  //FIXME: Add your Mapbox access token here
  static const String MAP_SDK_KEY = "";
  static const String REST_API_KEY = "";
  static const String ATLAS_CLIENT_ID =
      ";
  static const String ATLAS_CLIENT_SECRET =
      "";

  FeatureType selectedFeatureType;

  void setPermission() async {
    if (!kIsWeb) {
      final location = Location();
      final hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.GRANTED) {
        await location.requestPermission();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    MapmyIndiaAccountManager.setMapSDKKey(MAP_SDK_KEY);
    MapmyIndiaAccountManager.setRestAPIKey(REST_API_KEY);
    MapmyIndiaAccountManager.setAtlasClientId(ATLAS_CLIENT_ID);
    MapmyIndiaAccountManager.setAtlasClientSecret(ATLAS_CLIENT_SECRET);
    setState(() {
      selectedFeatureType = FeatureType.MAP_EVENT;
    });
    setPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(backgroundColor: MyColor.colorPrimary, title: titleMap()),
        drawer: mapDrawer(),
        body: itemList(context));
  }

  Drawer mapDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MyColor.colorPrimary,
                    MyColor.colorPrimaryDark,
                    MyColor.colorAccent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 110,
                ),
                Text(
                  "MapmyIndia Flutter Sample",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Map Events'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.MAP_EVENT;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: Text('Camera'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.CAMERA_FEATURE;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: Text('Marker'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.MARKER_FEATURE;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: Text('Location'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.LOCATION_FEATURE;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: Text('Polylines'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.POLYLINE_FEATURE;
              }),
              Navigator.pop(context)
            },
          )
        ],
      ),
    );
  }

  Widget itemList(BuildContext context) {
    if (selectedFeatureType == FeatureType.CAMERA_FEATURE) {
      return ListView.builder(
          itemCount: cameraFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(cameraFeatures[index], context));
    } else if (selectedFeatureType == FeatureType.MARKER_FEATURE) {
      return ListView.builder(
          itemCount: markerFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(markerFeatures[index], context));
    } else if (selectedFeatureType == FeatureType.LOCATION_FEATURE) {
      return ListView.builder(
          itemCount: locationFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(locationFeatures[index], context));
    } else if (selectedFeatureType == FeatureType.POLYLINE_FEATURE) {
      return ListView.builder(
          itemCount: polylineFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(polylineFeatures[index], context));
    } else {
      return ListView.builder(
          itemCount: mapEvents.length,
          itemBuilder: (_, int index) => itemWidget(mapEvents[index], context));
    }
  }

  titleMap() {
    if (selectedFeatureType == FeatureType.CAMERA_FEATURE) {
      return Text('Camera');
    } else if (selectedFeatureType == FeatureType.MARKER_FEATURE) {
      return Text('Marker');
    } else if (selectedFeatureType == FeatureType.LOCATION_FEATURE) {
      return Text('Location');
    } else if (selectedFeatureType == FeatureType.POLYLINE_FEATURE) {
      return Text('Polyline');
    } else {
      return Text('Map Events');
    }
  }
}

Widget itemWidget(FeatureList featureList, BuildContext context) {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 12,
        ),
        Text(
          featureList.featureTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          featureList.featureDescription,
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(
          height: 12,
        ),
        Divider(
          height: 4,
          thickness: 2,
        )
      ],
    ),
    onTap: () => {Navigator.pushNamed(context, featureList.routeName)},
  );
}
