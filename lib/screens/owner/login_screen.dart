// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:restaurant/screens/owner/owner_dashboard_screen.dart';
import 'package:restaurant/services/auth.dart';
import 'package:restaurant/shared/size_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                keyboardType: TextInputType.emailAddress,
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
                height: SizeConfig.safeBlockVertical! * 2,
              ),
              Center(
                child: SizedBox(
                  width: SizeConfig.safeBlockHorizontal! * 65,
                  height: SizeConfig.safeBlockVertical! * 10,
                  child: ElevatedButton(
                    onPressed: signIn,
                    child: Text(
                      'Log In',
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

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        var user =
            await AuthService().signInWithEmailAndPassword(_email, _password);

        if (user == null) {
          throw Exception('Invalid credentials.');
        }
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
              content: const Text('Invalid email or password.'),
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
