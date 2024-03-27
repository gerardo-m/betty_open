part of 'edit_positions_table_cubit.dart';

abstract class EditPositionsTableState extends Equatable {
  const EditPositionsTableState();

  @override
  List<Object> get props => [];
}

class EditPositionsTableInitial extends EditPositionsTableState {}

class EditPositionsTableValidState extends EditPositionsTableState {

  final EPositionsTableItem item;
  const EditPositionsTableValidState({
    required this.item,
  });

  @override
  List<Object> get props => [item];
}

class EditPositionsTableLoading extends EditPositionsTableValidState{
  const EditPositionsTableLoading({required super.item});
}
