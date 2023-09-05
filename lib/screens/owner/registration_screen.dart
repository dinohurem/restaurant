// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:restaurant/screens/owner/owner_dashboard_screen.dart';
import 'package:restaurant/services/auth.dart';
import 'package:restaurant/shared/size_config.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password, _restaurantName;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal! * 5,
          vertical: SizeConfig.safeBlockVertical! * 3,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter your restaurant name';
                  }
                  return null;
                },
                onSaved: (input) => _restaurantName = input!,
                decoration: const InputDecoration(
                  labelText: 'Restaurant Name',
                ),
              ),
              TextFormField(
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (input) => _email = input!,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                validator: (input) {
                  if (input!.length < 6) {
                    return 'Your password needs to be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (input) => _password = input!,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 3,
              ),
              Center(
                child: SizedBox(
                  width: SizeConfig.safeBlockHorizontal! * 65,
                  height: SizeConfig.safeBlockVertical! * 10,
                  child: ElevatedButton(
                    onPressed: signUp,
                    child: const Text('Register'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await AuthService()
            .registerWithEmailAndPassword(_email, _password, _restaurantName);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OwnerDashboardScreen()),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Registration failed. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
