import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:physio_app/providers/auth.dart';
import 'package:physio_app/videocall/pages/call.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';

class VideoPatientScreen extends StatefulWidget {
  @override
  _VideoPatientScreenState createState() => _VideoPatientScreenState();
}

class _VideoPatientScreenState extends State<VideoPatientScreen> {
  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  String title = "Hello User,";
  String helper = "Please wait for the video call";
  bool video_call = false;
  bool _isLoading = false;
  String channelName = 'test';
  @override
  void initState() {
    super.initState();
    _handleCameraAndMic();
  }

  Future<void> _getChannel() async {
    String url = 'https://fitknees.herokuapp.com/auth/patient/vcall/';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      final statusCode = response.statusCode;
      if (statusCode == 200) {
        channelName = responseBody[0]['channel'];
        print(channelName);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Doctor will join you to video call. Please join when HE invites you",
                textAlign: TextAlign.center,
              ),
            ),
            RaisedButton(
              child: Text("Join Video Call"),
              onPressed: () async {
                await Wakelock.enable();
                await _getChannel();
                setState(() {
                  video_call = false;
                  _isLoading = true;
                });
                print(channelName);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallPage(
                      channelName: channelName,
                    ),
                  ),
                );
                await Wakelock.disable();
              },
            )
          ],
        )),
      ),
    );
  }
}
