import 'package:flutter/material.dart';

showAlertDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Update Complete'),
      content: const Text('You now have the most up to date data!'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pop(); // dismisses only the dialog and returns nothing
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
