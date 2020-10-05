import 'package:flutter_test/flutter_test.dart';
import 'package:hendrix_cat_finder/network.dart';

void main() {
  test('one', () async {
    Friend self = new Friend("127.0.0.1");
    expect(self.ipAddr, "127.0.0.1");
    NetworkLog nl = new NetworkLog();
    await nl.setup();

    var msg = "Hello!";
    var outcome = await self.send(msg);
    expect(outcome.sent, true);

    //This is a massive copout, realistically I don't see any way to make sure that the message is sent before our expects
    //However, waiting 5 seconds makes it pretty likely
    await Future.delayed(Duration(seconds: 5));

    print(nl.log);
    expect(nl.log.length, 1);

  });
}
