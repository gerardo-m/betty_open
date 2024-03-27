part of 'edit_single_match_cubit.dart';

abstract class EditSingleMatchState extends Equatable {
  const EditSingleMatchState();

  @override
  List<Object> get props => [];
}

class EditSingleMatchInitial extends EditSingleMatchState {}

class EditSingleMatchValidState extends EditSingleMatchState {

  final ESingleMatchItem eventItem;
  const EditSingleMatchValidState({
    required this.eventItem,
  });

  @override
  List<Object> get props => [eventItem];
}

class EditSingleMatchLoading extends EditSingleMatchValidState{
  const EditSingleMatchLoading({required super.eventItem});
}