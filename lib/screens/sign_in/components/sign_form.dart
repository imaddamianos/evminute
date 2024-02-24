import 'package:evminute/helper/secure_storage.dart';
import 'package:evminute/screens/home/home_screen.dart';
import 'package:evminute/screens/init_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../forgot_password/forgot_password_screen.dart';
import 'package:evminute/screens/login_success/login_success_screen.dart';
import 'package:evminute/firebase_options.dart';
import 'package:evminute/helper/loader.dart';

final _secureStorage = SecureStorage();
final _firebase = FirebaseAuth.instance;

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final GlobalLoader _globalLoader = GlobalLoader();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = true;
  final List<String?> errors = [];

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

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    loadSavedCredentials();
  }

  Future<void> loadSavedCredentials() async {
    final savedEmail = await _secureStorage.getEmail();
    final savedPassword = await _secureStorage.getPassword();

    if (savedEmail != null && savedPassword != null) {
      try {
        await _firebase.signInWithEmailAndPassword(
          email: savedEmail,
          password: savedPassword,
        );

        Navigator.pushNamed(context, InitScreen.routeName);
      } on FirebaseAuthException catch (e) {
        // Handle any errors that occurred during sign-in
        debugPrint("Error signing in: ${e.code}");
        // You can add error handling UI or display a snackbar here
      }
      setState(() {
        email = savedEmail;
        password = savedPassword;
        remember = true;
      });
    }
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
            controller: TextEditingController(
                text: email), // Set the controller with the saved email
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              hintStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              labelStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              // If  you are using the latest version of flutter, then lable text and hint text shown like this
              // if you are using flutter less than 1.20.*, then maybe this is not working properly
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
              return;
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
            controller: TextEditingController(
                text: password), // Set the controller with the saved password
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              hintStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              labelStyle: TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
              // If  you are using the latest version of flutter then lable text and hint text shown like this
              // if you are using flutter less than 1.20.*, then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    // Only update the state if the value changes to true
                    if (value == true) {
                      remember = value;
                      // If "Remember me" is checked, save email and password
                      _secureStorage.saveEmailAndPassword(email, password);
                    } else {
                      remember = value;
                      // If "Remember me" is unchecked, clear saved email and password
                      _secureStorage.clearEmailAndPassword();
                    }
                  });
                },
              ),
              const Text(
                "Remember me",
                style: TextStyle(color: Colors.white),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              _globalLoader.showLoader(context);
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  await _firebase.signInWithEmailAndPassword(
                    email: email!,
                    password: password!,
                  );

                  _secureStorage.saveEmailAndPassword(email, password);

                  Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                } on FirebaseAuthException catch (e) {
                  // Handle any errors that occurred during sign-in
                  debugPrint("Error signing in: ${e.code}");
                  // You can add error handling UI or display a snackbar here
                }

                // ignore: use_build_context_synchronously
                KeyboardUtil.hideKeyboard(context);
              }
              _globalLoader.hideLoader();
            },
            child: const Text("L O G I N"),
          ),
        ],
      ),
    );
  }
}
