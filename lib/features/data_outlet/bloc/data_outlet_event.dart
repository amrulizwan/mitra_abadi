part of 'data_outlet_bloc.dart';

@immutable
sealed class DataOutletEvent {}

class GetDataOutlet extends DataOutletEvent {}

