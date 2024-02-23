import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPage extends StatefulWidget {
  // static String routeName = "/social_media";
  const SocialMediaPage({Key? key}) : super(key: key);

  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

// Function to open Instagram using url_launcher
Future<void> _launchUrl(String url) async {
  String instagramUrl = url.startsWith('http') ? url : 'https://$url';
  try {
    if (await canLaunch(instagramUrl)) {
      await launch(instagramUrl);
    } else {
      throw 'Could not launch $instagramUrl';
    }
  } on PlatformException catch (e) {
    print('Error launching Instagram: $e');
    // Handle platform exceptions here
  } catch (e) {
    print('Error launching Instagram: $e');
    // Handle other exceptions here
  }
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media Pages',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            "Visit our social media pages",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: Image.asset(
              'assets/icons/instagram.png', // Replace 'facebook_logo.png' with your asset image path
              width: 24, // Adjust the width as needed
              height:
                  24, // Adjust the height as needed // Change the color of the image
            ),
            title: Text(
              'Instagram',
              style: TextStyle(
                color: Colors.white, // Change the color of the text
              ),
            ),
            onTap: () {
              _launchUrl("https://www.instagram.com/evminute");
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/tiktok.png', // Replace 'facebook_logo.png' with your asset image path
              width: 24, // Adjust the width as needed
              height:
                  24, // Adjust the height as needed // Change the color of the image
            ),
            title: Text(
              'Tiktok',
              style: TextStyle(
                color: Colors.white, // Change the color of the text
              ),
            ),
            onTap: () {
              _launchUrl("www.tiktok.com/evminute");
            },
          ),
          const SizedBox(height: 30),
          Image.asset(
            'assets/images/splash.png', // Replace 'facebook_logo.png' with your asset image path
            width: 200, // Adjust the width as needed
            height: 200,
            color: Colors.white.withOpacity(0.2),
            colorBlendMode: BlendMode
                .modulate, // Adjust the height as needed // Change the color of the image
          ),
          // Add more ListTile widgets for other social media platforms
        ],
      ),
    );
  }
}
