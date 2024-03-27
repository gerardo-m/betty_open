import 'package:betty/utils/routes.dart';
import 'package:flutter/material.dart';

@Deprecated("""
  Used only in prototype. Abandoned screen
""")
class PredictedEventsScreen extends StatelessWidget {
  const PredictedEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis predicciones'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, BettyRoutes.searchEvents);
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Evento 1'),
            onTap: (){
              // Navigator.pushNamed(context, BettyRoutes.predictionForEvent);
            },
          ), 
          ListTile(
            title: const Text('Evento 2'),
            onTap: (){
              // Navigator.pushNamed(context, BettyRoutes.predictionForEvent);
            },
          ),
          ListTile(
            title: const Text('Evento 3'),
            onTap: (){
              // Navigator.pushNamed(context, BettyRoutes.predictionForEvent);
            },
          )
        ],
      ),
    );
  }
}