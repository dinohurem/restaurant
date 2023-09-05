// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:restaurant/config/firebase_options.dart';
import 'package:restaurant/screens/owner/owner_mode_screen.dart';
import 'package:restaurant/screens/user/user_mode_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaurant/shared/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'SaveASeat',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SaveASeat',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const AppStartupScreen(),
    );
  }
}

class AppStartupScreen extends StatelessWidget {
  const AppStartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'SaveASeat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to SaveASeat!',
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockVertical! * 3.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical! * 5,
            ),
            Center(
              child: SizedBox(
                width: SizeConfig.safeBlockHorizontal! * 65,
                height: SizeConfig.safeBlockVertical! * 12,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Owner Mode
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OwnerModeScreen()),
                    );
                  },
                  child: Text(
                    'Owner Mode',
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
                    // Navigate to the User Mode
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserModeScreen()),
                    );
                  },
                  child: Text(
                    'User Mode',
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
