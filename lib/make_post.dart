import 'package:flutter/material.dart';
import 'post_model.dart';

class MakePost extends StatefulWidget {
  @override
  _MakePost createState() {
    return _MakePost();
  }
}

class _MakePost extends State<MakePost> {
  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();
  TextEditingController controllerThree = TextEditingController();

  String catName = "";
  String location = "";

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
                TextField(
                  controller: controllerTwo,
                  onChanged: (String text) {
                    text = text;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Location"),
                ),
                RaisedButton(
                  onPressed: () {
                    _sendDataBack(context);
                  },
                  child: Text('Submit'),
                )
              ]),
        ));
  }

  void _sendDataBack(BuildContext context) {
    var newPost =
        new Post(catName: controllerOne.text, location: controllerTwo.text);
    Navigator.pop(context, newPost);
  }
}
