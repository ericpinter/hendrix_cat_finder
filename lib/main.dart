import 'dart:ffi';
import 'package:flutter/material.dart';
import 'alert.dart';
import 'cat.dart';
import 'network.dart';
import 'make_post.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:async';
import 'databaseHelper.dart';

void main() => runApp(MaterialApp(
      title: "Hendrix Cat Finder",
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();

  int _selectedCat =
      1; // Default selected cat is first in the list. I did a bit of testing that this doesn't break things when list is length 0, but it deserves more
  Future<NetworkLog> logFuture;
  double initialRatingValue = 3;

  void _getCatInformation(int id) async {
    DatabaseHelper.instance.queryWithName(id).then((value) {
      controllerOne.text = value.name;
      controllerTwo.text = value.location;
      setState(() {
        initialRatingValue = double.parse(value.rating);
      });
    }).catchError((error) {
      print(error);
    });
  }

  void reload() {
    setState(() {});
  }

  void initState() {
    super.initState();
    logFuture = NetworkLog.getLog(reload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hendrix Cat Finder"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: "Create a Post",
              onPressed: promptCatLocation,
            ),
            IconButton(
                icon: const Icon(Icons.account_circle),
                tooltip: "Add a Friend",
                onPressed: promptFriendDialog),
          ],
        ),
        body: FutureBuilder(
          future: logFuture,
          builder: (BuildContext context, AsyncSnapshot<NetworkLog> snapshot) {
            if (snapshot.hasData) {
              var log = snapshot.data;
              return Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1.0),
                          ),
                          child: DropdownButton(
                              value: _selectedCat,
                              items: log.cats
                                  .asMap()
                                  .entries
                                  .map((MapEntry e) => DropdownMenuItem(
                                        value: 1 + e.key,
                                        //TODO handle differences in display list id and db id more gracefully.
                                        child: Text(e.value.name),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCat = value;
                                });
                                _getCatInformation(value);
                              }),
                        ),
                      )),
                  new Container(
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 10.0, right: 10.0),
                    child: new TextField(
                        controller: controllerOne,
                        enabled: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Add new cat with top right button")),
                  ),
                  new Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 10.0, right: 10.0),
                      child: new TextField(
                        controller: controllerTwo,
                        enabled: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                              //changing the outside border doesnt work?
                            ),
                            labelText:
                                "Add new loaction with top right button"),
                      )),
                  new Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: RatingBarIndicator(
                        rating: initialRatingValue,
                        //take away or leave not sure? just for start visuals
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      )),
                  Text("Message Log"),
                  for (Message message in log.log)
                    if (message != null && !message.protocol)
                      message.cat.toWidget(),
                  //probably it would be best to put all the display code in the same place, but at the moment toWidget is doing all the formatting
                  Text("Friend List"),
                  for (Friend f in log.friends)
                    ListTile(title: Text(f.toString()))
                ],
              );
            } else if (snapshot.hasError)
              return Text("Something went wrong");
            else
              return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Future<void> promptCatLocation() async {
    final result = await showDialog(
      context: context,
      builder: (_) => MakePost(),
      barrierDismissible: true,
    );
    if (result != null) {
      print("sending news of cat ${result.toString()}");
      var log = await logFuture;
      log.sendAll(Message(cat: result, protocol: false));
    }
  }

  Future<void> promptFriendDialog() async {
    String ip = await showDialog(
      context: context,
      builder: (_) => friendAlertDialog(),
      barrierDismissible: true,
    );
    if (ip != null) {
      var log = await logFuture;
      SocketOutcome so = await log.friends.add(ip);
      print("outcome" + so.toString());
    }
    reload();
  }
}
