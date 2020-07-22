import 'package:call_app/ui/callUI.dart';
import 'package:call_app/utils/permissions.dart';
import 'package:flutter/material.dart';

class PickupScreen extends StatelessWidget {
  final String callerPic;
  final String callerName;
  final String channelID;
  PickupScreen(this.callerName, this.callerPic, this.channelID);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: 148,
              height: 148,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 96,
              ),
            ),
            SizedBox(height: 15),
            Text(
              callerName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {},
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    await Permissions.microphonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallUI(channelID),
                            ),
                          )
                        : {};
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
