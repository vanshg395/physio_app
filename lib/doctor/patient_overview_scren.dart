import 'package:flutter/material.dart';

class PatientOverviewScreen extends StatelessWidget {
  final String name;

  PatientOverviewScreen({@required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.video_call,
              size: 30,
            ),
            onPressed: () {
              // // try {
              // //   await Provider.of<Products>(context,
              // //           listen: false)
              // //       .deleteProduct(id);
              // // } catch (error) {
              // //   scaffold.showSnackBar(
              // //     SnackBar(
              // //       content: Text(
              // //         'Deleting failed!',
              // //         textAlign: TextAlign.center,
              // //       ),
              // //     ),
              // //   );
              // }
            },
            color: Colors.green,
          ),
        ],
      ),
      body: null,
    );
  }
}
