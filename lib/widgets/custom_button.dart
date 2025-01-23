import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_ride/constants.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final Color? backgroundColor;
  final String? buttonText;
  final EdgeInsets? margin;

  const CustomButton(
      {super.key,
      required this.onPressed,
      this.backgroundColor,
      this.buttonText,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor ?? kPrimaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(9999),
          ),
        ),
        child: Center(
          child: Text(
            buttonText ?? 'Continue',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
