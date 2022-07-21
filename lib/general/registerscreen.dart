import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';
import 'package:new_swarn_holidays/ecom/exceptions/firebaseauth/signup_exceptions.dart';
import 'package:new_swarn_holidays/general/backgroundimage.dart';
import 'package:new_swarn_holidays/ecom/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:new_swarn_holidays/ecom/services/authentification/authentification_service.dart';
import 'package:new_swarn_holidays/general/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //formkey
  final _formKey = GlobalKey<FormState>();

  final bool _isLoading = false;

  late String? dateTime;

  //authentication
  // final _auth = FirebaseAuth.instance;

  //editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const BackgroundImage(),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SafeArea(
            // ignore: sized_box_for_whitespace
            child: Container(
              height: MediaQuery.of(context).size.height * 1.3,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: TextFormField(
                            controller: firstNameController,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: const InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(CupertinoIcons.person_fill,
                                    color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelStyle: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{1,}$');
                              if (value!.isEmpty) {
                                return "Please Enter Your First Name";
                              }
                              if (!regex.hasMatch(value)) {
                                return "First Name Should be at least of 1 characters";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              firstNameController.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: TextFormField(
                            controller: secondNameController,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: const InputDecoration(
                                labelText: 'Second Name (Surname)',
                                prefixIcon: Icon(CupertinoIcons.person_fill,
                                    color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelStyle: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{1,}$');
                              if (value!.isEmpty) {
                                return "Please Enter Your Second Name";
                              }
                              if (!regex.hasMatch(value)) {
                                return "Name Should be at least of 1 characters";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              secondNameController.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: TextFormField(
                            controller: emailController,
                            autofocus: false,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon:
                                    Icon(Icons.mail, color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelStyle: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return " Please Enter Your Email";
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              emailController.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: TextFormField(
                            controller: passwordController,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon:
                                    Icon(Icons.vpn_key, color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelStyle: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            obscureText: true,
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.trim().isEmpty) {
                                return " Please Enter Your Password";
                              }
                              if (!regex.hasMatch(value)) {
                                return 'Password must be at least 6 characters';
                              }
                              if (value.trim().length > 12) {
                                return 'Password must be at most 12 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              passwordController.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: TextFormField(
                            controller: confirmPasswordController,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelStyle: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            obscureText: true,
                            validator: (value) {
                              if (confirmPasswordController.text !=
                                  passwordController.text) {
                                return " Password doesn't matched";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              confirmPasswordController.text = value!;
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        if (_isLoading) const CircularProgressIndicator(),
                        if (!_isLoading)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 8,
                                primary: Colors.red,
                                fixedSize: const Size(200, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final AuthentificationService authService =
                                    AuthentificationService();
                                bool? signUpStatus = false;
                                String? snackbarMessage;
                                try {
                                  final signUpFuture = authService.signUp(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      firstName: firstNameController.text,
                                      secondName: secondNameController.text,
                                      context: context);
                                  signUpFuture
                                      .then((value) => signUpStatus = value);
                                  signUpStatus = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FutureProgressDialog(
                                        signUpFuture,
                                        message: const Text(
                                          "Creating new account",
                                          style: TextStyle(color: Colors.pink),
                                        ),
                                      );
                                    },
                                  );
                                        if (signUpStatus == true) {
                                    snackbarMessage = "Almost there";
                                  } else {
                                    throw FirebaseSignUpAuthUnknownReasonFailureException();
                                  } 
                                } on MessagedFirebaseAuthException catch (e) {
                                  snackbarMessage = e.message;
                                } catch (e) {
                                  snackbarMessage = e.toString();
                                } finally {
                                  Logger().i(snackbarMessage);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(snackbarMessage!),
                                    ),
                                  );
                                  if (signUpStatus == true) {
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            },
                            child: const Text(
                              'Register ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 20.0),
                        if (!_isLoading)
                          ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const LogInScreen())),
                            style: ElevatedButton.styleFrom(
                                elevation: 8,
                                primary: Colors.blue,
                                fixedSize: const Size(200, 40),
                                alignment: Alignment.center,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Center(
                              child: Text(
                                'Back to LogIn',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
