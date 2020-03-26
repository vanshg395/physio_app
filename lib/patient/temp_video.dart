import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:physio_app/videocall/pages/call.dart';

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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleCameraAndMic();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: Center(
          child:RaisedButton(child: Text("Start Video Call"),
          onPressed: ()async{
            await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: "FGUw1XWwNchVGnbeI4",
          ),
        ),
      );
          },)
        ),
      ),
      
    );
  }
}