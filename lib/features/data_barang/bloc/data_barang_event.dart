part of 'data_barang_bloc.dart';

@immutable
sealed class DataBarangEvent {}

final class GetDataBarang extends DataBarangEvent {}
