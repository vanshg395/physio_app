import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physio_app/providers/auth.dart';
import 'package:provider/provider.dart';

class DoctorScheduleScreen extends StatefulWidget {
  @override
  _DoctorScheduleScreenState createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {

  List<dynamic> _consults = [];
  bool _isLoading=false;

  var _res;

Future<void> _getConsults() async {
    String url = 'https://fitknees.herokuapp.com/auth/myconsults/';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      },);
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      if (response.statusCode==200)
      {
        _consults=responseBody;
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
    
  }

  Future<void> _approve(String id) async {
    String url = 'https://fitknees.herokuapp.com/auth/approve/';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      },body:{
        'consolId':id,
      });
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      if (response.statusCode==200)
      {
        _consults=responseBody;
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
    
  }
Future<void> _disApprove(String id) async {
    String url = 'https://fitknees.herokuapp.com/auth/disapprove/';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      },body:{
        'consolId':id,
      });
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      if (response.statusCode==200)
      {
        _consults=responseBody;
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
    
  }
  Future<void> _closeCase(String id) async {
    String url = 'https://fitknees.herokuapp.com/auth/close/';
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      },body:{
        'consolId':id,
      });
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      if (response.statusCode==200)
      {
        _consults=responseBody;
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
    
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getConsults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text(
              'Consultations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            _isLoading?CircularProgressIndicator()
            :Flexible(child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (ctx, i) => Column(
                            children: <Widget>[
                              Card(
                                color: Colors.grey[100],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: ListTile(
                                    title: Text(_consults[i]['name']),
                                    subtitle: _consults[i]['doc_approval']?Text('Approved'):Text('Not Approved'),
                                    leading: CircleAvatar(
                                      child: Text(''),
                                    ),
                                    
                                    onTap: (){
                                      _consults[i]['doc_approval']?_settingModalBottomSheet(context,_consults[i]['consul_id']):
                                      _settingModalBottomSheet1(context,_consults[i]['consul_id']);

                                    }
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: _consults.length,
                        
              ),
              )
            
            

          ],

        ),
      ),
    );
  }
}



void _settingModalBottomSheet(context,String id){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
            children: <Widget>[
      new ListTile(
            leading: new Icon(Icons.music_note),
            title: new Text('Approve'),
            onTap:()=>{ _approve(id, context)
            }
          ),
          new ListTile(
            leading: new Icon(Icons.videocam),
            title: new Text('Dis Approve'),
            onTap:()=>{ _disApprove(id, context),}          
          ),
            ],
          ),
          );
      }
    );
}



void _settingModalBottomSheet1(context,String id){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
          return Container(
            child: new Wrap(
            children: <Widget>[
            new ListTile(
            leading: new Icon(Icons.music_note),
            title: new Text('Close Case'),
            onTap: ()=>{_closeCase(id,context),}                   
            ),
            new ListTile(
              leading: new Icon(Icons.videocam),
              title: new Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
              ],
            ),
            );
        }
      );
  }
            
   _approve(String id,context) async {
    String url = 'https://fitknees.herokuapp.com/auth/approve/';
    
    try {
      final response = await http.post(url,body:{
        'consolId':id,
      });
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      if (response.statusCode==200)
      {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }
    
    
  }
 _disApprove(String id,context) async {
    String url = 'https://fitknees.herokuapp.com/auth/disapprove/';
    
    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      },body:{
        'consolId':id,
      });
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      if (response.statusCode==200)
      {
          Navigator.of(context).pop();

      }
    } catch (e) {
      print(e);
    }
    
    
  }
  _closeCase(String id,context) async {
    String url = 'https://fitknees.herokuapp.com/auth/close/';
    
    try {
      final response = await http.post(url, headers: {
        'Authorization': Provider.of<Auth>(context, listen: false).token,
      },body:{
        'consolId':id,
      });
      final responseBody = json.decode(response.body);
      print(responseBody);
      print(response.statusCode);
      if (response.statusCode==200)
      {
        Navigator.of(context).pop();

      }
    } catch (e) {
      print(e);
    }
    
    
  }