import 'package:flutter/material.dart';

class PageUtil {
  PageUtil._privateConstructor();
  static final PageUtil instance = PageUtil._privateConstructor();

  Future<void> showDoubleBtnDialog(
      BuildContext context, String title, String text, Function confirmFunc, Function cancleFunc) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
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

  Future<void> showSingleBtnDialog(BuildContext context, String title, String text, Function confirmFunc) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
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
