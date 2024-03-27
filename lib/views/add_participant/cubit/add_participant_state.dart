part of 'add_participant_cubit.dart';

abstract class AddParticipantState extends Equatable {
  const AddParticipantState();

  @override
  List<Object> get props => [];
}

class AddParticipantInitial extends AddParticipantState {}

class AddParticipantValidState extends AddParticipantState {

  final List<EParticipant> participants;
  const AddParticipantValidState({
    required this.participants,
  });

  @override
  List<Object> get props => [participants];
}

class AddParticipantLoading extends AddParticipantValidState{
  const AddParticipantLoading({required super.participants});
}