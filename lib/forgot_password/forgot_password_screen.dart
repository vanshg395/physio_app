import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physio_app/forgot_password/change_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _otpController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isValidOtp = false;
  bool _isValidEmail = false;
  bool _flag = false;
  bool _isLoading = false;
  String _correctOtp;

  Future<void> _submitEmail() async {
    if (_emailController.text == '' || _emailController.text == null) {
      return;
    }
    setState(() {
      _isValidEmail = true;
      _isLoading = true;
    });
    try {
      String url =
          'https://fitknees.herokuapp.com/auth/forgot/pass?email=${_emailController.text}';
      final response = await http.get(url);
      final responseBody = json.decode(response.body);
      if (response.statusCode == 201) {
        _correctOtp = responseBody['otp'];
        print(_correctOtp);
      } else {
        await showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Error'),
            content: Text('Some error occurred.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {}
    setState(() {
      _isLoading = false;
      _flag = true;
    });
  }

  Future<void> _submitOtp() async {
    if (_otpController.text == '' || _otpController.text == null) {
      return;
    }
    setState(() {
      _isValidOtp = true;
    });
    if (_otpController.text == _correctOtp) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => UpdatePasswordScreen(_emailController.text),
        ),
      );
    } else {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Error'),
          content: Text('Invalid Otp'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
      setState(() {
        _otpController.text = '';
      });
    }
  }

  Widget buildOtpCollector() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: _otpController,
            decoration: InputDecoration(
              labelText: 'OTP',
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorText: _isValidOtp ? null : 'This field is required.',
            ),
            keyboardAppearance: Brightness.light,
            onChanged: (val) {
              if (val != '') {
                setState(() {
                  _isValidOtp = true;
                });
              } else {
                setState(() {
                  _isValidOtp = false;
                });
              }
            },
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: RaisedButton(
                color: Colors.grey[350],
                textColor: Colors.black,
                child: Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'SFProTextSemiMed',
                  ),
                ),
                onPressed: _submitOtp,
                // onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailCollector() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorText: _isValidEmail ? null : 'This field is required.',
            ),
            onChanged: (val) {
              if (val != '') {
                setState(() {
                  _isValidEmail = true;
                });
              } else {
                setState(() {
                  _isValidEmail = false;
                });
              }
            },
            keyboardAppearance: Brightness.light,
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 40,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: RaisedButton(
                      color: Colors.grey[350],
                      textColor: Colors.black,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SFProTextSemiMed',
                        ),
                      ),
                      onPressed: _submitEmail,
                      // onPressed: () {},
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: _flag ? buildOtpCollector() : buildEmailCollector(),
    );
  }
}
