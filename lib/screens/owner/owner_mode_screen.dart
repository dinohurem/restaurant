import 'package:flutter/material.dart';
import 'package:restaurant/screens/owner/login_screen.dart';
import 'package:restaurant/screens/owner/registration_screen.dart';
import 'package:restaurant/shared/size_config.dart';

class OwnerModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Mode'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please choose one of the options:',
              style: TextStyle(
                fontSize: SizeConfig.safeBlockVertical! * 2.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: SizeConfig.safeBlockHorizontal! * 65,
                height: SizeConfig.safeBlockVertical! * 12,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Login Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical! * 2.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: SizeConfig.safeBlockHorizontal! * 65,
                height: SizeConfig.safeBlockVertical! * 12,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Registration Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()),
                    );
                  },
                  child: Text(
                    'Register',
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
    );
  }
}
