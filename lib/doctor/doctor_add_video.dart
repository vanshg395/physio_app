import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:physio_app/helpers/http_exception.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class DoctorVideoAdd extends StatefulWidget {
  @override
  _DoctorVideoAddState createState() => _DoctorVideoAddState();
}

class _DoctorVideoAddState extends State<DoctorVideoAdd> {
  TextEditingController _nameC = TextEditingController();
  TextEditingController _noteC = TextEditingController();
  String filePath = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;

  String file_loc = '';

  Future<void> _submit() async {
    Map<String, String> headers = {
      'Authorization': Provider.of<Auth>(context, listen: false).token,
    };
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final apiUrl = 'https://fitknees.herokuapp.com/auth/upload/video/';
    final name = _nameC.text;
    final notes = _noteC.text;
    if (filePath == '') {
      throw HttpException('Please choose a video');
    }
    final multipartRequest =
        new http.MultipartRequest('POST', Uri.parse(apiUrl));
    multipartRequest.headers.addAll(headers);
    multipartRequest.fields['name'] = name;
    multipartRequest.fields['description'] = notes;
    multipartRequest.fields['doctor'] =
        Provider.of<Auth>(context, listen: false).id;

    var multipartFile = await MultipartFile.fromPath("video", filePath);
    multipartRequest.files.add(multipartFile);
    var response = await multipartRequest.send();

    if (response.statusCode == 201) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getVideo() async {
    filePath = await FilePicker.getFilePath(type: FileType.video);
    setState(() {
      file_loc = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _nameC,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
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
                    ),
                    keyboardType: TextInputType.text,
                    keyboardAppearance: Brightness.light,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    maxLines: 2,
                    controller: _noteC,
                    decoration: InputDecoration(
                      labelText: 'Description',
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
                    ),
                    keyboardType: TextInputType.text,
                    keyboardAppearance: Brightness.light,
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _getVideo();
                  },
                  child: Text('Add Video'),
                ),
                SizedBox(height: 20),
                filePath.isEmpty
                    ? Text("No file selected")
                    : Text("Current File : $file_loc"),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: Text('Submit'),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
