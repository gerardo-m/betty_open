part of 'edit_event_cubit.dart';

abstract class EditEventState extends Equatable {
  const EditEventState();

  @override
  List<Object> get props => [];
}

class EditEventInitial extends EditEventState {}

class EditEventValidState extends EditEventState {

  final EEvent currentEditingEvent;
  final bool saved;
  const EditEventValidState({
    required this.currentEditingEvent,
    this.saved = true,
  });

  @override
  List<Object> get props => [currentEditingEvent];
}

class EditEventNotSaved extends EditEventValidState{

  final String errorMessage;

  const EditEventNotSaved({required super.currentEditingEvent, required this.errorMessage, super.saved = false});

  @override
  List<Object> get props => [currentEditingEvent, errorMessage];
}

class EditEventSaved extends EditEventValidState{

  final String errorMessage;

  const EditEventSaved({required super.currentEditingEvent, required this.errorMessage});

  @override
  List<Object> get props => [currentEditingEvent, errorMessage];
}

class EditEventPublished extends EditEventValidState{

  final String errorMessage;

  const EditEventPublished({required super.currentEditingEvent, required this.errorMessage});

  @override
  List<Object> get props => [currentEditingEvent, errorMessage];
}

class EditEventLoading extends EditEventValidState{
  const EditEventLoading({required super.currentEditingEvent});
}