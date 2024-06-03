part of 'data_tagihan_bloc.dart';

@immutable
sealed class DataTagihanState {}

final class DataTagihanInitial extends DataTagihanState {}

final class DataTagihanLoading extends DataTagihanState {}

final class DataTagihanSuccess extends DataTagihanState {
  final List<Datum> dataTagihan;
  DataTagihanSuccess(this.dataTagihan);
}

final class DataTagihanFailure extends DataTagihanState {
  final String message;
  DataTagihanFailure(this.message);
}
