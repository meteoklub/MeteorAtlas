import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  final String title;
  final List<Widget> options;

  MyDialog({required this.title, required this.options});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Column(
        children: widget.options,
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyText1!,
          ),
        ),
      ],
    );
  }
}
