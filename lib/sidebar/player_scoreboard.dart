import 'package:flutter/material.dart';

class player_scoreboard extends StatelessWidget {
  final List<Map> userdata;
  const player_scoreboard({required this.userdata, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
          child: Container(
        height: double.maxFinite,
        child: ListView.builder(
            itemCount: userdata.length,
            itemBuilder: (context, index) {
              var data = userdata[index].values;
              return ListTile(
                title: Text(
                  data.elementAt(0),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  data.elementAt(1),
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }),
      )),
    );
  }
}
