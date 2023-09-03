// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant/main.dart';
import 'package:restaurant/models/restaurant.dart';
import 'package:restaurant/screens/owner/edit_restaurant_screen.dart';
import 'package:restaurant/screens/owner/location_screen.dart';
import 'package:restaurant/services/auth.dart';
import 'package:restaurant/shared/custom_error_screen.dart';
import 'package:restaurant/shared/size_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OwnerDashboardScreen extends StatefulWidget {
  @override
  _OwnerDashboardScreenState createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Restaurant _restaurant;

  Future<Restaurant> fetchRestaurantDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot restaurantSnapshot =
          await _firestore.collection('restaurants').doc(user.uid).get();

      _restaurant = Restaurant.fromDocument(restaurantSnapshot);
    }

    return _restaurant;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomErrorScreen(
                        errorText:
                            'Please contact our support for adding more locations.',
                      )),
            );
          },
          child: Padding(
            padding:
                EdgeInsets.only(right: SizeConfig.safeBlockHorizontal! * 1.5),
            child: Icon(
              Icons.add_location_alt,
              color: Colors.white,
              size: SizeConfig.safeBlockVertical! * 4,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              await AuthService().signOut();

              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppStartupScreen()),
              );
            },
            child: Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.safeBlockHorizontal! * 1.5),
              child: Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: SizeConfig.safeBlockVertical! * 4.5,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal! * 5,
          vertical: SizeConfig.safeBlockVertical! * 3,
        ),
        child: FutureBuilder(
          future: fetchRestaurantDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            } else {
              var restaurant = snapshot.data!;
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.safeBlockVertical! * 25,
                      width: SizeConfig.safeBlockHorizontal! * 100,
                      child: Image.network(
                        restaurant.imageUrl!,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: SizeConfig.safeBlockVertical! * 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal! * 45,
                          height: SizeConfig.safeBlockVertical! * 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name:',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical! * 2.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Location:',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical! * 2.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Type:',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical! * 2.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Number of Tables:',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical! * 2.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal! * 3,
                        ),
                        SizedBox(
                          width: SizeConfig.safeBlockHorizontal! * 35,
                          height: SizeConfig.safeBlockVertical! * 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant.name ?? 'N/A',
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockVertical! * 2.25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocationScreen(
                                        location: LatLng(
                                          restaurant.location!.latitude,
                                          restaurant.location!.longitude,
                                        ),
                                        name: restaurant.name!,
                                        type: restaurant.type!,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'See location',
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockVertical! * 2.25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                restaurant.type ?? 'N/A',
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockVertical! * 2.25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '${restaurant.tableCount}',
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockVertical! * 2.25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox(height: 1)),
                    Center(
                      child: SizedBox(
                        width: SizeConfig.safeBlockHorizontal! * 65,
                        height: SizeConfig.safeBlockVertical! * 10,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the Edit Restaurant Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditRestaurantScreen(
                                        restaurant: _restaurant,
                                      )),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Text(
                            'Edit details',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 2.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
