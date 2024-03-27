import 'package:betty/views/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorMessage(
      BuildContext context, String errorMessage) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.error),
          content: Text(errorMessage),
        );
      },
    );
  }

  Future<void> showSuccessMessage(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.check),
          content: Text(message),
        );
      },
    );
  }

  Future<bool?> showConfirmationMessage(
      BuildContext context, String title, String message,
      {String confirmButtonText = 'Confirmar', String cancelButtonText = 'Cancelar'}) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: title,
          message: message,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
        );
      },
    );
  }

  Future<String?> showGetTextDialog(BuildContext context, String title, {String confirmButtonText = 'Aceptar', String initialValue = ''}) async{
    final TextEditingController controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
          ),
          actions: [
            ElevatedButton(
              child: Text(confirmButtonText),
              onPressed: (){
                String text = controller.value.text;
                Navigator.pop(context, text);
              },
            ),
          ],
        );
      },
    );
  }