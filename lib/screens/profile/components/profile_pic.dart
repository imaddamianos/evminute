import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:evminute/helper/secure_storage.dart';
import 'package:http/http.dart' as http;

final _secureStorage = SecureStorage();

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
    required this.onPickImage,
    required this.imageUrl,
  }) : super(key: key);

  final void Function(File pickedImage) onPickImage;
  final String imageUrl;

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxHeight: 150,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          widget.onPickImage(_image!); // Notify parent widget
        });
      }
    } catch (error) {
      print('Error picking image: $error');
      // Handle error (show a message, log, etc.)
    }
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  title: "Gallery",
                  source: ImageSource.gallery,
                ),
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  title: "Camera",
                  source: ImageSource.camera,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _pickImage(source);
      },
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage:
                // _image != null
                //     ? FileImage(_image!) // If there is a selected image, use it
                NetworkImage(
                    widget.imageUrl), // Otherwise, use the network image
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () async {
                  await _showImageSourceDialog();
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
