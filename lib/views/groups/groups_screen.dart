import 'package:betty/utils/enums.dart';
import 'package:betty/utils/routes.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis grupos'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.add),
            onSelected: (value) {
              switch (value) {
                case GroupAddOptions.create:
                  Navigator.pushNamed(context, BettyRoutes.editGroup);
                  break;
                case GroupAddOptions.search:
                  Navigator.pushNamed(context, BettyRoutes.searchGroups);
                  break;
                default:
              }
            },
            itemBuilder: (context) => <PopupMenuItem>[
              const PopupMenuItem(
                value: GroupAddOptions.create,
                child: Text('Crear nuevo'),
              ),
              const PopupMenuItem(
                value: GroupAddOptions.search,
                child: Text('Buscar'),
              ),
            ]
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Grupos que administro:'),
          ),
          ListTile(
            title: const Text('Grupo 1'),
            onTap: () {
              Navigator.pushNamed(context, BettyRoutes.editGroup);
            },
          ),
          ListTile(
            title: const Text('Grupo 2'),
            onTap: () {
              Navigator.pushNamed(context, BettyRoutes.editGroup);
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Grupos a los que me uni:'),
          ),
          ListTile(
            title: const Text('Grupo 1'),
            onTap: () {
              Navigator.pushNamed(context, BettyRoutes.showGroup);
            },
          ),
          ListTile(
            title: const Text('Grupo 2'),
            onTap: () {
              Navigator.pushNamed(context, BettyRoutes.showGroup);
            },
          ),
          ListTile(
            title: const Text('Grupo 3'),
            onTap: () {
              Navigator.pushNamed(context, BettyRoutes.showGroup);
            },
          ),
          ListTile(
            title: const Text('Grupo 4'),
            onTap: () {
              Navigator.pushNamed(context, BettyRoutes.showGroup);
            },
          ),
        ],
      ),
    );
  }
}