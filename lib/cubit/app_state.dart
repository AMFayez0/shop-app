part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class Appchangemode extends AppState {}
class AppchangemodeError extends AppState {}
