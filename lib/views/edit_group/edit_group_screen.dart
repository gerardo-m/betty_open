import 'package:flutter/material.dart';

class EditGroupScreen extends StatelessWidget {
  const EditGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Grupo'),
      ),
      body: ListView(
        children: [
          TextFormField(
            initialValue: 'Grupo 1',
            decoration: const InputDecoration(
              labelText: 'Nombre',
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
