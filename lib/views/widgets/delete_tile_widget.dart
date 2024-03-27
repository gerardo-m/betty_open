import 'package:flutter/material.dart';

class DeleteTileWidget extends StatelessWidget {
  const DeleteTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: Theme.of(context).colorScheme.error,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      color: Theme.of(context).colorScheme.errorContainer,
      child: Text('Eliminar', style: textStyle,),
    );
  }
}
