part of 'participants_ranking_cubit.dart';

abstract class ParticipantsRankingState extends Equatable {
  const ParticipantsRankingState();

  @override
  List<Object> get props => [];
}

class ParticipantsRankingInitial extends ParticipantsRankingState {}

class ParticipantsRankingValidState extends ParticipantsRankingState {

  final List<EParticipant> participants;
  const ParticipantsRankingValidState({
    required this.participants,
  }); 

  @override
  List<Object> get props => [participants];

}

class ParticipantsRankingLoading extends ParticipantsRankingValidState{
  const ParticipantsRankingLoading({required super.participants});
}