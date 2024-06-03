part of 'data_outlet_bloc.dart';

@immutable
sealed class DataOutletState {}

final class DataOutletInitial extends DataOutletState {}

final class DataOutletLoading extends DataOutletState {}

final class DataOutletSuccess extends DataOutletState {
  final List<Datum> dataOutlet;
  DataOutletSuccess(this.dataOutlet);
}

final class DataOutletFailure extends DataOutletState {
  final String message;
  DataOutletFailure(this.message);
}
