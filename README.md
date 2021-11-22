
![MapmyIndia APIs](https://www.mapmyindia.com/api/img/mapmyindia-api.png)
  
# Flutter MapmyIndia GL   
  This Flutter plugin allows to show embedded interactive MapmyIndia maps inside a Flutter widget. For the Android and iOS integration. This project only supports a subset of the API exposed by these libraries.     

## Getting Started
To work with MapmyIndia Map in flutter add this to your package's pubspec.yaml file:
~~~yaml
dependencies:
  mapmyindia_gl: ^0.2.2
~~~

Now in your dart code you need to import this package:
~~~dart
import 'package:mapmyindia_gl/mapmyindia_gl.dart';
~~~ 
   
## Adding MapmyIndia Keys    
     
You **must** provide your keys through the `MapmyIndiaAccountManager` class:  
  
~~~dart  
MapmyIndiaAccountManager.setMapSDKKey(ACCESS_TOKEN); 
MapmyIndiaAccountManager.setRestAPIKey(REST_API_KEY); 
MapmyIndiaAccountManager.setAtlasClientId(ATLAS_CLIENT_ID); 
MapmyIndiaAccountManager.setAtlasClientSecret(ATLAS_CLIENT_SECRET);  
~~~

## Add MapmyIndia Map to your application
Add MapmyIndiaMap widget
~~~dart
MapmyIndiaMap(  
	initialCameraPosition: CameraPosition(  
	  target: LatLng(25.321684, 82.987289),  
	  zoom: 14.0,  
	),  
	onMapCreated: (map) =>  
	{  
	  mapController = map,
	},
),
~~~

## Map Interactions
The MapmyIndia Maps Flutter SDK allows you to define interactions that you can activate on the map to enable gestures and click events. The following interactions are supported –

### Zoom Controls
The map supports the familiar two-finger pinch and zooms to change zoom level as well as double tap to zoom in. Set zoom to 4 for country level display and 18 for house number display. In this SDK the camera position plays an important role

And following operations can be performed using the CameraPosition

#### Target
The target is single latitude and longitude coordinate that the camera centers it on. Changing the camera's target will move the camera to the inputted coordinates. The target is a LatLng object. The target coordinate is always _at the center of the viewport_.

#### Tilt
Tilt is the camera's angle from the nadir (directly facing the Earth) and uses unit degrees. The camera's minimum (default) tilt is 0 degrees, and the maximum tilt is 60. Tilt levels use six decimal point of precision, which enables you to restrict/set/lock a map's bearing with extreme precision.

The map camera tilt can also adjust by placing two fingertips on the map and moving both fingers up and down in parallel at the same time or

#### Bearing
Bearing represents the direction that the camera is pointing in and measured in degrees  _clockwise from north_.

The camera's default bearing is 0 degrees (i.e. "true north") causing the map compass to hide until the camera bearing becomes a non-zero value. Bearing levels use six decimal point precision, which enables you to restrict/set/lock a map's bearing with extreme precision. In addition to programmatically adjusting the camera bearing, the user can place two fingertips on the map and rotate their fingers.

#### Zoom
Zoom controls scale of the map and consumes any value between 0 and 22. At zoom level 0, viewport shows continents and other world features. A middle value of 11 will show city level details.At a higher zoom level, map will begin to show buildings and points of interest. Camera can zoom in following ways:

-   Pinch motion two fingers to zoom in and out.
-   Quickly tap twice on the map with a single finger to zoom in.
-   Quickly tap twice on the map with a single finger and hold your finger down on the screen after the second tap.
-   Then slide the finger up to zoom out and down to zoom out.

##### Sdk allows various method to Move, ease,animate Camera to a particular location :
~~~dart
mapController.moveCamera(CameraUpdate.newLatLngZoom(LatLng(22.553147478403194, 77.23388671875), 14));
mapController.easeCamera(CameraUpdate.newLatLngZoom(LatLng(28.704268, 77.103045), 14));
mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(28.698791, 77.121243), 14));
~~~

