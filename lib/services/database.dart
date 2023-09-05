// ignore_for_file: depend_on_referenced_packages, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});
  // Collection reference.

  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');
  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservations');

  Future updateRestaurantData(String name, GeoPoint location, String type,
      int tableCount, String imageUrl) async {
    return await restaurantCollection.doc().set({
      'name': name,
      'location': location,
      'type': type,
      'tableCount': tableCount,
      'imageUrl': imageUrl,
      'owner': uid,
    });
  }

  Future createReservation(
    String restaurantId,
    DateTime dateTime,
    int seatCount,
    String area,
    String email,
  ) async {
    await reservationCollection.doc().set({
      'email': email,
      'dateTime': dateTime,
      'seatCount': seatCount,
      'area': area,
      'restaurant': restaurantId,
      'approved': false
    });
  }
}
