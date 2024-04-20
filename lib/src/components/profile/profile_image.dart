import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importujte balíček Firebase Auth
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../../../domain/theme/consts.dart';

class UserImage extends StatefulWidget {
  const UserImage({Key? key}) : super(key: key);

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return WidgetCircularAnimator(
      outerIconsSize: 3,
      innerAnimation: Curves.easeInOutBack,
      outerAnimation: Curves.easeInOutBack,
      innerColor: Theme.of(context).primaryColor,
      outerColor: Colors.orangeAccent,
      innerAnimationSeconds: 10,
      outerAnimationSeconds: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildUserProfile(context),
      ),
    );
  }

  Future<String> getName() async {
    String name;
    final preferences = await SharedPreferences.getInstance();
    return name = preferences.getString('nickname') ?? '';
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Widget _buildUserProfile(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 80,
        width: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: _imagePath != null
            ? Image.file(
                File(_imagePath!),
                fit: BoxFit.cover,
              )
            : user?.photoURL != null
                ? Image.network(
                    user!.photoURL!,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 80,
                  ),
      ),
    );
  }
}
