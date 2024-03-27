import 'package:flutter/material.dart';

class ShowGroupScreen extends StatelessWidget {
  const ShowGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver grupo'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Grupo 1',
              style: style,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Integrantes:'),
          ),
          const ListTile(
            title: Text('Gerardo Miranda'),
          ),
          const ListTile(
            title: Text('Romina Miranda'),
          ),
          const ListTile(
            title: Text('Juvenal Miranda'),
          ),
          const ListTile(
            title: Text('Cristina Cespedes'),
          ),
        ],
      ),
    );
  }
}