import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/auth.dart';

class PatientExerciseScreen extends StatefulWidget {
  @override
  _PatientExerciseScreenState createState() => _PatientExerciseScreenState();
}

class _PatientExerciseScreenState extends State<PatientExerciseScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final id = Provider.of<Auth>(context, listen: false).id;
      print(id);
      print(Provider.of<Auth>(context, listen: false).token);
      String url =
          'https://fitknees.herokuapp.com/auth/excercise/?id=e37a6b92-5018-455a-8bae-3d1f9e587d4f';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      print(response.body);
      print(response.statusCode);
    } catch (e) {
      print('err');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
