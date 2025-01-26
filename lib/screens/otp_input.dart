import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_ride/controllers/firebase.dart';
import 'package:go_ride/controllers/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_ride/widgets/custom_button.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({super.key});

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final phoneNumber = arguments['phoneNumber'] ?? '';

    TextEditingController otpController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 53, horizontal: 27),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                'Enter the 6-digit code send to you at +91 $phoneNumber',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                length: 6,
                appContext: context,
                controller: otpController,
                keyboardType: TextInputType.number,
                autoDismissKeyboard: true,
                autoFocus: false,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  activeColor: const Color(0xFFE6E6E6),
                  inactiveColor: const Color(0xFFE6E6E6),
                  selectedColor: const Color(0xFFE6E6E6),
                  selectedFillColor: Colors.white,
                  inactiveFillColor: const Color(0xFFE6E6E6),
                ),
                enableActiveFill: true,
              ),
              CustomButton(
                onPressed: () async {
                  await UserPreferences.instance.saveLogin(phoneNumber);
                  Navigator.pushNamed(context, 'map',
                      arguments: {'phoneNumber': phoneNumber});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
