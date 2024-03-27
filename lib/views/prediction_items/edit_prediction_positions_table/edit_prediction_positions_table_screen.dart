import 'package:betty/views/prediction_items/edit_prediction_positions_table/cubit/edit_prediction_positions_table_cubit.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPredictionPositionsTableScreen extends StatelessWidget {
  const EditPredictionPositionsTableScreen({Key? key}) : super(key: key);

  final _textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final positionTextStyle = TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary);
    return BlocBuilder<EditPredictionPositionsTableCubit, EditPredictionPositionsTableState>(
      builder: (context, state) {
        if (state is EditPredictionPositionsTableValidState){
          return Scaffold(
            appBar: AppBar(
              title: const Text('Ordena las posiciones'),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<EditPredictionPositionsTableCubit>().save();
                    Navigator.of(context).pop(state.item);
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
            body: ReorderableListView(
              buildDefaultDragHandles: false,
              padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
              onReorder: (oldIndex, newIndex) {
                if (newIndex>oldIndex) newIndex--; // Something wrong with flutter that will never be solved
                context.read<EditPredictionPositionsTableCubit>().reorder(oldIndex, newIndex);
              },
              header: state.item.includePoints ?
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Expanded(child: Text('Equipos/Jugadores')),
                      Text('Puntos'),
                    ],
                  ),
                ) : null,
              children: [
                for (int i = 0; i < state.item.teams.length; i++)
                  Card(
                    key: ValueKey(i),
                    child: ListTile(
                      leading: Text(
                        '${i + 1}',
                        style: positionTextStyle,
                      ),
                      title: Text(
                        state.item.teams[i].team,
                        style: _textStyle,
                      ),
                      trailing: state.item.includePoints ?
                        _PointEditor(value: state.item.teams[i].points, index: i,) :
                        _PositionChanger(index: i,),
                      // trailing: ReorderableDragStartListener(
                      //   index: i,
                      //   child: Icon(Icons.swap_vert)
                      // ),
                    ),
                  ),
                if (state.item.includePoints)
                  Align(
                    key: const ValueKey('last'),
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<EditPredictionPositionsTableCubit>().sort();
                      },
                      child: const Text('Ordenar'),
                    ),
                  ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

class _PointEditor extends StatelessWidget {

  final _textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final int value;
  final int index;
  const _PointEditor({required this.value, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(),
        style: _textStyle,
        textAlign: TextAlign.end,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(''),
          ),
          FilteringTextInputFormatter.allow(
            RegExp(r'\d'),
          )
        ],
        controller: TextEditingController(text: '$value'),
        onChanged: (value) {
          if (value == ''){
            context.read<EditPredictionPositionsTableCubit>().changePoints(index, 0);
            return;
          }
          int? newValue = int.tryParse(value);
          if (newValue != null){
            context.read<EditPredictionPositionsTableCubit>().changePoints(index, newValue);
          }
        },
      ),
    );
  }
}

class _PositionChanger extends StatelessWidget {
  final int index;
  const _PositionChanger({required this.index});

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: const Icon(Icons.swap_vert)
    );
  }
}