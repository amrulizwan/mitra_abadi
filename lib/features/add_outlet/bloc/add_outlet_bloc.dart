import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:mitra_abadi/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'add_outlet_event.dart';
part 'add_outlet_state.dart';

class AddOutletBloc extends Bloc<AddOutletEvent, AddOutletState> {
  AddOutletBloc() : super(AddOutletInitial()) {
    on<AddOutletEvent>((event, emit) async {
      if (event is AddOutletRequested) {
        emit(AddOutletLoading());
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final baseUrl = AppSetting.baseUrl;
          final token = prefs.getString('token');
          final userId = prefs.getInt('userId');
          final requests = http.MultipartRequest(
            'POST',
            Uri.parse('$baseUrl/outlets'),
          );
          requests.headers['Authorization'] = 'Bearer $token';
          requests.fields['user_id'] = userId.toString();
          requests.fields['name'] = event.nama;
          requests.fields['no_telp'] = event.noTelp;
          requests.fields['type'] = event.type;
          requests.fields['limit'] = event.limit.toString();
          requests.files.add(await http.MultipartFile.fromPath(
              'image_ktp', event.image_ktp.path));
          requests.files.add(await http.MultipartFile.fromPath(
              'image_outlet', event.image_toko.path));
          var response = await requests.send();
          print(response.statusCode);
          if (response.statusCode != 200) {
            emit(AddOutletFailure('Failed to add outlet'));
            print(response.stream.bytesToString());
            return;
          }
          emit(AddOutletSuccess(message: 'Success'));
        } catch (e) {
          emit(AddOutletFailure('Failed to add outlet'));
          print(e.toString());
        }
      }
    });
  }
}
