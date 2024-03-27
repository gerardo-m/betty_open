import 'package:betty/models/prediction_item/prediction_single_match_item.dart';
import 'package:betty/views/prediction_items/edit_prediction_single_match/cubit/edit_prediction_single_match_cubit.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:betty/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class EditPredictionSingleMatchScreen extends StatelessWidget {
  const EditPredictionSingleMatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditPredictionSingleMatchCubit,
        EditPredictionSingleMatchState>(
      builder: (context, state) {
        if (state is EditPredictionSingleMatchValidState) {
          final title = state.predictionItem.includeScore ? 'Introduce el marcador' : 'Elige el ganador';
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  actions: [
                    IconButton(
                      onPressed: () {
                        context.read<EditPredictionSingleMatchCubit>().save();
                        Navigator.of(context).pop(state.predictionItem);
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
                body: state.predictionItem.includeScore
                    ? _SingleMatchBodyIncludingScore(
                        predictionItem: state.predictionItem)
                    : _SingleMatchBodyWithoutScore(predictionItem: state.predictionItem,),
              ),
              if (state is EditPredictionSingleMatchLoading)
                Stack(
                  children: const [
                    Opacity(
                      opacity: 0.5,
                      child: ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Center(child: CircularProgressIndicator(),),
                  ],
                ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class _SingleMatchBodyIncludingScore extends StatelessWidget {
  const _SingleMatchBodyIncludingScore({required this.predictionItem});

  final EPredictionSingleMatchItem predictionItem;
  final _textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final scoreTextStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary);
    final iconColor = MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)){
        return Theme.of(context).disabledColor;
      }else{
        return Theme.of(context).colorScheme.primary;
      }
    });
    return ListView(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 64, bottom: 16, left: 16, right: 16),
          child: Text(predictionItem.team1, style: _textStyle,),
        ),
        SpinBox(
          textStyle: scoreTextStyle,
          incrementIcon: const Icon(Icons.add_circle_rounded, size: 40),
          decrementIcon: const Icon(Icons.remove_circle_rounded, size: 40),
          iconColor: iconColor,
          value: predictionItem.team1Score?.toDouble() ?? 0.0,
          onChanged: (value) {
            context.read<EditPredictionSingleMatchCubit>().changeTeam1Score(value.toInt());
          },
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 64, bottom: 16, left: 16, right: 16),
          child: Text(predictionItem.team2, style: _textStyle,),
        ),
        SpinBox(
          textStyle: scoreTextStyle,
          incrementIcon: const Icon(Icons.add_circle_rounded, size: 40),
          decrementIcon: const Icon(Icons.remove_circle_rounded, size: 40),
          iconColor: iconColor,
          value: predictionItem.team2Score?.toDouble() ?? 0.0,
          onChanged: (value) {
            context.read<EditPredictionSingleMatchCubit>().changeTeam2Score(value.toInt());
          },
        ),
        if (predictionItem.includeTieBreaker && _isDraw(predictionItem))
          _TieBreakerWidget(predictionItem: predictionItem,),
      ],
    );
  }
}

class _SingleMatchBodyWithoutScore extends StatelessWidget {
  const _SingleMatchBodyWithoutScore({required this.predictionItem});

  final EPredictionSingleMatchItem predictionItem;
  final _textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: ListView(
        children: [
          RadioListTile(
            title: Text(predictionItem.team1, style: _textStyle,),
            value: SingleMatchWinner.team1,
            groupValue: predictionItem.winner,
            onChanged: (value) {
              context.read<EditPredictionSingleMatchCubit>().changeWinner(SingleMatchWinner.team1);
            },
          ),
          RadioListTile(
            title: Text('Empate', style: _textStyle,),
            value: SingleMatchWinner.draw,
            groupValue: predictionItem.winner,
            onChanged: (value) {
              context.read<EditPredictionSingleMatchCubit>().changeWinner(SingleMatchWinner.draw);
            },
          ),
          RadioListTile(
            title: Text(predictionItem.team2, style: _textStyle,),
            value: SingleMatchWinner.team2,
            groupValue: predictionItem.winner,
            onChanged: (value) {
              context.read<EditPredictionSingleMatchCubit>().changeWinner(SingleMatchWinner.team2);
            },
          ),
          if (predictionItem.includeTieBreaker && _isDraw(predictionItem))
            _TieBreakerWidget(predictionItem: predictionItem,),
        ],
      ),
    );
  }
}

class _TieBreakerWidget extends StatelessWidget {
  const _TieBreakerWidget({ required this.predictionItem});

  final EPredictionSingleMatchItem predictionItem;
  final _textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final scoreTextStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary);
    final iconColor = MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)){
        return Theme.of(context).disabledColor;
      }else{
        return Theme.of(context).colorScheme.primary;
      }
    });
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ExpandablePanel(
        header: const Text('Desempate'),
        collapsed: const Divider(),
        expanded: Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.only(top: 24.0),
          child: Builder(
            builder: (context) {
              if (predictionItem.includeTieBreakerScore){
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8),
                      child: Text(predictionItem.team1, style: _textStyle,),
                    ),
                    SpinBox(
                      textStyle: scoreTextStyle,
                      incrementIcon: const Icon(Icons.add_circle_rounded, size: 40),
                      decrementIcon: const Icon(Icons.remove_circle_rounded, size: 40),
                      iconColor: iconColor,
                      value: predictionItem.team1TieBreakerScore?.toDouble() ?? 0.0,
                      onChanged: (value) {
                        context.read<EditPredictionSingleMatchCubit>().changeTeam1TieBreakerScore(value.toInt());
                      },
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, top: 16),
                      child: Text(predictionItem.team2, style: _textStyle,),
                    ),
                    SpinBox(
                      textStyle: scoreTextStyle,
                      incrementIcon: const Icon(Icons.add_circle_rounded, size: 40),
                      decrementIcon: const Icon(Icons.remove_circle_rounded, size: 40),
                      iconColor: iconColor,
                      value: predictionItem.team2TieBreakerScore?.toDouble() ?? 0.0,
                      onChanged: (value) {
                        context.read<EditPredictionSingleMatchCubit>().changeTeam2TieBreakerScore(value.toInt());
                      },
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  const Text('Selecciona al ganador del desempate:'),
                  RadioListTile(
                    title: Text(predictionItem.team1, style: _textStyle,),
                    value: SingleMatchWinner.team1,
                    groupValue: predictionItem.tieBreakerWinner,
                    onChanged: (value) {
                      context.read<EditPredictionSingleMatchCubit>().changeTieBreakerWinner(SingleMatchWinner.team1);
                    },
                  ),
                  RadioListTile(
                    title: Text(predictionItem.team2, style: _textStyle,),
                    value: SingleMatchWinner.team2,
                    groupValue: predictionItem.tieBreakerWinner,
                    onChanged: (value) {
                      context.read<EditPredictionSingleMatchCubit>().changeTieBreakerWinner(SingleMatchWinner.team2);
                    },
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

bool _isDraw(EPredictionSingleMatchItem item){
  if (item.includeScore){
    return item.team1Score == item.team2Score;
  }
  return item.winner == SingleMatchWinner.draw;
}