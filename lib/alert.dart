import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class friendAlertDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String friend_ip;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Add a new product"),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[

              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'IP address',
                ),
                onSaved: (ip) {
                  friend_ip = ip;
                },
                validator: (value) {
                  if (value.isEmpty ) {
                    return 'Please enter some text';
                  } else if (!isIP(value, 4)) {
                    return 'Please enter a valid IPv4 address';
                  }
                  return null;
                },
              ),


            ],

          ),

        ),
        actions:
        [RaisedButton(onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.pop(context, friend_ip);
          }
        },
          child: Text("Submit"),
        )
        ]
    );
  }
}
