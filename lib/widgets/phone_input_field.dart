import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController textEditingController;

  const PhoneInputField({super.key, required this.textEditingController});

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: 50,
          decoration: const BoxDecoration(
              color: Color(0xFFECECEC),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/india_flag.png'),
              Text(
                '+91',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.65,
          height: 50,
          decoration: const BoxDecoration(
              color: Color(0xFFECECEC),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Material(
            child: TextField(
              cursorHeight: 17,
              controller: widget.textEditingController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter Your Phone Number',
                contentPadding: EdgeInsets.only(top: 4, left: 10),
                fillColor: Color(0xFFECECEC), // Transparent background
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when focused
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Colors.transparent), // Transparent border in general
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
