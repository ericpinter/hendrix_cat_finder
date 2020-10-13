import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localstorage/localstorage.dart';

import 'databaseHelper.dart';
import 'cat.dart';

class MakePost extends StatefulWidget {
  @override
  _MakePost createState() {
    return _MakePost();
  }
}

void _addToDb(String catName, String catLocation, String catRating) async {
  await DatabaseHelper.instance.insert(
      Cat(catName: catName, catLocation: catLocation, catRating: catRating));
}

class _MakePost extends State<MakePost> {
  final LocalStorage storage = new LocalStorage('CatApp');

  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();

  String catName = "";
  String location = "";
  String ratingValue = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Add a new friend"),
        content: Form(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                    controller: controllerOne,
                    onChanged: (String catName) {
                      catName = catName;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Cat Name")),
                new Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: new TextField(
                      controller: controllerTwo,
                      onChanged: (String location) {
                        location = location;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Location"),
                    )),
                new Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: RatingBar(
                      initialRating: 3,
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
                        ratingValue = rating.toString();
                      },
                    )),
                FlatButton(
                  textColor: Color(0xFF6200EE),
                  onPressed: () {
                    _addToDb(
                        controllerOne.text, controllerTwo.text, ratingValue);
                    Navigator.pop(context, controllerOne.text);
                  },
                  child: Text("POST CAT"),
                ),
              ]),
        ));
  }
}
