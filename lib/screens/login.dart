import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_ride/constants.dart';
import 'package:go_ride/widgets/custom_button.dart';
import 'package:go_ride/widgets/phone_input_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TapGestureRecognizer _tapGestureRecognizer;
  final TextEditingController _textEditingController = TextEditingController();
  bool checkBoxValue = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handlePress();
  }

  void _handlePress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('TextField clicked!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width * 0.1,
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Your Mobile Number',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                PhoneInputField(textEditingController: _textEditingController),
                const SizedBox(height: 31),
                Text(
                  'Accept our Terms & Conditions and Review Privacy Notice',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text:
                        'By selecting “I Agree” below, I have reviewed and agree to the ',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms Of Use',
                        style: const TextStyle(
                          color: kPrimaryTextColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'We are still updating our terms and conditions'),
                              ),
                            );
                          },
                      ),
                      const TextSpan(text: ' and acknowledge the'),
                      TextSpan(
                        text: ' Privacy Notice.',
                        style: const TextStyle(color: kPrimaryTextColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'We are still updating our terms and conditions'),
                              ),
                            );
                          },
                      ),
                      const TextSpan(text: ' I am at least 18 years of age.')
                    ],
                  ),
                ),
                const SizedBox(height: 43),
                Row(
                  children: [
                    SizedBox(
                      width: 19,
                      height: 19,
                      child: Checkbox(
                        value: checkBoxValue,
                        onChanged: (e) {
                          setState(() {
                            checkBoxValue = e!;
                          });
                        },
                      ),
                    ),
                    Text(
                      '  I Agree',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 76.5),
                CustomButton(
                  onPressed: () async {
                    if (checkBoxValue &&
                        _textEditingController.text.length == 10) {
                      Navigator.pushNamed(context, 'otp', arguments: {
                        'phoneNumber': _textEditingController.text
                      });
                      // await FirebaseAuth.instance.verifyPhoneNumber(
                      //   phoneNumber: '+91${_textEditingController.text}',
                      //   verificationCompleted: (phoneAuthCredential) {},
                      //   verificationFailed: (FirebaseAuthException e) {
                      //     log(e.toString());
                      //     if (e.code == 'invalid-phone-number') {
                      //       log('The provided phone number is not valid.');
                      //     } else if (e.code == 'too-many-requests') {
                      //       log('Too many requests. Try again later.');
                      //     } else {
                      //       log('in last else: ${e.toString()}');
                      //     }
                      //   },
                      //   codeSent: (verificationId, forceResendingToken) {
                      //     log('code sent');
                      //     log('forceResendingToken: $forceResendingToken');
                      //     Navigator.pushNamed(context, 'otp', arguments: {
                      //       'phoneNumber': _textEditingController.text
                      //     });
                      //   },
                      //   codeAutoRetrievalTimeout: (verificationId) {
                      //     log("Auto Retireval timeout");
                      //   },
                      // );
                    } else if (!checkBoxValue) {
                      var snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          //HEADS-UP: the height property of this widget has been manually added by editing and adding the following lines in the library files for version awesome_snackbar_content: ^0.1.4
                          //HEADS-UP: add final double? height; at line 39 before constructor
                          //HEADS-UP: add this.height, at line 49 in the constructor
                          //HEADS-UP: add height: height??size.height * 0.125, at line 83 at the container
                          height: MediaQuery.of(context).size.height * 0.14,
                          inMaterialBanner: true,
                          title: 'On Snap!',
                          message:
                              'Please click on the checkbox to accept our terms and conditions',
                          contentType: ContentType.failure,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    } else if (_textEditingController.text.length != 10) {
                      var snackBar = const SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'On Snap!',
                          message: 'Please enter a valid phone number',
                          contentType: ContentType.failure,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
