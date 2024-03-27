import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

class SearchEventsScreen extends StatelessWidget {
  SearchEventsScreen({Key? key}) : super(key: key);

  final TextEditingController textController = TextEditingController(text: 'hola');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar eventos'),
        
        actions: [
          AnimSearchBar(
            width: 300, 
            textController: textController,
            rtl: true,
            suffixIcon: const Icon(Icons.search, color: Colors.black,),
            prefixIcon: const Icon(Icons.search, color: Colors.black,),
            onSuffixTap: (){

            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  title: Text('Grupo 1'),
                ),
                ListTile(
                  title: Text('Grupo 2'),
                ),
                ListTile(
                  title: Text('Grupo 3'),
                ),
                ListTile(
                  title: Text('Grupo 4'),
                ),
                ListTile(
                  title: Text('Grupo 5'),
                ),
              ],
            ),
          ),
          const ListTile(
            title: Text('Agregar con código'),
          )
        ],
      ),
    );
  }
}