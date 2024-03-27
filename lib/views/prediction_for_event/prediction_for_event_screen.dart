import 'package:flutter/material.dart';

@Deprecated("""
  Only used in the prototype. Abandoned screen.
""")
class PredictionForEventScreen extends StatelessWidget {
  const PredictionForEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evento 1'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Info del evento'),
            subtitle: Column(
              children:[
                Row(
                  children: const [
                    Expanded(child: Text('Estado')),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Abierto')
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Expanded(child: Text('Participantes')),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('10')
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Expanded(child: Text('Fecha final para predicciones:')),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('2022-10-10')
                    ),
                  ],
                ),
              ]
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          const ListTile(
            title: Text('Resultados'),
            subtitle: Center(
              child: Text('Pendiente'),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),

          const ListTile(
            title: Text('Mi prediccion'),
          ),
          const MatchPredictionWidget(),
          const MatchPredictionWidget(),
          const MatchPredictionWidget(),
          const MatchPredictionWidget(),
          const MatchPredictionWidget(),
          const MatchPredictionWidget(),
          const MatchPredictionWidget(),
        ],
      ),
    );
  }
}

class MatchPredictionWidget extends StatelessWidget{

  const MatchPredictionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: [
          Row(
            children: const[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Equipo 1'))),
              SizedBox(
                width: 30,
                height: 30,
                child: Center(child: Text('0')),
              ),
            ],
          ),
          Row(
            children: const[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Equipo 2'))),
              SizedBox(
                width: 30,
                height: 30,
                child: Center(child: Text('0')),
              ),
            ],
          ),
        ],
      ),
    );
  }

}