part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeValidState extends HomeState{}

class HomeWithProfile extends HomeValidState{}

class HomeWithoutProfile extends HomeValidState{}

class HomeSignUpFailed extends HomeWithoutProfile{}

class HomeSignUpCancelled extends HomeWithoutProfile{}

class HomeLoading extends HomeValidState{}