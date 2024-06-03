import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_in_event.dart';
part 'check_in_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  CheckInBloc() : super(CheckInInitial()) {
    on<CheckInEvent>((event, emit) {
      // 
    });
  }
}
