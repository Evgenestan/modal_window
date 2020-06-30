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
  String number;

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
                    // Функции надо давать название, отвечающее на вопрос, что будет делать эта функция
                    // Конкретно тут - setNumber / setCode / setSmsCode
                    // Должно быть понятно по названию, что делает функция, а не приходилось читать весь твой код для этого
                    onChanged: onChanged,
                  ),
                )
              ],
            ),
          ),
          RaisedButton(
            // То же самое, что и выше
            // - validatePhoneNumberAndShowCodeDialog
            onPressed: onPressed,
          ),
        ],
      )),
    );
  }

  void onChanged(String value) {
    number = value;
  }

  void onPressed() {
    // Лучше выполнять какую-то валидацию, а это именно она - в отдельном месте (функции, классе)
    // - validatePhoneNumber
    // Затем, число 10 у тебя - не какая-то абстрактная цифра, а вполне себе единица бизнес-логики, поэтому стоило бы для нее выделить отдельную константу и использовать ее
    // const int PNONE_NUMBER_LENGTH = 10;
    if (number.length == 10) {
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
