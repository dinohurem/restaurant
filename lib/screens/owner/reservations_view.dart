// ignore_for_file: depend_on_referenced_packages, unused_import, prefer_interpolation_to_compose_strings, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/smtp_server/hotmail.dart';
import 'package:restaurant/models/reservation.dart';
import 'package:restaurant/shared/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:restaurant/services/keys.dart';

class ReservationsView extends StatefulWidget {
  final String restaurantId;
  const ReservationsView({
    super.key,
    required this.restaurantId,
  });

  @override
  State<ReservationsView> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Reservation>> _getReservations() async {
    List<Reservation> reservationDocs = [];
    QuerySnapshot snapshots = await _firestore
        .collection('reservations')
        .where('restaurant', isEqualTo: widget.restaurantId)
        .where('approved', isEqualTo: false)
        .get();

    for (var snapshot in snapshots.docs) {
      Reservation reservation;

      reservation = Reservation.fromDocument(snapshot);
      reservationDocs.add(reservation);
    }

    return reservationDocs;
  }

  Future _approveReservation(String reservationId) async {
    await _firestore
        .collection('reservations')
        .doc(reservationId)
        .update({'approved': true});
  }

  Future<String> _fetchReservationId(Reservation reservation) async {
    String reservationId = '';
    var snapshots = await _firestore
        .collection('reservations')
        .where("email", isEqualTo: reservation.email)
        .where("dateTime", isEqualTo: reservation.dateTime)
        .where("restaurant", isEqualTo: widget.restaurantId)
        .get();

    reservationId = snapshots.docs.first.id;
    return reservationId;
  }

  sendEmail(String email, DateTime dateTime, int seatCount, String area) async {
    final f = DateFormat('dd/MM/yyyy HH:mm');

    String username = keyEmail;
    String password = keyPassword;

    final smtpServer = hotmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add(email)
      ..subject = 'Reservation confirmed - ${f.format(dateTime)}'
      ..text =
          'Your reservation has been successfully approved.\n\nPlease see the details below:\n'
              'Date & time: ${f.format(dateTime)}\n'
              'Table for: $seatCount \n'
              'Area:  $area \n\n'
              'Thank you for using SaveASeat.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FutureBuilder<List<Reservation>>(
      future: _getReservations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
              height: SizeConfig.safeBlockVertical! * 10,
              child: Center(
                child: Text(
                  'No reservations at this point.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.safeBlockVertical! * 2,
                  ),
                ),
              ));
        } else {
          var reservations = snapshot.data;
          final f = DateFormat('dd/MM/yyyy HH:mm');

          return SizedBox(
            height: SizeConfig.safeBlockVertical! * 12 * reservations!.length,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: reservations.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    isThreeLine: true,
                    leading: Icon(
                      reservations[index].area!.toLowerCase() == 'smoking'
                          ? Icons.smoking_rooms
                          : Icons.smoke_free,
                      color: Colors.black,
                      size: SizeConfig.safeBlockVertical! * 4,
                    ),
                    title: Text(
                      '${reservations[index].email}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.safeBlockVertical! * 2,
                      ),
                    ),
                    subtitle: Text(
                      'Date & time: ${f.format(reservations[index].dateTime!)}\n'
                      'Table for: ${reservations[index].seatCount}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: SizeConfig.safeBlockVertical! * 1.75,
                      ),
                    ),
                    trailing: SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 20,
                      height: SizeConfig.safeBlockVertical! * 4,
                      child: ElevatedButton(
                        onPressed: () async {
                          var reservationId =
                              await _fetchReservationId(reservations[index]);

                          await _approveReservation(reservationId);
                          if (!mounted) {
                            return;
                          }

                          await sendEmail(
                              reservations[index].email!,
                              reservations[index].dateTime!,
                              reservations[index].seatCount!,
                              reservations[index].area!);

                          if (!mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.teal,
                              content: Padding(
                                padding: EdgeInsets.only(
                                  left: SizeConfig.safeBlockHorizontal! * 5,
                                ),
                                child: SizedBox(
                                  height: SizeConfig.safeBlockVertical! * 5,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: SizeConfig.safeBlockVertical! * 4,
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.safeBlockHorizontal! * 3,
                                      ),
                                      const Text(
                                        'Successfully approved a reservation request.',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                          Navigator.pop(context);
                        },
                        child: Text(
                          'Approve',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical! * 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
