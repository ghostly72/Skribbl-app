import 'package:flutter/material.dart';
import 'package:skribbl/widgets/custom_text_field.dart';
import 'paintscreen.dart';

class joinroomscreen extends StatefulWidget {
  const joinroomscreen({super.key});

  @override
  State<joinroomscreen> createState() => _joinroomscreenState();
}

TextEditingController namecontroller = TextEditingController();
TextEditingController roomcontroller = TextEditingController();

class _joinroomscreenState extends State<joinroomscreen> {
  @override
  Widget build(BuildContext context) {
    void joinroom() {
      if (namecontroller.text.isNotEmpty && roomcontroller.text.isNotEmpty) {
        Map<String, String> data = {
          "nickname": namecontroller.text,
          "name": roomcontroller.text,
        };
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                paintscreen(data: data, screenfrom: 'joinscreen'))); //
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Join a Room',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: customtextfield(
                namecontroller: namecontroller, hinttext: 'Enter your name'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: customtextfield(
                namecontroller: roomcontroller, hinttext: 'Enter Room name'),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 60,
          ),
          ElevatedButton(
            onPressed: joinroom,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white)),
              minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50)),
            ),
            child: const Text(
              "Join",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
