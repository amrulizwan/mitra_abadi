// ignore_for_file: non_constant_identifier_names

part of 'add_outlet_bloc.dart';

@immutable
sealed class AddOutletEvent {}

class AddOutletRequested extends AddOutletEvent {
  final String nama;
  final String noTelp;
  final File image_ktp;
  final File image_toko;
  final String type;
  final int limit;

  AddOutletRequested(
      {required this.nama,
      required this.noTelp,
      required this.image_ktp,
      required this.image_toko,
      required this.type,
      required this.limit});
}
