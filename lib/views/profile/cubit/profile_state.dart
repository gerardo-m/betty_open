part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileValidState extends ProfileState {

  final EProfile profile;
  final String errorMessage;
  const ProfileValidState({
    required this.profile,
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [profile, errorMessage];


  ProfileValidState copyWith({
    EProfile? profile,
    String? errorMessage,
  }) {
    return ProfileValidState(
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileNotCreated extends ProfileValidState{
  const ProfileNotCreated({required super.profile, super.errorMessage});

  @override
  ProfileNotCreated copyWith({
    EProfile? profile,
    String? errorMessage,
  }) {
    return ProfileNotCreated(
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileCreated extends ProfileValidState{
  const ProfileCreated({required super.profile, super.errorMessage});

  @override
  ProfileCreated copyWith({
    EProfile? profile,
    String? errorMessage,
  }) {
    return ProfileCreated(
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileLoading extends ProfileValidState{
  const ProfileLoading({required super.profile});
}

class ProfileLinked extends ProfileCreated{
  const ProfileLinked({required super.profile, super.errorMessage});

  @override
  ProfileLinked copyWith({
    EProfile? profile,
    String? errorMessage,
  }) {
    return ProfileLinked(
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}