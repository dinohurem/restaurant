// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:restaurant/shared/size_config.dart';

class CustomErrorScreen extends StatelessWidget {
  String? errorText;
  CustomErrorScreen({
    Key? key,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal! * 10,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 20,
              ),
              Icon(
                Icons.error,
                size: SizeConfig.safeBlockHorizontal! * 15,
                color: Colors.red,
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Oops!',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical! * 3,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 2,
              ),
              Text(
                errorText ??
                    'Please contact a super admin to access this content.',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical! * 2.25,
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 40,
              ),
              Center(
                child: SizedBox(
                  width: SizeConfig.safeBlockHorizontal! * 65,
                  height: SizeConfig.safeBlockVertical! * 10,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'BACK',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical! * 2.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
