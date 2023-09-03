// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});
  // Collection reference.

  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');

  Future updateRestaurantData(String name, GeoPoint location, String type,
      int tableCount, String imageUrl) async {
    return await restaurantCollection.doc(uid).set({
      'name': name,
      'location': location,
      'type': type,
      'tableCount': tableCount,
      'imageUrl': imageUrl,
    });
  }
}
