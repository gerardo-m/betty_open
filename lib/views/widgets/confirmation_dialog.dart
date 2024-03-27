import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key, required this.title, required this.message, required this.confirmButtonText, required this.cancelButtonText}) : super(key: key);

  final String title;
  final String message;

  final String confirmButtonText;
  final String cancelButtonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
          child: Text(confirmButtonText),
          onPressed: (){
            Navigator.pop(context, true);
          },
        ),
        ElevatedButton(
          child: Text(cancelButtonText),
          onPressed: (){
            Navigator.pop(context, false);
          },
        )
      ],
    );
  }
}