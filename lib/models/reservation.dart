// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final DateTime? dateTime;
  final int? seatCount;
  final String? restaurant, email, area;
  final bool? approved;

  Reservation({
    this.dateTime,
    this.seatCount,
    this.restaurant,
    this.approved,
    this.email,
    this.area,
  });

  factory Reservation.fromDocument(DocumentSnapshot documentSnapshot) {
    DateTime dateTime = documentSnapshot.get('dateTime').toDate();
    int seatCount = documentSnapshot.get('seatCount');
    String restaurant = documentSnapshot.get('restaurant');
    String email = documentSnapshot.get('email');
    String area = documentSnapshot.get('area');
    bool approved = documentSnapshot.get('approved');

    return Reservation(
      dateTime: dateTime,
      seatCount: seatCount,
      restaurant: restaurant,
      approved: approved,
      email: email,
      area: area,
    );
  }
}
