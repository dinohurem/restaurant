// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:restaurant/main.dart';
import 'package:restaurant/services/database.dart';
import 'package:restaurant/shared/size_config.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationOptions extends StatefulWidget {
  final DocumentSnapshot restaurant;
  const ReservationOptions({super.key, required this.restaurant});

  @override
  State<ReservationOptions> createState() => _ReservationOptionsState();
}

class _ReservationOptionsState extends State<ReservationOptions> {
  DateTime? _datePicked = DateTime.now();
  int _seatCount = 0;
  String? _email = '';
  String? _area = 'Non-smoking';
  final _options = [
    'Non-smoking',
    'Smoking',
  ];
  final _formKey = GlobalKey<FormBuilderState>();

  Future createReservationDetails() async {
    await DatabaseService().createReservation(
        widget.restaurant.id, _datePicked!, _seatCount, _area!, _email!);
  }

  DropdownMenuItem<String> _buildMenuItem(String text) =>
      DropdownMenuItem<String>(
        value: text,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal! * 4),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig.safeBlockVertical! * 50,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal! * 5,
              vertical: SizeConfig.safeBlockVertical! * 3,
            ),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical! * 35,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date & time:',
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockVertical! * 2.25,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 9,
                            ),
                            Text(
                              'People:',
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockVertical! * 2.25,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 10,
                            ),
                            Text(
                              'Area:',
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockVertical! * 2.25,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 5,
                            ),
                            Text(
                              'Email:',
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockVertical! * 2.25,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal! * 50,
                              child: FormBuilderDateTimePicker(
                                name: 'date',
                                initialEntryMode: DatePickerEntryMode.calendar,
                                initialValue: DateTime.now(),
                                inputType: InputType.both,
                                decoration: InputDecoration(
                                  labelText: 'Pick a date & time.',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['date']
                                          ?.didChange(null);
                                    },
                                  ),
                                ),
                                initialTime:
                                    const TimeOfDay(hour: 8, minute: 0),
                                onSaved: (value) {
                                  setState(() {
                                    _datePicked = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal! * 50,
                              child: FormBuilderSlider(
                                name: 'slider',
                                onChanged: (value) {
                                  setState(() {
                                    _seatCount = value!.toInt();
                                  });
                                },
                                min: 0,
                                max: 10,
                                initialValue: 4,
                                divisions: 10,
                                activeColor: Colors.teal,
                                inactiveColor: Colors.teal[100],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 5,
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal! * 50,
                              height: SizeConfig.safeBlockVertical! * 4.5,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.safeBlockHorizontal! * 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.safeBlockVertical!,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        SizeConfig.safeBlockVertical!,
                                      ),
                                    ),
                                    dropdownColor:
                                        Theme.of(context).primaryColorDark,
                                    isExpanded: true,
                                    menuMaxHeight:
                                        SizeConfig.safeBlockVertical! * 35,
                                    iconSize:
                                        SizeConfig.safeBlockHorizontal! * 4,
                                    iconEnabledColor: Colors.white,
                                    hint: const Text(
                                      'Choose an area *',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockVertical! * 1.75,
                                    ),
                                    value: _area,
                                    items:
                                        _options.map(_buildMenuItem).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _area = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.safeBlockHorizontal! * 50,
                              child: FormBuilderTextField(
                                initialValue: _email,
                                keyboardType: TextInputType.emailAddress,
                                name: 'email',
                                onSubmitted: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: SizeConfig.safeBlockVertical!,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 65,
                      height: SizeConfig.safeBlockVertical! * 6.5,
                      child: ElevatedButton(
                        child: const Text(
                          'CONFIRM',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          await createReservationDetails();

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
                                        'Successfully sent a reservation request.',
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

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AppStartupScreen()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
