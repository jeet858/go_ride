import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_ride/constants.dart';
import 'package:slider_button/slider_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.05,
          horizontal: MediaQuery.of(context).size.height * 0.02,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5, 0.9],
            colors: [
              Color(0xFF4D1B6A),
              Color(0xFF8438B0),
              Color(0xFF481A63),
            ],
          ),
        ),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.infinity,
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 117,
                          height: 117,
                        ),
                        Text(
                          'Go Ride',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          'Move Around Safely \n With Us',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliderButton(
              action: () async {
                Navigator.pushNamed(context, 'login');
                return null;
              },
              width: double.infinity,
              height: 45,
              label: Text(
                "Get Started",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
              alignLabel: Alignment.center,
              shimmer: false,
              icon: const Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
                size: 40,
              ),
              buttonSize: 40,
              buttonColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
