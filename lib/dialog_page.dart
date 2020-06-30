import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'dialog.dart' as customDialog;

class DialogPage extends StatefulWidget {
  final number;

  const DialogPage({Key key, this.number}) : super(key: key);

  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  FocusNode focusNode;
  bool hasError = false;
  // timer1 есть, а где тогда timer2, 3, 4??
  // Вообще не стоит использовать числа в названиях чего-либо если они не несут конкретный логический смысл
  Timer timer1;
  // Поздравляю, ты заюзал в языке со статической типизацией динамическую дырку - теперь в твою переменную number можно пихать что-угодно
  // Если ты объявляешь переменную, которая будет изначально null, и затем ты будешь в нее что-то писать - объявляй ее через тип сразу
  // int number / double number
  var number;
  int sendTimer = 59;
  // Тоже самое
  var _code;
  bool _codeSend = false;

  @override
  Widget build(BuildContext context) {
    // Не очень понял, зачем ты это сделал
    // Копия стандартного диалога или из какой-то либы?
    // И почему пришлось что-то в них переписывать?
    return customDialog.Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 340,
        child: FittedBox(
          child: Column(
            children: <Widget>[
              text(),
              codeInput(), //input
              errorText(),
              buttonInput(), //button
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
        child: Container(
          height: 50.0,
          width: 276,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            color: Color(0xFF47a73c),
            disabledColor: Color(0xFFf4f4f4),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: FittedBox(
                child: _codeSend
                    ? Text(
                        // Это жуть, DateFormat надо юзать
                        sendTimer < 10 ? 'Отправить ещё раз через 00:0$sendTimer' : 'Отправить ещё раз через 00:$sendTimer',
                        style: TextStyle(fontSize: 16.0, color: Color(0xFF8c8c8c)),
                      )
                    : Text('Отправить код',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        )),
              ),
            ),
            onPressed: _codeSend ? null : sendCode,
          ),
        ));
  }

  Widget codeInput() {
    void onDone(String value) {
      if (value == _code) {
        print('ok');
        Navigator.pop(context);
      } else {
        setState(() {
          hasError = true;
          focusNode.requestFocus();
        });
      }
    }

    void onChanged(String text) {
      setState(() {
        hasError = false;
      });
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(30, 37, 30, 0),
      child: FittedBox(
        child: PinCodeTextField(
          focusNode: focusNode,
          hasError: hasError,
          maxLength: 6,
          pinBoxHeight: 60,
          pinBoxWidth: 40,
          pinBoxRadius: 8,
          pinBoxBorderWidth: 1,
          autofocus: true,
          hideCharacter: false,
          defaultBorderColor: Color(0xFFd3d3d3),
          hasTextBorderColor: Color(0xFFd3d3d3),
          highlight: true,
          highlightColor: Color(0xFFaeaeae),
          errorBorderColor: Colors.red,
          // Тоже самое
          onDone: onDone,
          // Тоже самое
          onTextChanged: onChanged,
          pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
          pinTextStyle: TextStyle(fontSize: 30.0),
          pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    hasError = false;
    if (timer1 != null) {
      timer1.cancel();
    }
    super.dispose();
  }

  Widget errorText() {
    return Visibility(
        visible: hasError,
        child: Padding(
          padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
          child: Text(
            'Вы ввели неверный код',
            style: TextStyle(color: Colors.red),
          ),
        ));
  }

  @override
  void initState() {
    focusNode = FocusNode();
    number = widget.number;
    sendCode();
    super.initState();
  }

  void sendCode() async {
    void decrement(Timer timer) {
      if (sendTimer == 1) {
        setState(() {
          timer1.cancel();
          sendTimer = 59;
          _codeSend = false;
        });
      } else {
        setState(() {
          sendTimer--;
        });
      }
    }

    if (!_codeSend) {
      _code = '000000'; //getCode();
      setState(() {
        _codeSend = true;
      });

      timer1 = Timer.periodic(Duration(seconds: 1), decrement);
    }
  }

  Widget text() {
    return Padding(
      padding: EdgeInsets.fromLTRB(70, 48, 70, 0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Text(
              'Мы отправили код на номер',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Text(
            // А вот и твой баг, ты можешь быть уверен в этот момент, что твой number - все еще строка?
            // Может это уже число - тогда у него нет таких методов
            // К тому же стоило все же назвать ее хотя бы phoneNumber
            '+7 (${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6, 8)}-${number.substring(8)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          )
        ],
      ),
    );
  }
}
