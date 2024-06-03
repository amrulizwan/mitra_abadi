import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../setting.dart';
import '../models/data_outlets.dart';

part 'data_outlet_event.dart';
part 'data_outlet_state.dart';

class DataOutletBloc extends Bloc<DataOutletEvent, DataOutletState> {
  DataOutletBloc() : super(DataOutletInitial()) {
    on<DataOutletEvent>((event, emit) async {
      if (event is GetDataOutlet) {
        emit(DataOutletLoading());
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          final baseUrl = AppSetting.baseUrl;
          final response = await http.get(Uri.parse('$baseUrl/dataOtlet'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
              });
          if (response.statusCode != 200) {
            emit(DataOutletFailure('Failed to load data'));
            return;
          }
          final dataOutlet = List<Datum>.from(jsonDecode(response.body)['data']
              .map((json) => Datum.fromJson(json)));

          emit(DataOutletSuccess(dataOutlet));
        } catch (e) {
          emit(DataOutletFailure('Failed to load data'));
        }
      }
    });
  }
}
