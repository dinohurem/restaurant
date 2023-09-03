import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String? name, type, imageUrl;
  final int? tableCount;
  final GeoPoint? location;

  Restaurant({
    this.name,
    this.location,
    this.type,
    this.tableCount,
    this.imageUrl,
  });

  factory Restaurant.fromDocument(DocumentSnapshot documentSnapshot) {
    String name = documentSnapshot.get('name');
    GeoPoint location =
        documentSnapshot.get('location') ?? const GeoPoint(0, 0);
    int tableCount = documentSnapshot.get('tableCount');
    String type = documentSnapshot.get('type');
    String imageUrl = documentSnapshot.get('imageUrl');

    return Restaurant(
      name: name,
      location: location,
      tableCount: tableCount,
      type: type,
      imageUrl: imageUrl,
    );
  }
}
