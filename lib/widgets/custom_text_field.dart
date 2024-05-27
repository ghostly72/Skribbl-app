import 'package:flutter/material.dart';

class customtextfield extends StatelessWidget {
  final TextEditingController namecontroller;
  final String hinttext;
  const customtextfield(
      {super.key, required this.namecontroller, required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: namecontroller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.vertical(),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        filled: true,
        fillColor: const Color(0xffF3F3FA),
        hintText: hinttext,
        hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
    );
  }
}
