import 'package:betty/models/participant.dart';
import 'package:betty/views/participants_ranking/cubit/participants_ranking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipantsRankingScreen extends StatelessWidget {
  const ParticipantsRankingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParticipantsRankingCubit, ParticipantsRankingState>(
      builder: (context, state) {
        if (state is ParticipantsRankingValidState) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Ranking'),
                ),
                body: ListView(
                  children: [
                    DataTable(
                      border: TableBorder.all(),
                      columns: const [
                        DataColumn(
                          label: Text('Participante'),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Puntos'),
                            ),
                          ),
                        ),
                      ],
                      // columnWidths: const {
                      //   0: FlexColumnWidth(),
                      //   1: FractionColumnWidth(0.2),
                      // },
                      rows: [
                        // const TableRow(
                        //     //decoration: BoxDecoration(color: Colors.amberAccent),
                        //     children: [
                        //       Padding(
                        //         padding: EdgeInsets.all(16.0),
                        //         child: Text('Participante'),
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.all(16.0),
                        //         child: Text('Puntos'),
                        //       ),
                        //     ]),
                        for (EParticipant participant in state.participants)
                          DataRow(cells: [
                            DataCell(
                              Text(participant.userName),
                            ),
                            DataCell(
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  participant.points.toString(),
                                ),
                              ),
                            ),
                          ]),
                        // TableRow(children: [
                        //   Padding(
                        //     padding: const EdgeInsets.all(16.0),
                        //     child: Text(participant.userName),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.all(16.0),
                        //     child: Text(
                        //       participant.points.toString(),
                        //       textAlign: TextAlign.end,
                        //     ),
                        //   ),
                        // ]),
                      ],
                    )
                  ],
                ),
              ),
              if (state is ParticipantsRankingLoading)
                Stack(
                  children: const [
                    Opacity(
                      opacity: 0.5,
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
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
