// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../complete_profile/complete_profile_screen.dart';
import 'package:evminute/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:evminute/helper/loader.dart';
import 'package:evminute/helper/secure_storage.dart';

final _firebase = FirebaseAuth.instance;
final _secureStorage = SecureStorage();

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conform_password;
  bool remember = false;
  final List<String?> errors = [];
  final GlobalLoader _globalLoader = GlobalLoader();

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    try {
      FirebaseOptions options = DefaultFirebaseOptions.currentPlatform;
// Modify options as needed
      await Firebase.initializeApp(options: options);

      setState(() {}); // Trigger a rebuild if needed
    } catch (e) {
      // Handle errors
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              hintStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              labelStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              hintStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              labelStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            onSaved: (newValue) => conform_password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.isNotEmpty && password == conform_password) {
                removeError(error: kMatchPassError);
              }
              conform_password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if ((password != value)) {
                addError(error: kMatchPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              hintText: "Re-enter your password",
              hintStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              labelStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _globalLoader.showLoader(context);
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                try {
                  String? savedEmail = await _secureStorage.getEmail();
                  _secureStorage.saveEmailAndPassword(savedEmail, password);
                  await _firebase.createUserWithEmailAndPassword(
                    email: email!,
                    password: password!,
                  );

                  Navigator.pushNamed(
                    context,
                    CompleteProfileScreen.routeName,
                    arguments: email,
                  );
                } catch (e) {
                  // Handle any errors that occurred during user creation
                  if (e is FirebaseAuthException) {
                    if (e.code == 'email-already-in-use') {
                      // The email address is already in use by another account.
                      // Display a message to the user or use a snackbar.
                      debugPrint("Error creating user: ${e.message}");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Email is already in use.')));
                    } else {
                      // Handle other FirebaseAuthException codes if needed
                      debugPrint("Error creating user: ${e.message}");
                    }
                  } else {
                    // Handle other exceptions
                    debugPrint("Error creating user: $e");
                  }
                }
                _globalLoader.hideLoader();
              } else {
                _globalLoader.hideLoader();
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
