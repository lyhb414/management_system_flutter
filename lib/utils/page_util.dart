import 'package:flutter/material.dart';

class PageUtil {
  PageUtil._privateConstructor();
  static final PageUtil instance = PageUtil._privateConstructor();

  Future<void> showDoubleBtnDialog(
      BuildContext context, String successTitle, String successText, Function confirmFunc, Function cancleFunc) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(successTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(successText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                Navigator.of(context).pop();
                confirmFunc.call();
              },
            ),
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                cancleFunc.call();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showSingleBtnDialog(
      BuildContext context, String successTitle, String successText, Function confirmFunc) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(successTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(successText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                Navigator.of(context).pop();
                confirmFunc.call();
              },
            ),
          ],
        );
      },
    );
  }
}
