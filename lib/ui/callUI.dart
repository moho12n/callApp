import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_timer/flutter_timer.dart';


class CallUI extends StatefulWidget {
  final String channel;
  
  CallUI(this.channel);
  @override
  _CallUIState createState() => _CallUIState();
}

class _CallUIState extends State<CallUI> {
  bool _isInChannel = true;
  final _infoStrings = <String>[];
  bool running = false;

  /// remote user list
  final _remoteUsers = List<int>();

  @override
  void initState() {
    super.initState();
    running = true;
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    start(widget.channel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 148,
                    height: 148,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 96,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Chauffeur X",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TikTikTimer(
                    initialDate: DateTime.now(),
                    running: running,
                    backgroundColor: Colors.transparent,
                    timerTextStyle:
                        TextStyle(color: Colors.black, fontSize: 16),
                    isRaised: false,
                    tracetime: (time) {
                      // print(time.getCurrentSecond);
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: InkWell(
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                          onTap: () async {
                            _isInChannel = false;
                            await AgoraRtcEngine.leaveChannel();
                            await AgoraRtcEngine.stopPreview();
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.call_end,
                              color: Colors.white, size: 36)),
                    )),
              ),
            ),
          ),
         
        ],
      ),
    );
  }

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create('8140cf2aea154e89889225eee28b03f8');
  
    AgoraRtcEngine.enableAudio();
    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);

  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _remoteUsers.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        String info = 'userJoined: ' + uid.toString();
        _infoStrings.add(info);
        _remoteUsers.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        String info = 'userOffline: ' + uid.toString();
        _infoStrings.add(info);
        _remoteUsers.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      setState(() {
        String info = 'firstRemoteVideo: ' +
            uid.toString() +
            ' ' +
            width.toString() +
            'x' +
            height.toString();
        _infoStrings.add(info);
      });
    };
  }

  void start(String channel) async {
    await AgoraRtcEngine.startPreview();
    await AgoraRtcEngine.joinChannel(null, channel, null, 0);
  }

  Widget _buildInfoList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    );
  }

  void _toggleChannel() {
    setState(() async {
      if (_isInChannel) {
        _isInChannel = false;
        await AgoraRtcEngine.leaveChannel();
        await AgoraRtcEngine.stopPreview();
      } else {
        _isInChannel = true;
        await AgoraRtcEngine.startPreview();
        await AgoraRtcEngine.joinChannel(null, 'flutter', null, 0);
      }
    });
  }
}
