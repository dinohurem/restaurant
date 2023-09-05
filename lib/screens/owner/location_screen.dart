// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant/shared/size_config.dart';

class LocationScreen extends StatefulWidget {
  final LatLng location;
  final String name, type;
  const LocationScreen({
    super.key,
    required this.location,
    required this.name,
    required this.type,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController _controller;
  List<Marker> _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    _markers.add(
      Marker(
        markerId: MarkerId(widget.location.longitude.toString() +
            widget.location.longitude.toString()),
        position: widget.location,
        infoWindow: InfoWindow(
          title: widget.name,
          snippet: widget.type,
        ),
      ),
    );
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Stack(children: [
        GoogleMap(
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;

            _controller.showMarkerInfoWindow(_markers.first.markerId);
          },
          initialCameraPosition: CameraPosition(
            target: widget.location, // Default map center
            zoom: 13.5,
          ),
          myLocationEnabled: true,
          markers: Set<Marker>.of(_markers),
        ),
      ]),
    );
  }
}
