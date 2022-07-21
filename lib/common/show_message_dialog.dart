import 'package:flutter/material.dart';

void showMessageDialog(String message,BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: const Text('提示'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            color: Colors.grey,
            highlightColor: Colors.blue[700],
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("确定"),
          ),
        ],
      );
    },
  );
}