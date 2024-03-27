import 'package:flutter/material.dart';

class SingleMatchScreen extends StatelessWidget {
  const SingleMatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partido'),
      ),
      body: SafeArea(
        child: ListView(
          children: const [
            ListTile(
              title: Text('Team 0'),
              subtitle: Text('Equipo/Jugador 1'),
            ),
            ListTile(
              title: Text('Team 1'),
              subtitle: Text('Equipo/Jugador 2'),
            ),
            CheckboxListTile(
              value: true, 
              onChanged: null,
              title: Text('Incluye marcadores'),
            )
          ],
        )
      ),
    );
  }
}
