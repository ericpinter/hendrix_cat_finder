import 'package:flutter/material.dart';
import 'cat.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MakePost extends StatefulWidget {
  @override
  _MakePost createState() {
    return _MakePost();
  }
}

class _MakePost extends State<MakePost> {
  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();

  String catName = "";
  String location = "";
  String ratingValue = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Add New Cat Info"),
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
                RaisedButton(
                  textColor: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.pop(
                        context,
                        Cat(
                            name: controllerOne.text,
                            location: controllerTwo.text,
                            rating: ratingValue));
                  },
                  child: Text("Submit"),
                ),
              ]),
        ));
  }
}
