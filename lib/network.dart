import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';
import 'package:localstorage/localstorage.dart';

import 'databaseHelper.dart';
import 'cat.dart';

part 'network.g.dart'; // this is the destination file for json_serializable code-gen

//Modeled off of Dr Ferrer's socket text chat example
//https://github.com/gjf2a/text_messenger/blob/master/lib/data.dart

const int ourPort = 4444;

class NetworkLog {
  List<Message> _log = [];
  Friends friends = new Friends();
  bool persist;
  final LocalStorage storage = new LocalStorage('CatApp');
  var _message_callback;

  NetworkLog(this._message_callback, {this.persist=true}) {
    this._setupServer();
  }

  Future<int> _addToDatabase(Cat cat) async {
    return DatabaseHelper.instance.insert(cat);
  }

  Future<void> _setupServer() async {
    try {
      ServerSocket server = await ServerSocket.bind(
          InternetAddress.anyIPv4, ourPort,
          shared: true);
      server.listen(_listenToSocket); // StreamSubscription<Socket>
    } on SocketException catch (e) {
      print(e.toString());
    }
  }

  void _listenToSocket(Socket socket) {
    socket.listen((data) {
      _handleIncomingMessage(socket.remoteAddress.address, data);
    });
  }

  Future<void> sendAll(Message message) async {
    _addToDatabase(message.cat);
    for (Friend f in friends) {
      f.send(message);
    }
    await _message_callback();
  }

  void _handleIncomingMessage(String ip, Uint8List incomingData) async {
    String received = String.fromCharCodes(incomingData);
    print("Received '$received' from '$ip'");
    Message m = Message.fromJson(json.decode(received));
    friends.add(ip);
    friends._ips2Friends[ip].online = true;
    print("$_log");
    if (!m.protocol) {
      _log.add(m);
      if (this.persist) await _addToDatabase(m.cat);
    }
    _message_callback();
  }

  List<Message> get log => _log;
}

class Friends extends Iterable<Friend> {
  Map<String, Friend> _ips2Friends = {};

  Future<SocketOutcome> add(String ip) {
    print("adding $ip as friend");
    if (_ips2Friends[ip] == null) {
      print("$ip is a new friend");
      _ips2Friends[ip] = Friend(ip);
      return _ips2Friends[ip].confirmConnection();
    }
    return null;
  }

  Future<SocketOutcome> sendTo(String ip, Message message) async {
    return _ips2Friends[ip].send(message);
  }

  @override
  Iterator<Friend> get iterator => _ips2Friends.values.iterator;
}

//removing names for the moment, just to simplify things. May add them back in, so leaving this as its own class
class Friend {
  String _ipAddr;
  bool online = false;

  Friend(this._ipAddr);

  String toString() {
    return "$ipAddr online<$online>";
  }

  Future<SocketOutcome> confirmConnection() async {
    return send(Message(cat: null, protocol: true));
  }

  Future<SocketOutcome> send(Message message) async {
    try {
      Socket socket = await Socket.connect(_ipAddr, ourPort);
      socket.write(message);
      socket.close();
      print("seems to have sent fine");
      online = true;
      return SocketOutcome();
    } on SocketException catch (e) {
      online = false;
      return SocketOutcome(errorMsg: e.toString());
    }
  }

  String get ipAddr => _ipAddr;
}

@JsonSerializable()
class Message {
  final Cat cat;
  //If true, this should not be displayed to users and is just for connection checking
  final bool protocol;

  Message({this.cat, this.protocol = false});

  String toString() {
    return json.encode(this);
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

class SocketOutcome {
  String _errorMessage;

  SocketOutcome({String errorMsg = ""}) {
    _errorMessage = errorMsg;
  }

  bool get sent => _errorMessage.length == 0;

  String get errorMessage => _errorMessage;

  String toString() {
    return "successful $sent. error [$errorMessage]";
  }
}
