import 'dart:io';

import 'dart:typed_data';

//Modeled off of Dr Ferrer's socket text chat example
//https://github.com/gjf2a/text_messenger/blob/master/lib/data.dart

const int ourPort = 4444;

class NetworkLog {
  List<String> _log = new List();

  Future<void> setup() async {
    await _setupServer();
  }

  Future<void> _setupServer() async {
    try {
      ServerSocket server =
      await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server.listen(_listenToSocket); // StreamSubscription<Socket>
    } on SocketException catch (e) {
      print(e.message);
    }
  }

  void _listenToSocket(Socket socket) {
    socket.listen((data) {
      _handleIncomingMessage(socket.remoteAddress.address, data);
    });
  }

  void _handleIncomingMessage(String ip, Uint8List incomingData) {
    String received = String.fromCharCodes(incomingData);
    print("Received '$received' from '$ip'");
    _log.add(received);
    print("$_log");
  }

  List<String> get log => _log;


}

class Friends extends Iterable<String> {
  Map<String,Friend> _ips2Friends = {};

  void add(String name, String ip) {
    _ips2Friends[ip] = Friend(ip, name);
  }

  Future<SocketOutcome> sendTo(String ip, String message) async {
    return _ips2Friends[ip].send(message);
  }

  void receiveFrom(String ip, String message) {
    print("receiveFrom($ip, $message)");
    if (!_ips2Friends.containsKey(ip)) {
      String newFriend = "Friend${_ips2Friends.length}";
      print("Adding new friend");
      add(newFriend, ip);
      print("added $newFriend!");
    }
    _ips2Friends[ip].receive(message);
  }

  @override
  Iterator<String> get iterator => _ips2Friends.keys.iterator;
}

class Friend {
  String _ipAddr;
  String _name;
  List<Message> _messages;

  Friend(this._ipAddr, this._name) {
    _messages = List();
  }

  void receive(String message) {
    _messages.add(Message(_name, message));
  }

  Future<SocketOutcome> send(String message) async {
    try {
      Socket socket = await Socket.connect(_ipAddr, ourPort);
      socket.write(message);
      socket.close();
      _messages.add(Message("Me", message));
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMsg: e.message);
    }
  }

  String history() => _messages.map((m) => m.transcript).fold("", (message, line) => message + '\n' + line);

  String get ipAddr => _ipAddr;

  String get name => _name;
}

class Message {
  String _content;
  String _author;

  Message(this._author, this._content);

  String get transcript => '$_author: $_content';
}

class SocketOutcome {
  String _errorMessage;

  SocketOutcome({String errorMsg = ""}) {
    _errorMessage = errorMsg;
  }

  bool get sent => _errorMessage.length == 0;

  String get errorMessage => _errorMessage;
}