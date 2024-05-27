// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class waitinglobbyscreen extends StatefulWidget {
  final int occupancy;
  final int noofplayers;
  final String lobbyname;
  final players;
  const waitinglobbyscreen(
      {required this.occupancy,
      required this.noofplayers,
      required this.lobbyname,
      required this.players,
      super.key});

  @override
  State<waitinglobbyscreen> createState() => _waitinglobbyscreenState();
}

class _waitinglobbyscreenState extends State<waitinglobbyscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'waiting for all players to join',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            readOnly: true,
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.lobbyname));
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('copied to clipboard')));
            },
            // controller: namecontroller,
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
              hintText: 'Tap to copy room code',
              hintStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        const Text(
          'Players',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
            primary: true,
            shrinkWrap: true,
            itemCount: widget.noofplayers,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(
                  "${index + 1}.",
                  style: TextStyle(fontSize: 18),
                ),
                title: Text(
                  widget.players[index]['nickname'],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            })
      ],
    ));
  }
}
