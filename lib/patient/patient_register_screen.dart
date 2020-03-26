import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './router.dart';
import '../providers/auth.dart';

enum Gender { Male, Female }
enum YesNo { Yes, No }
enum BloodPressure { High, Low, No }
enum Frequency { Frequently, Sometimes, Rarely, Never }
enum DailyActivity { Bedridden, Low, Moderate, High, VeryHigh }

class PatientRegisterScreen extends StatefulWidget {
  @override
  _PatientRegisterScreenState createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController dateCtl = TextEditingController();
  Gender _gender;
  YesNo _yesno1;
  YesNo _yesno2;
  YesNo _yesno3;
  YesNo _yesno4;
  YesNo _yesno5;
  YesNo _yesno6;
  YesNo _yesno7;
  Frequency _freq1;
  Frequency _freq2;
  bool _hasSurgeryHappenned = false;
  bool _familyHistory = false;
  BloodPressure _bloodPressure;
  DailyActivity _dailyActivity;
  bool _isLoading = false;
  Map<String, dynamic> _data = {
    'user': '',
    'date_of_birth': '',
    'height': '',
    'weight': '',
    'country_code': '',
    'phone_number': '',
    'occupation': '',
    'report_email': true,
    'gender': '',
    'blood_pressure': '',
    'liver_disease': false,
    'kidney_disease': false,
    'heart_disease': false,
    'diabetes': false,
    'past_surgery': false,
    'past_surgery_desc': '',
    'smoke': '',
    'drink': '',
    'history_osteoporosis': false,
    'history_osteoporosis_desc': '',
    'activity': '',
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(_data);
    setState(() {
      _isLoading = true;
    });
    print(_data);
  
    try {
      String url = 'https://fitknees.herokuapp.com/auth/patient/';

      final response = await http.post(
        url,
        headers: {
          'Authorization': Provider.of<Auth>(context, listen: false).token,
          'content_type': 'application/json',
          "Accept": "application/json",
        },
        body: json.encode(_data)
      );
      final responseBody = response.body;
      print(responseBody);
      print(response.statusCode);
      if(response.statusCode==200){
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>PatientRouter()));
      await Provider.of<Auth>(context, listen: false).changeEntryLevel();
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Registration Form',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    // controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
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
                    keyboardAppearance: Brightness.light,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    onChanged: (_) {
                      _formKey.currentState.validate();
                    },
                    onSaved: (val) {
                      _data['user'] =
                          Provider.of<Auth>(context, listen: false).id;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
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
                    keyboardAppearance: Brightness.light,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    onChanged: (_) {
                      _formKey.currentState.validate();
                    },
                    // onSaved: (val) {
                    //   _authData['email'] = val;
                    // },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: dateCtl,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
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
                    onTap: () async {
                      DateTime date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      dateCtl.text = DateFormat.yMMMMd().format(date);
                      _data['date_of_birth'] =
                          DateFormat('yyyy-MM-dd').format(date);
                      print(_data);
                    },
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // controller: _emailController,
                    decoration: InputDecoration(
                      suffixText: 'cm',
                      labelText: 'Height',
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    keyboardAppearance: Brightness.light,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    onChanged: (_) {
                      _formKey.currentState.validate();
                    },
                    onSaved: (val) {
                      _data['height'] = val;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // controller: _emailController,
                    decoration: InputDecoration(
                      suffixText: 'Kg',
                      labelText: 'Weight',
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    keyboardAppearance: Brightness.light,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    onChanged: (_) {
                      _formKey.currentState.validate();
                    },
                    onSaved: (val) {
                      _data['weight'] = val;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InternationalPhoneNumberInput.withCustomBorder(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                      _data['country_code'] = number.dialCode;
                      _data['phone_number'] = number.phoneNumber;
                    },
                    // isEnabled: true,
                    autoValidate: true,
                    formatInput: true,
                    inputBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Enter your Phone Number',
                    onInputValidated: (_) {},
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    initialCountry2LetterCode: 'IN',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Occupation',
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
                    keyboardAppearance: Brightness.light,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    onChanged: (_) {
                      _formKey.currentState.validate();
                    },
                    onSaved: (val) {
                      _data['occupation'] = val;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // controller: _emailController,
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
                    ),
                    keyboardAppearance: Brightness.light,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == '') {
                        return 'This Field is required.';
                      }
                    },
                    onChanged: (_) {
                      _formKey.currentState.validate();
                    },
                    onSaved: (val) {
                      _data['email'] = val;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: Gender.Male,
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                            _data['gender'] = describeEnum(_gender);
                          });
                        },
                      ),
                      Text('Male'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: Gender.Female,
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                            _data['gender'] = describeEnum(_gender);
                          });
                        },
                      ),
                      Text('Female'),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Do you want your report over email?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.Yes,
                        groupValue: _yesno1,
                        onChanged: (value) {
                          setState(() {
                            _yesno1 = value;
                            _data['report_email'] =
                                describeEnum(_yesno1) == 'Yes';
                          });
                        },
                      ),
                      Text('Yes'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.No,
                        groupValue: _yesno1,
                        onChanged: (value) {
                          setState(() {
                            _yesno1 = value;
                            _data['report_email'] =
                                describeEnum(_yesno1) == 'Yes';
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Do you have any of the following conditions?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Blood Pressure'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: BloodPressure.High,
                        groupValue: _bloodPressure,
                        onChanged: (value) {
                          setState(() {
                            _bloodPressure = value;
                            _data['blood_pressure'] =
                                describeEnum(_bloodPressure);
                          });
                        },
                      ),
                      Text('High'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: BloodPressure.Low,
                        groupValue: _bloodPressure,
                        onChanged: (value) {
                          setState(() {
                            _bloodPressure = value;
                            _data['blood_pressure'] =
                                describeEnum(_bloodPressure);
                          });
                        },
                      ),
                      Text('Low'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: BloodPressure.No,
                        groupValue: _bloodPressure,
                        onChanged: (value) {
                          setState(() {
                            _bloodPressure = value;
                            _data['blood_pressure'] =
                                describeEnum(_bloodPressure);
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  Text('Liver Disease'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.Yes,
                        groupValue: _yesno2,
                        onChanged: (value) {
                          setState(() {
                            _yesno2 = value;
                            _data['liver_disease'] =
                                describeEnum(_yesno2) == 'Yes';
                          });
                        },
                      ),
                      Text('Yes'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.No,
                        groupValue: _yesno2,
                        onChanged: (value) {
                          setState(() {
                            _yesno2 = value;
                            _data['liver_disease'] =
                                describeEnum(_yesno2) == 'Yes';
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  Text('Kidney Disease'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.Yes,
                        groupValue: _yesno3,
                        onChanged: (value) {
                          setState(() {
                            _yesno3 = value;
                            _data['kidney_disease'] =
                                describeEnum(_yesno3) == 'Yes';
                          });
                        },
                      ),
                      Text('Yes'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.No,
                        groupValue: _yesno3,
                        onChanged: (value) {
                          setState(() {
                            _yesno3 = value;
                            _data['kidney_disease'] =
                                describeEnum(_yesno3) == 'Yes';
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  Text('Heart Disease'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.Yes,
                        groupValue: _yesno4,
                        onChanged: (value) {
                          setState(() {
                            _yesno4 = value;
                            _data['heart_disease'] =
                                describeEnum(_yesno4) == 'Yes';
                          });
                        },
                      ),
                      Text('Yes'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.No,
                        groupValue: _yesno4,
                        onChanged: (value) {
                          setState(() {
                            _yesno4 = value;
                            _data['heart_disease'] =
                                describeEnum(_yesno4) == 'Yes';
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  Text('Diabetes'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.Yes,
                        groupValue: _yesno5,
                        onChanged: (value) {
                          setState(() {
                            _yesno5 = value;
                            _data['diabetes'] = describeEnum(_yesno5) == 'Yes';
                          });
                        },
                      ),
                      Text('Yes'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.No,
                        groupValue: _yesno5,
                        onChanged: (value) {
                          setState(() {
                            _yesno5 = value;
                            _data['diabetes'] = describeEnum(_yesno5) == 'Yes';
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Do you have any history of past surgeries or hospitalization related to knee, ankle or back health?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.Yes,
                        groupValue: _yesno6,
                        onChanged: (value) {
                          setState(() {
                            _yesno6 = value;
                            _hasSurgeryHappenned = true;
                            _data['past_surgery'] =
                                describeEnum(_yesno6) == 'Yes';
                          });
                        },
                      ),
                      Text('Yes'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.No,
                        groupValue: _yesno6,
                        onChanged: (value) {
                          setState(() {
                            _yesno6 = value;
                            _hasSurgeryHappenned = false;
                            _data['past_surgery'] =
                                describeEnum(_yesno6) == 'Yes';
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  if (_hasSurgeryHappenned) ...[
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      // controller: _emailController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'If Yes, Please Specify',
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
                      keyboardAppearance: Brightness.light,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == '') {
                          return 'This Field is required.';
                        }
                      },
                      onChanged: (_) {
                        _formKey.currentState.validate();
                      },
                      onSaved: (val) {
                        _data['past_surgery_desc'] = val;
                      },
                    ),
                  ],
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Do you smoke?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: Frequency.Frequently,
                                groupValue: _freq1,
                                onChanged: (value) {
                                  setState(() {
                                    _freq1 = value;
                                    _data['smoke'] = describeEnum(_freq1);
                                  });
                                },
                              ),
                              Text('Frequently'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: Frequency.Rarely,
                                groupValue: _freq1,
                                onChanged: (value) {
                                  setState(() {
                                    _freq1 = value;
                                    _data['smoke'] = describeEnum(_freq1);
                                  });
                                },
                              ),
                              Text('Rarely'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: Frequency.Sometimes,
                                groupValue: _freq1,
                                onChanged: (value) {
                                  setState(() {
                                    _freq1 = value;
                                    _data['smoke'] = describeEnum(_freq1);
                                  });
                                },
                              ),
                              Text('Sometimes'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: Frequency.Never,
                                groupValue: _freq1,
                                onChanged: (value) {
                                  setState(() {
                                    _freq1 = value;
                                    _data['smoke'] = describeEnum(_freq1);
                                  });
                                },
                              ),
                              Text('Never'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Do you drink?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: Frequency.Frequently,
                                groupValue: _freq2,
                                onChanged: (value) {
                                  setState(() {
                                    _freq2 = value;
                                    _data['drink'] = describeEnum(_freq2);
                                  });
                                },
                              ),
                              Text('Frequently'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: Frequency.Rarely,
                                groupValue: _freq2,
                                onChanged: (value) {
                                  setState(() {
                                    _freq2 = value;
                                    _data['drink'] = describeEnum(_freq2);
                                  });
                                },
                              ),
                              Text('Rarely'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: Frequency.Sometimes,
                                groupValue: _freq2,
                                onChanged: (value) {
                                  setState(() {
                                    _freq2 = value;
                                    _data['drink'] = describeEnum(_freq2);
                                  });
                                },
                              ),
                              Text('Sometimes'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: Frequency.Never,
                                groupValue: _freq2,
                                onChanged: (value) {
                                  setState(() {
                                    _freq2 = value;
                                    _data['drink'] = describeEnum(_freq2);
                                  });
                                },
                              ),
                              Text('Never'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Do you have a family history of Osteoarthritis/Osteoporosis?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.Yes,
                        groupValue: _yesno7,
                        onChanged: (value) {
                          setState(() {
                            _yesno7 = value;
                            _familyHistory = true;
                            // _data['gender'] = describeEnum(_gender);
                            _data['history_osteoporosis'] =
                                describeEnum(_yesno7) == 'Yes';
                          });
                        },
                      ),
                      Text('Yes'),
                      SizedBox(
                        width: 20,
                      ),
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: YesNo.No,
                        groupValue: _yesno7,
                        onChanged: (value) {
                          setState(() {
                            _yesno7 = value;
                            _familyHistory = false;
                            _data['history_osteoporosis'] =
                                describeEnum(_yesno7) == 'Yes';
                          });
                        },
                      ),
                      Text('No'),
                    ],
                  ),
                  if (_familyHistory) ...[
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      // controller: _emailController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'If Yes, Please Specify',
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
                      keyboardAppearance: Brightness.light,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == '') {
                          return 'This Field is required.';
                        }
                      },
                      onChanged: (_) {
                        _formKey.currentState.validate();
                      },
                      onSaved: (val) {
                        _data['history_osteoporosis'] = val;
                      },
                    ),
                  ],
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'How much is your daily activity level?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: DailyActivity.Bedridden,
                                groupValue: _dailyActivity,
                                onChanged: (value) {
                                  setState(() {
                                    _dailyActivity = value;
                                    _data['activity'] =
                                        describeEnum(_dailyActivity);
                                  });
                                },
                              ),
                              Text('Bedridden'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: DailyActivity.Moderate,
                                groupValue: _dailyActivity,
                                onChanged: (value) {
                                  setState(() {
                                    _dailyActivity = value;
                                    _data['activity'] =
                                        describeEnum(_dailyActivity);
                                  });
                                },
                              ),
                              Text('Moderate'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: DailyActivity.Low,
                                groupValue: _dailyActivity,
                                onChanged: (value) {
                                  setState(() {
                                    _dailyActivity = value;
                                    _data['activity'] =
                                        describeEnum(_dailyActivity);
                                  });
                                },
                              ),
                              Text('Low'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Color(0xFF06aE71),
                                value: DailyActivity.High,
                                groupValue: _dailyActivity,
                                onChanged: (value) {
                                  setState(() {
                                    _dailyActivity = value;
                                    _data['activity'] =
                                        describeEnum(_dailyActivity);
                                  });
                                },
                              ),
                              Text('High'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        activeColor: Color(0xFF06aE71),
                        value: DailyActivity.VeryHigh,
                        groupValue: _dailyActivity,
                        onChanged: (value) {
                          setState(() {
                            _dailyActivity = value;
                            _data['activity'] = describeEnum(_dailyActivity);
                          });
                        },
                      ),
                      Text('Very High'),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
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
                                'SUBMIT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'SFProTextSemiMed',
                                ),
                              ),
                              onPressed: _submit,
                              // onPressed: () {},
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
