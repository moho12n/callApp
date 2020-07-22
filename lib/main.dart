import 'package:call_app/ui/callUI.dart';
import 'package:call_app/ui/pickUpUI.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

TextEditingController textController = TextEditingController();
String callID = "1";
final navigatorKey = GlobalKey<NavigatorState>();
final databaseReference = Firestore.instance;

void main() => runApp(MyApp());

void addCall(String channelId, String callerName,String callerPic) async {
  await databaseReference
      .collection("Calls")
      .add({'channelId': '$channelId', 'callerName': '$callerName','callerPic':'$callerPic'});
}

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
                onPressed: () async {
                  await addCall(callID, "callerName","callerPic");
                  /*navigatorKey.currentState.push(MaterialPageRoute(
                    builder: (context) => CallUI(callID),
                  ));*/
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
