import 'package:betty/views/event_items/edit_positions_table/cubit/edit_positions_table_cubit.dart';
import 'package:betty/views/widgets/list_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPositionsTableScreen extends StatelessWidget {
  const EditPositionsTableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditPositionsTableCubit, EditPositionsTableState>(
      builder: (context, state) {
        if (state is EditPositionsTableValidState){
          final TextEditingController controller = TextEditingController(text: state.item.name);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tabla de posiciones'),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<EditPositionsTableCubit>().save();
                    Navigator.of(context).pop(state.item);
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async{
                String? teamName = await showGetTextDialog(context, 'Equipo/Jugador');
                if (teamName != null){
                  context.read<EditPositionsTableCubit>().addTeam(teamName);
                }
              },
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Nombre'),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    controller: controller,
                    onChanged: (value) {
                      context.read<EditPositionsTableCubit>().changeName(value);
                    },
                    
                  ),
                  CheckboxListTile(
                    value: state.item.includePoints,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<EditPositionsTableCubit>().changeIncludePoints(value);
                      }
                    },
                    title: const Text('Incluir puntaje:'),
                  ),
                  const ListDividerWidget(label: 'Equipos/Jugadores:'),
                  for (int i = 0; i < state.item.teams.length; i++)
                    ListTile(
                      title: Text(state.item.teams[i]),
                      onTap: () async{
                        String? newName = await showGetTextDialog(context, 'Equipo/Jugador', initialValue: state.item.teams[i]);
                        if (newName != null){
                          context.read<EditPositionsTableCubit>().changeTeam(i, newName);
                        }
                      },
                    ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
