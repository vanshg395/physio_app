import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import './router.dart';
class ReConsultationScreen extends StatefulWidget {
  @override
  _ReConsultationScreenState createState() => _ReConsultationScreenState();
}

class _ReConsultationScreenState extends State<ReConsultationScreen> {


  bool _isLoading = false;
  String _fullname = '';
  String _depart = '';
  String _designation='';
  String _hospital = '';
  String _image = '';
  String _docID = '';

  @override
  void initState() {
    super.initState();
    getDoctor();
      }

  Future<void> _startConsultation() async{
    
    try {
      await Provider.of<Auth>(context, listen: false).startConsult();
    } catch (error) {
      print(error);
      String errorMessage;
      errorMessage = error.toString();
      
      showDialog(
        context: context,
        builder: (context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(errorMessage),
                content: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(errorMessage),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        )
      : AlertDialog(
          backgroundColor: Colors.grey,
          title: Text(errorMessage),
          content: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(errorMessage),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
     Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => PatientRouter()),
        );
  }

  Future<void> getDoctor() async{
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/doctor/details/';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      print(response.body);
      final resBody = json.decode(response.body);

      _fullname = resBody['name'];
      _depart = resBody['department'];
      _designation = resBody['designation'];
      _hospital = resBody['hospital'];
      _image=resBody['image'];
      _docID = resBody['docId'];
      try {
      await Provider.of<Auth>(context, listen: false).addDocID(_docID);
    } catch (error) {
      print(error);
    }


    } catch (e) {}
    setState(() {
      _isLoading = false;
    });


}
      
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                // Image.asset(
                //   'logo/doctor.jpeg',
                //   fit: BoxFit.fitHeight,
                // ),

                Text("Name : $_fullname",style: TextStyle(
                  fontSize:20
                ),),

                SizedBox(
                  height: 20,
                ),

                Text("Designation : $_designation",style: TextStyle(
                  fontSize:20
                ),),

                SizedBox(
                  height: 20,
                ),

                Text("Department : $_depart",style: TextStyle(
                  fontSize:20
                ),),

                SizedBox(
                  height: 20,
                ),


                Text("Hospital : $_hospital",style: TextStyle(
                  fontSize:20
                ),),
                SizedBox(
                  height: 20,
                ),
                Text("Doctor Cancelled your consultation please start a new consultation. Your Money will be refunded into your wallet.",style: TextStyle(
                  fontSize:15
                ),),
                RaisedButton(
                  onPressed:(){ _startConsultation();},
                  child: Text(
                    "Start Consultation"
                  ),
                  )

                

              ]
            )
          )
      ),
    );
  }
}



