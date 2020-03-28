import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:physio_app/providers/auth.dart';
import 'package:physio_app/videocall/pages/call.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String title = "Hello User,";
  String helper = "Please wait for the video call";
  bool video_call=false;
  bool _isLoading = false;
  String channelName = 'test';
  @override
  void initState() {
    super.initState();
    _handleCameraAndMic();
    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          video_call=false;
          
          if(title=="Video Call"){
            video_call=true;
          }
        });

      },
      onResume: (message) async{
        setState(() {
          video_call=false;
          if(title=="Video Call"){
            video_call=true;
            title = message["data"]["title"];
            helper = message["notification"]["body"];
            title = message["notification"]["title"];
            helper = message["notification"]["body"];
          }
          
        });

      },

    );
  }


  Future<void> _getChannel() async{
    String url = 'https://fitknees.herokuapp.com/auth/patient/vcall/';

    try {
      final response = await http.get(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      },);
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      final statusCode = response.statusCode;
      if (statusCode==200){
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
          child:!video_call?Container(
            child: Text("Please wait for your doctor's call"),
          ):
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("$helper, Join the video call"),
              _isLoading?RaisedButton(child: Text("Start Video Call"),
              onPressed: ()async{
                setState(() {
                  video_call=false;
                  _isLoading=true;
                });
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CallPage(
                      channelName: channelName,
                    ),
                  ),
              );
              },):CircularProgressIndicator()
            ],
          )
        ),
      ),
      
    );
  }
}