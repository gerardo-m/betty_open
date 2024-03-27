import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

class SearchGroupsScreen extends StatelessWidget {
  const SearchGroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar grupos'),
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
      body: ListView(
        children: const [
          ListTile(
            title: Text('Grupo resultado 1'),
          ),
          ListTile(
            title: Text('Grupo resultado 2'),
          ),
          ListTile(
            title: Text('Grupo resultado 3'),
          ),
          ListTile(
            title: Text('Grupo resultado 4'),
          ),
          ListTile(
            title: Text('Grupo resultado 5'),
          ),
        ],
      ),
    );
  }
}