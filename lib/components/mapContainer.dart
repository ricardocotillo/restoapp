import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapContainer extends StatelessWidget {
  final double width;
  final double height;
  final CameraPosition initialCameraPosition;
  final Completer<GoogleMapController> mapController;
  final void Function(GoogleMapController) onMapCreated;

  const MapContainer(
      {Key key,
      this.width,
      this.height,
      this.initialCameraPosition,
      this.mapController,
      this.onMapCreated})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              onMapCreated: onMapCreated,
            ),
            Icon(Icons.location_on, color: Colors.blue)
          ],
        )
        //
        );
  }
}
