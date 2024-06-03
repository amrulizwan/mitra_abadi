part of 'data_barang_bloc.dart';

sealed class DataBarangState {}

final class DataBarangInitial extends DataBarangState {}

final class DataBarangLoading extends DataBarangState {}

final class DataBarangSuccess extends DataBarangState {
  final List<DataBarang> dataBarang;
  DataBarangSuccess(this.dataBarang);
}

final class DataBarangFailure extends DataBarangState {
  final String message;
  DataBarangFailure(this.message);
}
