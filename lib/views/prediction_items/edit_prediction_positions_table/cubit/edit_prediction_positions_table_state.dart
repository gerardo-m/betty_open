part of 'edit_prediction_positions_table_cubit.dart';

abstract class EditPredictionPositionsTableState extends Equatable {
  const EditPredictionPositionsTableState();

  @override
  List<Object> get props => [];
}

class EditPredictionPositionsTableInitial extends EditPredictionPositionsTableState {}

class EditPredictionPositionsTableValidState extends EditPredictionPositionsTableState {

  final EPredictionPositionsTableItem item;
  const EditPredictionPositionsTableValidState({
    required this.item,
  });

  @override
  List<Object> get props => [item];
}

class EditPredictionPositionsTableLoading extends EditPredictionPositionsTableValidState{
  const EditPredictionPositionsTableLoading({required super.item});
}