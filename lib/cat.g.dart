// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cat _$CatFromJson(Map<String, dynamic> json) {
  return Cat(
    name: json['name'] as String,
    location: json['location'] as String,
    rating: json['rating'] as String,
  );
}

Map<String, dynamic> _$CatToJson(Cat instance) => <String, dynamic>{
      'name': instance.name,
      'location': instance.location,
      'rating': instance.rating,
    };
