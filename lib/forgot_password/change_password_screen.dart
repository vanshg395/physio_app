import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();

  final String email;
  UpdatePasswordScreen(this.email);
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  TextEditingController _passController = TextEditingController();
  bool _isValidPassword = false;
  bool _isLoading = false;

  Future<void> changePass() async {
    if (_passController.text == '' || _passController.text == null) {
      return;
    }
    setState(() {
      _isLoading = true;
      _isValidPassword = true;
    });
    try {
      String url = 'https://fitknees.herokuapp.com/auth/forgot/pass/';

      final response = await http.post(
        url,
        body: {
          'email': widget.email,
          'password': _passController.text,
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        await showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Success'),
            content: Text('Password has been changed.'),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
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
                errorText: _isValidPassword ? null : 'This field is required.',
              ),
              keyboardAppearance: Brightness.light,
              onChanged: (val) {
                if (val != '') {
                  setState(() {
                    _isValidPassword = true;
                  });
                } else {
                  setState(() {
                    _isValidPassword = false;
                  });
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 40,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
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
                        onPressed: changePass,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
