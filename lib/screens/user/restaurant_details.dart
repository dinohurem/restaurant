// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:restaurant/screens/owner/location_screen.dart';
import 'package:restaurant/screens/user/reservation_options.dart';
import 'package:restaurant/shared/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final DocumentSnapshot restaurant;

  const RestaurantDetailsScreen(this.restaurant, {super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Details - ${restaurant['name']}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.safeBlockVertical! * 3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: SizeConfig.safeBlockVertical! * 25,
              child: restaurant['imageUrl'].toString().isEmpty
                  ? SvgPicture.asset('assets/not_found.svg',
                      semanticsLabel: 'A placeholder image')
                  : Image.network(restaurant['imageUrl']),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 2,
            ),
            Center(
              child: SizedBox(
                height: SizeConfig.safeBlockVertical! * 15,
                width: SizeConfig.safeBlockHorizontal! * 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name:',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 3,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        Text(
                          'Location:',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 3,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        Text(
                          'Type:',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 3,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${restaurant['name']}',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 3,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationScreen(
                                  location: LatLng(
                                      restaurant['location']!.latitude,
                                      restaurant['location']!.longitude),
                                  name: restaurant['name'],
                                  type: restaurant['type'],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'See location',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 2.25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          '${restaurant['type']}',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical! * 3,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
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
                          return ReservationOptions(restaurant: restaurant);
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
