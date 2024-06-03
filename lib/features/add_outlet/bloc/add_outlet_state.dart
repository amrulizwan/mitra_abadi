part of 'add_outlet_bloc.dart';

@immutable
sealed class AddOutletState {}

final class AddOutletInitial extends AddOutletState {}

final class AddOutletLoading extends AddOutletState {}

final class AddOutletSuccess extends AddOutletState {
  final String message;

  AddOutletSuccess({required this.message});
}

final class AddOutletFailure extends AddOutletState {
  final String message;

  AddOutletFailure(this.message);
}
