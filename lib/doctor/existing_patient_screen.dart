import 'package:flutter/material.dart';
import 'package:physio_app/doctor/patient_overview_scren.dart';

class ExistingPatientScreen extends StatefulWidget {
  @override
  _ExistingPatientScreenState createState() => _ExistingPatientScreenState();
}

class _ExistingPatientScreenState extends State<ExistingPatientScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              'Existing Patients',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      title: Text('John Doe'),
                      leading: CircleAvatar(
                        child: Text('JD'),
                      ),
                      trailing: IconButton(
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) =>
                                PatientOverviewScreen(name: 'John Doe'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Divider(),
                Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      title: Text('Vansh Goel'),
                      leading: CircleAvatar(
                        child: Text('VG'),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.video_call,
                          size: 30,
                        ),
                        onPressed: () async {
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
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
