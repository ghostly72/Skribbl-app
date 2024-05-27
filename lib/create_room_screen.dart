import 'package:flutter/material.dart';
import 'package:skribbl/paintscreen.dart';
import 'package:skribbl/widgets/custom_text_field.dart';

class createroomscreen extends StatefulWidget {
  const createroomscreen({super.key});

  @override
  State<createroomscreen> createState() => _createroomscreenState();
}

TextEditingController namecontroller = TextEditingController();
TextEditingController roomcontroller = TextEditingController();
String? maxrounds = "1";
String? maxparticipants = "1";

class _createroomscreenState extends State<createroomscreen> {
  @override
  Widget build(BuildContext context) {
    void createroom() {
      if (namecontroller.text.isNotEmpty &&
          roomcontroller.text.isNotEmpty &&
          maxrounds != null &&
          maxparticipants != null) {
        Map<String, String> data = {
          "nickname": namecontroller.text,
          "name": roomcontroller.text,
          "occupancy":
              maxparticipants!, //! shows that this value can never be null
          "maxrounds": maxrounds!
        };
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                paintscreen(data: data, screenfrom: 'createscreen'))); //
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            const Text(
              'Create a Room',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: customtextfield(
                  namecontroller: namecontroller, hinttext: 'Enter your Name'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: customtextfield(
                  namecontroller: roomcontroller, hinttext: 'Enter Room name'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            DropdownButton<String>(
              // value: maxrounds,
              items: <String>["2", "5", "10", "15"]
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          )))
                  .toList(),
              hint: const Text(
                'Max no of rounds',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onChanged: (String? value) {
                setState(() {
                  maxrounds = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
              // value: maxparticipants,
              items: <String>["1", "2", "3", "4", "5", "6", "7", "8"]
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          )))
                  .toList(),
              hint: const Text(
                'Max no of participants',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onChanged: (String? value) {
                setState(() {
                  maxparticipants = value;
                });
              },
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () {
                createroom();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white)),
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width / 2.5, 50)),
              ),
              child: const Text(
                "create",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
