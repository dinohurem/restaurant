// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant/models/restaurant.dart';
import 'package:restaurant/screens/owner/map_pin_selection_screen.dart';
import 'package:restaurant/shared/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditRestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;
  const EditRestaurantScreen({super.key, required this.restaurant});

  @override
  _EditRestaurantScreenState createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _restaurantName;
  late GeoPoint _restaurantLocation;
  late String _restaurantType, _imageUrl;
  late int _numTables;

  void updateRestaurantDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _firestore.collection('restaurants').doc(user.uid).set({
          'name': _restaurantName,
          'location': _restaurantLocation,
          'type': _restaurantType,
          'tableCount': _numTables,
          'imageUrl': _imageUrl,
        });

        Navigator.pop(context);
      }
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('restaurants/${DateTime.now().toString()}');
      await storageReference.putFile(imageFile);
      // You can save the download URL for later use or display.
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image to Firebase Storage: $e');
      }
      return '';
    }
  }

  // Function to open an image picker dialog
  Future pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var image = File(pickedFile.path);
      var imageUrl = await uploadImageToFirebase(image);

      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _restaurantLocation = widget.restaurant.location!;
    _imageUrl = widget.restaurant.imageUrl!;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Restaurant'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal! * 2,
          vertical: SizeConfig.safeBlockVertical! * 3,
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.restaurant.name,
                  onSaved: (value) => _restaurantName = value!,
                  decoration:
                      const InputDecoration(labelText: 'Restaurant Name'),
                ),
                TextFormField(
                  initialValue: widget.restaurant.type,
                  onSaved: (value) => _restaurantType = value!,
                  decoration:
                      const InputDecoration(labelText: 'Restaurant Type'),
                ),
                TextFormField(
                  initialValue: widget.restaurant.tableCount.toString(),
                  onSaved: (value) => _numTables = int.parse(value!),
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Number of Tables'),
                ),
                SizedBox(height: SizeConfig.safeBlockVertical! * 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 40,
                      height: SizeConfig.safeBlockVertical! * 8,
                      child: ElevatedButton(
                        onPressed: () async {
                          _restaurantLocation = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapPinSelectionScreen()),
                          );

                          setState(() {});
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                  size: SizeConfig.safeBlockVertical! * 3,
                                ),
                                Text(
                                  'Pick location',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockVertical! * 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: _restaurantLocation !=
                                  widget.restaurant.location,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical!,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: SizeConfig.safeBlockVertical! * 2.5,
                                    ),
                                    Text(
                                      'Updated',
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockVertical! * 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 40,
                      height: SizeConfig.safeBlockVertical! * 8,
                      child: ElevatedButton(
                        onPressed: () async {
                          await pickImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.white,
                              size: SizeConfig.safeBlockVertical! * 3,
                            ),
                            Text(
                              'Upload image',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical! * 2,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 2,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 35,
                  child: Image.network(_imageUrl.isNotEmpty ? _imageUrl : ''),
                ),
                const Expanded(child: SizedBox(height: 1)),
                Center(
                  child: SizedBox(
                    width: SizeConfig.safeBlockHorizontal! * 65,
                    height: SizeConfig.safeBlockVertical! * 10,
                    child: ElevatedButton(
                      onPressed: updateRestaurantDetails,
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 2.25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
