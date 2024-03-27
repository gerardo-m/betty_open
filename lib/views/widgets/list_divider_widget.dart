import 'package:flutter/material.dart';

class ListDividerWidget extends StatelessWidget {

  final String label;

  const ListDividerWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: Colors.grey,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(label),
        ),
      ],
    );
  }
}