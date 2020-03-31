import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:physio_app/providers/auth.dart';
import 'package:physio_app/videocall/pages/call.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class IntializeVideoCall extends StatefulWidget {
  @override
  _IntializeVideoCallState createState() => _IntializeVideoCallState();
}

class _IntializeVideoCallState extends State<IntializeVideoCall> {
  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
    if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    FlutterRingtonePlayer.playNotification();
  }

    bool video_call = false;
  bool _isLoading = false;
  String channelName = 'test';
  @override
  Future<void> initState() {
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
      backgroundColor: Colors.grey.withOpacity(0.4),
      body: Container(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Doctor is calling you. Please lift the call....",style: TextStyle(
              fontSize:25,color: Colors.white
            ),),
            SizedBox(height:50),
            IconButton(icon: Icon(Icons.phone,color: Colors.white,), 
            iconSize: 40,
            onPressed: () async {
                await Wakelock.enable();
                await _getChannel();
                Vibration.cancel();
                FlutterRingtonePlayer.stop();
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
              },),
            
          ],
        )),
      ),
    );
  }
}
