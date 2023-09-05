// ignore_for_file: unused_field, depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/shared/size_config.dart';

class MapPinSelectionScreen extends StatefulWidget {
  @override
  _MapPinSelectionScreenState createState() => _MapPinSelectionScreenState();
}

class _MapPinSelectionScreenState extends State<MapPinSelectionScreen> {
  late GoogleMapController _mapController;
  GeoPoint _userPosition = const GeoPoint(43.856430, 18.413029);
  LatLng _selectedLocation =
      const LatLng(43.856430, 18.413029); // Default location

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.high,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _userPosition = GeoPoint(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a restaurant location'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    GeoPoint(_selectedLocation.latitude,
                        _selectedLocation.longitude));
              },
              icon: Icon(
                Icons.done,
                color: Colors.white,
                size: SizeConfig.safeBlockVertical! * 3,
              ))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_userPosition.latitude, _userPosition.longitude),
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
        onTap: _onMapTap,
        markers: {
          Marker(
            markerId: const MarkerId('selected_location'),
            position: _selectedLocation,
          ),
        },
      ),
    );
  }
}
