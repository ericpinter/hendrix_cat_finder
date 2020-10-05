import 'dart:io';

import 'dart:typed_data';

//Modeled off of Dr Ferrer's socket text chat example
//https://github.com/gjf2a/text_messenger/blob/master/lib/data.dart

const int ourPort = 4444;

class NetworkLog {
  List<String> _log = new List();
  Friends friends = new Friends();

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
    friends.add(ip);
    print("$_log");
  }

  List<String> get log => _log;


}

class Friends extends Iterable<String> {
  Map<String,Friend> _ips2Friends = {};

  void add(String ip) {
    _ips2Friends[ip] = Friend(ip);
  }

  Future<SocketOutcome> sendTo(String ip, String message) async {
    return _ips2Friends[ip].send(message);
  }

  @override
  Iterator<String> get iterator => _ips2Friends.keys.iterator;
}
//removing names for the moment, just to simplify things. May add them back in, so leaving this as its own class
class Friend {
  String _ipAddr;

  Friend(this._ipAddr);

  Future<SocketOutcome> send(String message) async {
    try {
      Socket socket = await Socket.connect(_ipAddr, ourPort);
      socket.write(message);
      socket.close();
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMsg: e.message);
    }
  }

  String get ipAddr => _ipAddr;
}

class SocketOutcome {
  String _errorMessage;

  SocketOutcome({String errorMsg = ""}) {
    _errorMessage = errorMsg;
  }

  bool get sent => _errorMessage.length == 0;

  String get errorMessage => _errorMessage;
}