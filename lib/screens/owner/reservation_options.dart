import 'package:flutter/material.dart';
import 'package:restaurant/main.dart';
import 'package:restaurant/shared/size_config.dart';

class ReservationOptions extends StatefulWidget {
  const ReservationOptions({super.key});

  @override
  State<ReservationOptions> createState() => _ReservationOptionsState();
}

class _ReservationOptionsState extends State<ReservationOptions> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.safeBlockVertical! * 25,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal! * 10,
          vertical: SizeConfig.safeBlockVertical! * 3,
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date & time'),
                    Text('Number of people'),
                    Text('Area')
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Date & time'), Text('data'), Text('Area')],
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 6,
            ),
            Center(
              child: Container(
                color: Colors.lightBlue,
                width: SizeConfig.safeBlockHorizontal! * 65,
                height: SizeConfig.safeBlockVertical! * 6.5,
                child: TextButton(
                  child: const Text(
                    'CONFIRM',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    // TODO: minus 1 table
                    // TODO: style bottom modal sheet

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
    );
  }
}
