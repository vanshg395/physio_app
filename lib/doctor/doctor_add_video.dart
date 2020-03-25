import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class DoctorVideoAdd extends StatefulWidget {
  @override
  _DoctorVideoAddState createState() => _DoctorVideoAddState();
}

class _DoctorVideoAddState extends State<DoctorVideoAdd> {
  TextEditingController _nameC = TextEditingController();
  TextEditingController _noteC = TextEditingController();
  String filePath='';
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submit() async{
    print('started sumbission');
    Map<String, String> headers = { 
      'Authorization': Provider.of<Auth>(context, listen: false).token,
     };
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final apiUrl = '';
    final name = _nameC.text;
    final notes = _noteC.text;
    final multipartRequest = new http.MultipartRequest('POST', Uri.parse(apiUrl));
    multipartRequest.headers.addAll(headers);
    multipartRequest.fields['name']=name;
    multipartRequest.fields['description']=notes;
    multipartRequest.fields['doctor']=Provider.of<Auth>(context, listen: false).id;

    var multipartFile = await MultipartFile.fromPath("package", filePath);
    multipartRequest.files.add(multipartFile);
    var response = await multipartRequest.send();
    print(response.statusCode);
    
    if (response.statusCode == 200) {
      print("Done");
      Navigator.of(context).pop();
    } else {
      print("Upload Failed");
    }
  }

  Future<void> _getVideo() async {
    filePath = await FilePicker.getFilePath(type: FileType.any);
    print(filePath+'   ===> Filepath');
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
                    child: TextField(
                      controller: _nameC,
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
                    child: TextField(
                      maxLines: 3,
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
                    onPressed:(){_getVideo();},
                    child: Text('Add Video'),
                    ),
                  RaisedButton(
                    onPressed:(){_submit();},
                    child: Text('Submit'),
                  ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}