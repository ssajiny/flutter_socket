import 'package:flutter/material.dart';

class CustomDialog {
  late String routeName;
  late String title;
  late String content;

  CustomDialog(this.routeName, this.title, this.content);

  Future<void> showMyDialog(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(routeName);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}
