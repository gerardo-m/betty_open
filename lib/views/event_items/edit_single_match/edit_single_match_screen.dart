import 'package:betty/models/event_item/single_match_item.dart';
import 'package:betty/views/event_items/edit_single_match/cubit/edit_single_match_cubit.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditSingleMatchScreen extends StatelessWidget {
  EditSingleMatchScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final SingleMatchItem singleMatch =
      SingleMatchItem.createEmptySingleMatchItem();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditSingleMatchCubit, EditSingleMatchState>(
      builder: (context, state) {
        if (state is EditSingleMatchValidState) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Partido'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<EditSingleMatchCubit>().save(singleMatch);
                          Navigator.of(context).pop(singleMatch);
                        }
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
                body: SafeArea(
                    minimum: const EdgeInsets.all(24),
                    child: _SingleMatchForm(
                  formKey: _formKey,
                  singleMatch: singleMatch,
                  state: state,
                )),
              ),
              if (state is EditSingleMatchLoading)
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

class _SingleMatchForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final EditSingleMatchValidState state;
  final SingleMatchItem singleMatch;
  const _SingleMatchForm(
      {Key? key,
      required this.formKey,
      required this.state,
      required this.singleMatch})
      : super(key: key);

  @override
  State<_SingleMatchForm> createState() => _SingleMatchFormState();
}

class _SingleMatchFormState extends State<_SingleMatchForm> {

  @override
  void initState() {
    super.initState();
    widget.singleMatch.includeScore = widget.state.eventItem.includeScore;
    widget.singleMatch.includeTieBreaker = widget.state.eventItem.includeTieBreaker;
    widget.singleMatch.includeTieBreakerScore = widget.state.eventItem.includeTieBreakerScore;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 30),
            child: TextFormField(
              initialValue: widget.state.eventItem.team1,
              decoration: const InputDecoration(
                labelText: 'Equipo/Jugador 1',
              ),
              onSaved: (newValue) {
                if (newValue != null) {
                  widget.singleMatch.team1 = newValue;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: TextFormField(
              initialValue: widget.state.eventItem.team2,
              decoration: const InputDecoration(
                labelText: 'Equipo/Jugador 2',
              ),
              onSaved: (newValue) {
                if (newValue != null) {
                  widget.singleMatch.team2 = newValue;
                }
              },
            ),
          ),
          CheckboxListTile(
            value: widget.singleMatch.includeScore,
            onChanged: (value) {
              if (value != null){
                setState(() {
                  widget.singleMatch.includeScore = value;
                });
              }
            },
            title: const Text('Incluir marcadores'),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          ExpandablePanel(
            header: const Text('Mas opciones'),
            collapsed: const Divider(), 
            expanded: Column(
              children: [
                CheckboxListTile(
                  value: widget.singleMatch.includeTieBreaker,
                  onChanged: (value) {
                    if (value != null){
                      setState(() {
                        widget.singleMatch.includeTieBreaker = value;
                      });
                    }
                  },
                  title: const Text('Incluir Desempate'),
                ),
                CheckboxListTile(
                  value: widget.singleMatch.includeTieBreakerScore,
                  onChanged: (value) {
                    if (value != null){
                      setState(() {
                        widget.singleMatch.includeTieBreakerScore = value;
                      });
                    }
                  },
                  title: const Text('Incluir marcadores para desempate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
