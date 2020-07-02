import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modalwindow/dialog_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String number = '9994207469';
  final int PHONE_NUMBER_LENGTH = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(50),
            child: Row(
              children: <Widget>[
                Text(
                  '+7',
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  alignment: Alignment(0, 0),
                  height: 100,
                  width: 100,
                  child: TextFormField(
                    style: TextStyle(fontSize: 16),
                    keyboardType: TextInputType.number,
                    onChanged: setNumber,
                  ),
                )
              ],
            ),
          ),
          RaisedButton(
            onPressed: validatePhoneNumberAndShowCodeDialog,
          ),
        ],
      )),
    );
  }

  void setNumber(String value) {
    number = value;
  }

  bool validatePhoneNumber() {
    if (number.length == PHONE_NUMBER_LENGTH) {
      return true;
    }
    return false;
  }

  void validatePhoneNumberAndShowCodeDialog() {
    if (validatePhoneNumber()) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogPage(
              number: number,
            );
          });
    }
  }
}
