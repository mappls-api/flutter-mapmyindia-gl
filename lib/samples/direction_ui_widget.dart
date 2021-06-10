import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapmyindia_gl_app/utils/color.dart';
import 'package:mapmyindia_direction_plugin/mapmyindia_direction_plugin.dart';

class DirectionUIWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DirectionUIState();
  }
}

class DirectionUIState extends State {
  DirectionCallback _directionCallback = DirectionCallback(null, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColor.colorPrimary,
          brightness: Brightness.dark,
          title: Text(
            'Direction UI',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.2,
        ),
        body: Center(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Text(_directionCallback.selectedIndex == null
                ? 'Selected Index: '
                : 'Selected Index: ${_directionCallback.selectedIndex}'),
            SizedBox(
              height: 20,
            ),
            Text(_directionCallback.directionResponse?.routes == null
                ? 'Distance: '
                : 'Distance: ${_directionCallback.directionResponse?.routes![0].distance}'),
            SizedBox(
              height: 20,
            ),
            Text(_directionCallback.directionResponse?.routes == null
                ? 'Duration: '
                : 'Duration: ${_directionCallback.directionResponse?.routes![0].duration}'),
            SizedBox(
              height: 20,
            ),
            TextButton(
                child: Text('Open Direction Widget'),
                onPressed: () => {openMapmyIndiaDirectionWidget()})
          ]),
        ));
  }

  Future<void> openMapmyIndiaDirectionWidget() async {
    DirectionCallback directionCallback;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      directionCallback = await openDirectionWidget();
    } on PlatformException {
      directionCallback = DirectionCallback(null, null);
    }
    print(json.encode(directionCallback.directionResponse?.toMap()));

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _directionCallback = directionCallback;
    });
  }
}
