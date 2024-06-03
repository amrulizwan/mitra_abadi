import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../setting.dart';
import '../models/data_tagihan.dart';

part 'data_tagihan_event.dart';
part 'data_tagihan_state.dart';

class DataTagihanBloc extends Bloc<DataTagihanEvent, DataTagihanState> {
  DataTagihanBloc() : super(DataTagihanInitial()) {
    on<DataTagihanEvent>((event, emit) async {
      if (event is GetDataTagihan) {
        emit(DataTagihanLoading());
        try {
          final baseUrl = AppSetting.baseUrl;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          final response = await http.get(Uri.parse('$baseUrl/salePiutang'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
              });
          if (response.statusCode != 200) {
            emit(DataTagihanFailure('Failed to load data'));
            return;
          }

          final jsonResponse = jsonDecode(response.body);
          final List<Datum> data = List<Datum>.from(
              jsonResponse['data'].map((x) => Datum.fromJson(x)));

          emit(DataTagihanSuccess(data));
        } catch (e) {
          emit(DataTagihanFailure('Failed to load data'));
        }
      }
    });
  }
}
