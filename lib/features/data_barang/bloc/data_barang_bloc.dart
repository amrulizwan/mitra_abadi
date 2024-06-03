import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/data_barang.dart';

import '../../../setting.dart';
part 'data_barang_event.dart';
part 'data_barang_state.dart';

class DataBarangBloc extends Bloc<DataBarangEvent, DataBarangState> {
  DataBarangBloc() : super(DataBarangInitial()) {
    on<DataBarangEvent>((event, emit) async {
      if (event is GetDataBarang) {
        emit(DataBarangLoading());
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          final baseUrl = AppSetting.baseUrl;
          final response = await http.get(Uri.parse('$baseUrl/stock'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
              });
          print(response.body);
          print(response.statusCode);
          if (response.statusCode != 200) {
            emit(DataBarangFailure('Failed to load data'));
            print(response.body);
            print(response.statusCode);
            return;
          }
          final dataBarang = jsonDecode(response.body)
              .map<DataBarang>((json) => DataBarang.fromJson(json))
              .toList();
          emit(DataBarangSuccess(dataBarang));
        } catch (e) {
          emit(DataBarangFailure('Failed to load data'));
          print(e.toString());
        }
      }
    });
  }
}
