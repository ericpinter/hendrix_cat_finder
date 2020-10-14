// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    cat: json['cat'] == null
        ? null
        : Cat.fromJson(json['cat'] as Map<String, dynamic>),
    protocol: json['protocol'] as bool,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'cat': instance.cat,
      'protocol': instance.protocol,
    };
