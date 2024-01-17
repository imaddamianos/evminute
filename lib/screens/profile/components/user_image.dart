import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class _UserImagePickersState extends StatefulWidget {
  const _UserImagePickersState();

  @override
  State<_UserImagePickersState> createState() => _UserImagePickersStateState();
}

class _UserImagePickersStateState extends State<_UserImagePickersState> {
  // ignore: non_constant_identifier_names
  File? _PickedImageFile;

  // ignore: non_constant_identifier_names
  void _PickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 150,
      imageQuality: 50,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _PickedImageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _PickedImageFile == null ? null : FileImage(_PickedImageFile!),
        ),
        TextButton.icon(
          onPressed: _PickImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
