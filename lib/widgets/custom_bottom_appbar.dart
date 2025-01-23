import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_ride/constants.dart';

class CustomBottomAppbar extends StatelessWidget {
  const CustomBottomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        border: Border(top: BorderSide(width: 1)),
        color: Colors.white,
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/home-icon.png',
                width: 25,
              ),
              Text(
                'Home',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: kPrimaryColor),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/gear-icon.png',
                width: 25,
              ),
              Text(
                'Profile',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: kPrimaryColor),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/services-icon.png',
                width: 25,
              ),
              Text(
                'Services',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: kPrimaryColor),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/user-alt-icon.png',
                width: 25,
              ),
              Text(
                'Profile',
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: kPrimaryColor),
              )
            ],
          ),
        ],
      ),
    );
  }
}