## Map Events
### Map Click/Long click
If you want to respond to a user tapping on a point on the map, you can use a onMapClick callback.

It sets a callback that's invoked when the user clicks on the map:
~~~dart
MapmyIndiaMap(  
  initialCameraPosition: _kInitialPosition,  
  onMapClick: (point, latlng) =>{  
    print(latlng.toString())
  },  
)
~~~

##### Sets a callback that's invoked when the user long clicks on the map view.
~~~dart
MapmyIndiaMap(  
  initialCameraPosition: _kInitialPosition,  
  onMapLongClick: (point, latlng) =>{  
    print(latlng.toString())
  },  
)
~~~


## Map Overlays
### Add a Marker
Add marker on the map by following these steps:
~~~dart
Symbol symbol = await controller.addSymbol(SymbolOptions(geometry: LatLng(25.321684, 82.987289)));
~~~

### Customize a marker

~~~dart
/// Adds an asset image to the currently displayed style  
Future<void> addImageFromAsset(String name, String assetName) async {  
  final ByteData bytes = await rootBundle.load(assetName);  
 final Uint8List list = bytes.buffer.asUint8List();  
 return controller.addImage(name, list);  
}

await addImageFromAsset("icon", "assets/symbols/custom-icon.png");
Symbol symbol = await controller.addSymbol(SymbolOptions(geometry: LatLng(25.321684, 82.987289), iconImage: "icon"));
~~~

### Remove a Marker
To remove a marker from map
~~~dart
controller.removeSymbol(symbol);
~~~
### Add a Polyline
Draw a polyline on Map
~~~dart
Line line = await controller.addLine(LineOptions(geometry: latlng, lineColor: "#3bb2d0", lineWidth: 4));
~~~

### Remove a Polyline
To remove polyline from Map
~~~dart
controller.removeLine(line);
~~~

### Add a Polygon
**This feature is available from version v0.2.0**

Draw a polygon on the map:
~~~dart
Fill fill = await controller.addFill(FillOptions(geometry: latlng, fillColor: "#3bb2d0")); 
~~~

### Remove a Polygon
~~~dart
controller.removeFill(fill);
~~~

## Add Annotations using Geojson
**This feature is available from v0.2.2**
```dart
List<Symbol> symbol = await controller.addSymbolsFromJson(geojson);  
List<Line> lines = await controller.addLinesFromJson(geojson);  
List<Fill> fills = await controller.addFillsFromJson(geojson);
```
## Show User location
**onUserLocationUpdated is available from v0.2.0**

To show user current location on the map
~~~dart
MapmyIndiaMap(  
  initialCameraPosition: _kInitialPosition,  
  myLocationEnabled: true,  
  myLocationTrackingMode: MyLocationTrackingMode.NONE_COMPASS,  
  onUserLocationUpdated: (location) => {  
      print("Position: ${location.position.toString()}, Speed: ${location.speed}, Altitude: ${location.altitude}")  
  },  
)
~~~


![Email](https://www.google.com/a/cpanel/mapmyindia.co.in/images/logo.gif?service=google_gsuite) 

Email us at [apisupport@mapmyindia.com](mailto:apisupport@mapmyindia.com)

​

![](https://www.mapmyindia.com/api/img/icons/stack-overflow.png)

[Stack  Overflow](https://stackoverflow.com/questions/tagged/mapmyindia-api)

Ask a question under the mapmyindia-api

​

![](https://www.mapmyindia.com/api/img/icons/support.png)

[Support](https://www.mapmyindia.com/api/index.php#f_cont)

Need support? contact us!

​

![](https://www.mapmyindia.com/api/img/icons/blog.png)

[Blog](http://www.mapmyindia.com/blog/)

Read about the latest updates & customer stories

​

​

>  ©  Copyright  2021.  CE  Info  Systems  Pvt.  Ltd.  All  Rights  Reserved.  |  [Terms  &  Conditions](http://www.mapmyindia.com/api/terms-&-conditions).

