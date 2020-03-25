import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      String url = 'https://fitknees.herokuapp.com/auth/doctor/profile/';

      final response = await http.get(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
        },
      );
      print(response.body);
      print(response.statusCode);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
