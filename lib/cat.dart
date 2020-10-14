import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cat.g.dart';

@JsonSerializable()
class Cat {
  final String name;
  final String location;
  final String rating;

  Cat({this.name, this.location, this.rating});

  Widget toWidget() {
    return ListTile(
        title: Text(name), subtitle: Text("Found at $location, $rating"));
  }

  String toString() {
    return "Cat{$name $location $rating}";
  }

  factory Cat.fromJson(Map<String, dynamic> json) => _$CatFromJson(json);

  Map<String, dynamic> toJson() => _$CatToJson(this);
}
