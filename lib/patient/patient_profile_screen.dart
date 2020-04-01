import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './change_password_screen.dart';
import '../providers/auth.dart';
import '../main.dart';

class PatientProfileScreen extends StatefulWidget {
  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool _isLoading = false;
  bool _isLoading2 = false;
  Map<String, dynamic> _details;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/patient/profile/';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      _details = json.decode(response.body);
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(fontSize: 26),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      _details['name'],
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      _details['email'],
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.monetization_on),
                        ),
                        title: Text('Wallet Balance'),
                        trailing:
                            Text('Rs. ' + _details['wallet_cash'].toString()),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.grey,
                                    ),
                                  ),
                                )
                              : RaisedButton(
                                  color: Colors.grey[350],
                                  textColor: Colors.black,
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'SFProTextSemiMed',
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePasswordScreen(),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: _isLoading2
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.grey,
                                    ),
                                  ),
                                )
                              : RaisedButton(
                                  color: Colors.grey[350],
                                  textColor: Colors.black,
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'SFProTextSemiMed',
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading2 = true;
                                    });
                                    await Provider.of<Auth>(context,
                                            listen: false)
                                        .logout();
                                    setState(() {
                                      _isLoading2 = false;
                                    });
                                    RestartWidget.restartApp(context);
                                  },
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
