import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skribbl/models/mycustompainter.dart';
import 'package:skribbl/models/touchpoints.dart';
import 'package:skribbl/sidebar/player_scoreboard.dart';
import 'package:skribbl/waitinglobbyscreen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class paintscreen extends StatefulWidget {
  final Map<String, String> data;
  final String screenfrom;
  const paintscreen({super.key, required this.data, required this.screenfrom});

  @override
  State<paintscreen> createState() => _paintscreenState();
}

late IO.Socket socket;
Map dataofroom = {};
List<touchpoints> points = [];
StrokeCap stroketype = StrokeCap.round;
Color selectedcolor = Colors.black;
double opacity = 1;
double strokewidth = 2;
List<Widget> textblankwidget = [];
ScrollController scrollcontroller = ScrollController();
List<Map> messages = [];
TextEditingController controller = TextEditingController();
int guessseduserctr = 0;
int start = 60;
late Timer timer;
var scaffoldkey = GlobalKey<ScaffoldState>();
List<Map> scoreboard = [];
bool inputreadonly = false;

class _paintscreenState extends State<paintscreen> {
  @override
  void initState() {
    // TODO: implement initState
    // print('initstate');
    super.initState();
    connect();
    // starttimer();
  }

  void starttimer() {
    const onesec = Duration(seconds: 1);
    timer = Timer.periodic(onesec, (time) {
      if (start == 0) {
        socket.emit('change-turn', dataofroom['name']);
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void rendertextblank(String text) {
    textblankwidget.clear();
    for (int i = 0; i < text.length; i++) {
      textblankwidget.add(const Text(
        '_',
        style: TextStyle(fontSize: 25),
      ));
    }
  }

  void connect() {
    // print('connext');
    socket = IO.io(
        'http://192.168.29.28:3000',
        // IO.OptionBuilder()
        //     .setTransports(['websocket'])
        //     .disableAutoConnect()
        //     .build()
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });
    socket.connect();

    if (widget.screenfrom == 'createscreen') {
      print('widget.data= ${widget.data}');
      socket.emit('createscreen', widget.data);
    } else {
      socket.emit('join-game', widget.data);
    }
    // print('qwerty');
    socket.onConnect((data) {
      // print('hello world');
      print(socket.connected);
      socket.on(
          'updateroom',
          (roomdata) => {
                setState(() {
                  rendertextblank(roomdata['word']);
                  dataofroom = roomdata;
                  print('data of room - ${dataofroom}');
                }),
                if (roomdata['isjoin'] != true) {starttimer()},
                scoreboard.clear(),
                for (int i = 0; i < roomdata['players'].length; i++)
                  {
                    setState(() {
                      scoreboard.add({
                        'username': roomdata['players'][i]['nickname'],
                        'points': roomdata['players'][i]['points'].toString()
                      });
                    }),
                  }
              });
    });

    socket.on('points', (point) {
      if (point['details'] != null) {
        setState(() {
          points.add(touchpoints(
              points: Offset((point['details']['dx']).toDouble(),
                  (point['details']['dy']).toDouble()),
              paint: Paint()
                ..strokeCap = stroketype
                ..isAntiAlias = true
                ..color = selectedcolor.withOpacity(opacity)
                ..strokeWidth = strokewidth));
        });
      }
    });

    socket.on('change-color', (color) {
      int value = int.parse(color, radix: 16);
      Color othercolor = Color(value);
      print('yoooooooooo');

      setState(() {
        selectedcolor = othercolor;
        print('selectedcolor ${selectedcolor}');
      });
    });

    socket.on('changestrokewidth', (value) {
      print('helllooooooooooooo');
      setState(() {
        strokewidth = value.toDouble();
      });
    });
    socket.onConnectError((data) {
      print("conneect error: ${data}");
    });

    socket.onError((data) {
      print("helll ${data}");
    });

    // socket.on("message", (data) {
    //   print(data);
    // });
    socket.on('mesg', (msgdata) {
      setState(() {
        messages.add(msgdata);
        guessseduserctr = msgdata['guesseduserctr'];
        // print(msgdata);
      });

      if (guessseduserctr == dataofroom['players'].length - 1) {
        socket.emit('change-turn', dataofroom['name']);
      }
      scrollcontroller.animateTo(scrollcontroller.position.maxScrollExtent + 25,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });

    socket.on(
        'updatescore',
        (roomdata) => {
              scoreboard.clear(),
              for (int i = 0; i < roomdata['players'].length; i++)
                {
                  scoreboard.add({
                    'username': roomdata['players'][i]['nickname'],
                    'points': roomdata['players'][i]['points'].toString()
                  })
                }
            });
    socket.on(
        'closeinput',
        (_) => {
              socket.emit('updatescore', widget.data['name']),
              setState(() {
                inputreadonly = true;
              })
            });
    socket.on('change-turn', (data) {
      String oldword = dataofroom['word'];
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 4), () {
              setState(() {
                dataofroom = data;
                rendertextblank(dataofroom['word']);
                inputreadonly = false;
                guessseduserctr = 0;
                points.clear();
                start = 60;
              });
              Navigator.of(context).pop();
              timer.cancel();
              starttimer();
            });
            return AlertDialog(
              title: Center(
                child: Text('word was $oldword'),
              ),
            );
          });
    });

    socket.on(
        'clear-screen',
        (data) => {
              print('clear screen!'),
              setState(() {
                points.clear();
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    void selectcolor() {
      // print('onside selectcolor');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("choose color"),
                content: SingleChildScrollView(
                  child: BlockPicker(
                      pickerColor: selectedcolor,
                      onColorChanged: (color) {
                        String colorstring = color.toString();
                        String valuestring =
                            colorstring.split('(0x')[1].split(')')[0];
                        // print(colorstring);
                        // print(valuestring);
                        Map map = {
                          'color': valuestring,
                          'roomname': dataofroom['name']
                        };

                        setState(() {
                          selectedcolor = color;
                        });
                        // socket.emit('color-change', map);
                      }),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok'))
                ],
              ));
    }

    Map<String, dynamic> map;
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 3, 45, 79),
      key: scaffoldkey,
      drawer: player_scoreboard(
        userdata: scoreboard,
      ),
      body: dataofroom != null
          ? dataofroom['isjoin'] != true
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            height: height * 0.65,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                socket.emit('paint', {
                                  'details': {
                                    'dx': details.localPosition.dx,
                                    'dy': details.localPosition.dy,
                                  },
                                  'roomname': widget.data['name']
                                });
                              },
                              onPanStart: (details) {
                                socket.emit('paint', {
                                  'details': {
                                    'dx': details.localPosition.dx,
                                    'dy': details.localPosition.dy,
                                  },
                                  'roomname': widget.data['name']
                                });
                              },
                              onPanEnd: (details) {
                                socket.emit('paint', {
                                  'details': null,
                                  'roomname': widget.data['name']
                                });
                              },
                              child: SizedBox.expand(
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: RepaintBoundary(
                                      child: CustomPaint(
                                        size: Size.infinite,
                                        painter:
                                            mycustompainter(pointslist: points),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    selectcolor();
                                  },
                                  icon: Icon(Icons.color_lens)),
                              Expanded(
                                  child: Slider(
                                      min: 1.0,
                                      max: 10,
                                      label: 'strokewidth: ${strokewidth}',
                                      value: strokewidth,
                                      onChanged: ((value) {
                                        Map map = {
                                          'value': value,
                                          'roomname': widget.data['name'],
                                        };
                                        setState(() {
                                          strokewidth = value;
                                        });
                                        // socket.emit('stroke-width', map);
                                      }))),
                              IconButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   points.clear();
                                    // });
                                    Map map = {
                                      'roomname': dataofroom['name'],
                                      'value': ""
                                    };
                                    socket.emit('clr', map);
                                  },
                                  icon: const Icon(Icons.layers_clear))
                            ],
                          ),
                          dataofroom['turn']['nickname'] !=
                                  widget.data['nickname']
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: textblankwidget,
                                )
                              : Center(
                                  child: Text(
                                    dataofroom['word'],
                                    style: const TextStyle(
                                        fontSize: 28, color: Colors.black),
                                  ),
                                ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                                controller: scrollcontroller,
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: ((context, index) {
                                  var msg = messages[index].values;
                                  return ListTile(
                                    title: Text(
                                      msg.elementAt(0),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(msg.elementAt(1),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 15)),
                                  );
                                })),
                          )
                        ],
                      ),
                    ),
                    dataofroom['turn']['nickname'] != widget.data['nickname']
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextField(
                                controller: controller,
                                readOnly: inputreadonly,
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    Map map = {
                                      'username': widget.data['nickname'],
                                      'msg': value.trim(),
                                      'word': dataofroom['word'],
                                      'roomname': dataofroom['name'],
                                      'guesseduserctr': guessseduserctr,
                                      'totaltime': 60,
                                      'timetaken': 60 - start,
                                    }; //since there is no submit button, we'll use this onsubmitted method. so when we click enter this func runs and o/ps the text

                                    socket.emit('msg', map);
                                    controller.clear();
                                  }
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.vertical(),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  filled: true,
                                  fillColor: const Color(0xffF3F3FA),
                                  hintText: 'Guess here',
                                  hintStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                                textInputAction: TextInputAction.done,
                              ),
                            ))
                        : Container(),
                    SafeArea(
                        child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        scaffoldkey.currentState!.openDrawer();
                      },
                    ))
                  ],
                )
              : waitinglobbyscreen(
                  occupancy: dataofroom['occupancy'],
                  noofplayers: dataofroom['players'].length,
                  lobbyname: dataofroom['name'],
                  players: dataofroom['players'],
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(8),
        child: FloatingActionButton(
          onPressed: () {},
          elevation: 7,
          backgroundColor: Colors.black,
          child: Text(
            '$start',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
