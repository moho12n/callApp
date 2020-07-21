import 'package:call_app/callUI.dart';
import 'package:flutter/material.dart';

TextEditingController textController = TextEditingController();
String callID = "1";
final navigatorKey = GlobalKey<NavigatorState>();
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Call Id :"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: textController,
                onChanged: (value) {
                  callID = textController.text;
                },
              ),
            ),
            SizedBox(
              height: 48,
            ),
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: FlatButton(
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                onPressed: () {
                  navigatorKey.currentState.push(MaterialPageRoute(
                    builder: (context) => CallUI(),
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
