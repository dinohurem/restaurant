// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/screens/owner/reservation_options.dart';
import 'package:restaurant/shared/size_config.dart';

class UserModeScreen extends StatefulWidget {
  const UserModeScreen({super.key});

  @override
  _UserModeScreenState createState() => _UserModeScreenState();
}

class _UserModeScreenState extends State<UserModeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  var _restaurants;
  bool _searchMode = false;
  String _searchTerm = '';
  geolocator.Position? _userPosition;
  late GoogleMapController _controller;
  final List<Marker> _markers = <Marker>[];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _restaurants = _initialLoadRestaurants();
  }

  Future<List<DocumentSnapshot>> _initialLoadRestaurants() async {
    return await _getRestaurants();
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

    setState(() {
      _userPosition = position;
    });
  }

  Future<List<DocumentSnapshot>> _getRestaurants() async {
    QuerySnapshot snapshot = await _firestore.collection('restaurants').get();

    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>?> _filterRestaurants() async {
    if (_searchTerm.isEmpty) {
      return null;
    }

    final strFrontCode = _searchTerm.substring(0, _searchTerm.length - 1);
    final strEndCode = _searchTerm.characters.last;
    final limit =
        strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);

    QuerySnapshot snapshot = await _firestore
        .collection('restaurants')
        .where('name', isGreaterThanOrEqualTo: _searchTerm)
        .where('name', isLessThan: limit)
        .get();

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: _searchMode
            ? _buildSearchBar()
            : const Text('Restaurant Selection'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _searchMode ? Icons.location_pin : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _searchMode = !_searchMode;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _restaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Positioned(
              bottom: SizeConfig.safeBlockVertical! * 5,
              child: Container(
                color: Colors.lightBlue,
                child: const Text(
                  'No restaurants found.',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else {
            var restaurants = snapshot.data;
            for (var i = 0; i < restaurants!.length; i++) {
              _markers.add(Marker(
                  markerId: MarkerId(
                      restaurants[i]['location'].longitude.toString() +
                          restaurants[i]['location'].longitude.toString()),
                  position: LatLng(restaurants[i]['location'].latitude,
                      restaurants[i]['location'].longitude),
                  infoWindow: InfoWindow(
                      title: restaurants[i]['name'],
                      snippet: 'Type: ${restaurants[i]['type']}')));
            }

            return Stack(children: [
              GoogleMap(
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _userPosition != null
                      ? LatLng(
                          _userPosition!.latitude, _userPosition!.longitude)
                      : const LatLng(
                          43.856430, 18.413029), // Default map center
                  zoom: 13.5,
                ),
                myLocationEnabled: true,
                markers: Set<Marker>.of(_markers),
              ),
            ]);
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search by name...',
        hintStyle: const TextStyle(
          color: Colors.black,
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.clear_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            _searchController.clear();
          },
        ),
      ),
      onSubmitted: (query) async {
        setState(() {
          _searchTerm = query;
        });

        var restaurants = await _filterRestaurants();

        if (restaurants == null) {
          return;
        }

        if (!mounted) {
          return;
        }

        await showModalBottomSheet(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: restaurants.isEmpty
                    ? SizeConfig.safeBlockVertical! * 10
                    : SizeConfig.safeBlockVertical! * 32,
                color: Colors.white,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.safeBlockVertical! * 2,
                    bottom: SizeConfig.safeBlockVertical! * 2,
                  ),
                  child: restaurants.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    color: Colors.amber,
                                    size: SizeConfig.safeBlockVertical! * 2,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.safeBlockHorizontal! * 2,
                                  ),
                                  Text(
                                    'Oops, we couldn\'t find any restaurants.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          SizeConfig.safeBlockVertical! * 1.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ])
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: Colors.amber,
                                  size: SizeConfig.safeBlockVertical! * 2,
                                ),
                                SizedBox(
                                  width: SizeConfig.safeBlockHorizontal! * 2,
                                ),
                                Text(
                                  'Please choose a restaurant',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        SizeConfig.safeBlockVertical! * 1.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 2,
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 23,
                              child: Scrollbar(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemCount: restaurants.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot restaurant =
                                        restaurants[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.restaurant,
                                            color: Colors.black,
                                            size:
                                                SizeConfig.safeBlockVertical! *
                                                    4,
                                          ),
                                          title: Text(
                                            'Name: ${restaurant['name']}',
                                          ),
                                          subtitle: Text(
                                              'Type: ${restaurant['type']}'),
                                          onTap: () {
                                            // Navigate to the Restaurant Details Screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RestaurantDetailsScreen(
                                                          restaurant)),
                                            );
                                          },
                                          trailing: GestureDetector(
                                            onTap: () {
                                              var marker = _markers
                                                  .where((element) =>
                                                      element.position ==
                                                      LatLng(
                                                          restaurant['location']
                                                              .latitude,
                                                          restaurant['location']
                                                              .longitude))
                                                  .first;
                                              _controller.animateCamera(
                                                  CameraUpdate.newLatLngZoom(
                                                      LatLng(
                                                          restaurant['location']
                                                              .latitude,
                                                          restaurant['location']
                                                              .longitude),
                                                      14));
                                              _controller.showMarkerInfoWindow(
                                                  marker.markerId);
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.center_focus_strong,
                                              color: Colors.black,
                                              size: SizeConfig
                                                      .safeBlockVertical! *
                                                  3.5,
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: Colors.grey,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                )),
              );
            },
          ),
        );
      },
    );
  }
}

class RestaurantDetailsScreen extends StatelessWidget {
  final DocumentSnapshot restaurant;

  const RestaurantDetailsScreen(this.restaurant, {super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              restaurant['imageUrl'].isEmpty
                  ? 'https://cdn11.bigcommerce.com/s-1812kprzl2/images/stencil/original/products/582/5042/no-image__63632.1665666729.jpg?c=2'
                  : restaurant['imageUrl'],
              width: double.infinity,
              height: SizeConfig.safeBlockVertical! * 30,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${restaurant['name']}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      'Location: ${restaurant['location']!.latitude} N, ${restaurant['location']!.latitude} E'),
                  Text('Type: ${restaurant['type']}'),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: SizeConfig.safeBlockVertical! * 22,
              ),
            ),
            Center(
              child: SizedBox(
                width: SizeConfig.safeBlockHorizontal! * 65,
                height: SizeConfig.safeBlockVertical! * 8.5,
                child: ElevatedButton(
                  child: Text(
                    'RESERVE A TABLE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockVertical! * 2.25),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return const ReservationOptions();
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
