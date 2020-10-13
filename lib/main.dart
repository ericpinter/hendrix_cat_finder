import 'package:flutter/material.dart';
import 'alert.dart';
import 'network.dart';
import 'make_post.dart';
import 'post_design.dart';
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
  List<CatNameList> _dropdownMenuOfCats = [];

  //IS there a list of cat names somewhere????
  int _selectedCat;
  NetworkLog log;
  double initialRatingValue = 3;

  void _getCatInformation(int id) async {
    DatabaseHelper.instance.queryWithName(id).then((value) {
      controllerOne.text = value.catName;
      controllerTwo.text = value.catLocation;
      setState(() {
        initialRatingValue = double.parse(value.catRating);
      });
    }).catchError((error) {
      print(error);
    });
  }

  getDropDownCatValue() {
    List<CatNameList> _dropdownlistofcats = [];
    DatabaseHelper.instance.queryAllRows().then((value) {
      value.forEach((element) {
        _dropdownlistofcats.add(
          CatNameList(element['id'], element['catName'], element["catLocation"],
              element["cartRating"]),
        );
      });
      _dropdownMenuOfCats = _dropdownlistofcats;
      if (_dropdownMenuOfCats.length != 1) {
        print("selectedCat");
      }
    }).catchError((error) {
      print(error);
    });
  }

  void reload() {
    setState(() {});
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDropDownCatValue();
    if (log == null)
      log = new NetworkLog(
          reload); //eventually replace with loading from sharedprefs
    return Scaffold(
      appBar: AppBar(
        title: Text("Hendrix Cat Finder"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            tooltip: "Create a Post",
            onPressed: () {
              makePostCatLocation(context);
            },
          ),
          IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: "Add a Friend",
              onPressed: () {
                promptFriendDialog();
              }),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1.0),
                  ),
                  child: DropdownButton(
                      value: _selectedCat,
                      items: [
                        for (CatNameList cat in _dropdownMenuOfCats)
                          DropdownMenuItem(
                            value: cat.id,
                            child: Text(cat.name),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCat = value;
                        });
                        _getCatInformation(value);
                      }),
                ),
              )),
          // Text(" ${_selectedCat.name}"),
          new Container(
            margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: new TextFormField(
                controller: controllerOne,
                enabled: false,
                onChanged: (String catName) {
                  catName = catName;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Cat Name")),
          ),
          new Container(
              margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              child: new TextField(
                controller: controllerTwo,
                enabled: false,
                onChanged: (String locationName) {
                  locationName = locationName;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Location"),
              )),
          new Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: RatingBar(
                initialRating: initialRatingValue,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              )),
          for (Message message in log.log)
            if (message != null && !message.protocol)
              ListTile(title: Text(message.text)),
          for (Friend f in log.friends) ListTile(title: Text(f.toString()))
        ],
      ),
    );
  }

  void makePostCatLocation(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MakePost(),
        ));
    setState(() {});
  }

  Future<void> promptFriendDialog() async {
    String ip = await showDialog(
      context: context,
      builder: (_) => friendAlertDialog(),
      barrierDismissible: true,
    );
    if (ip != null) {
      SocketOutcome so = await log.friends.add(ip);
      print("outcome" + so.toString());
    }
    reload();
  }
}
