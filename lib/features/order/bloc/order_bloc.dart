import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../setting.dart';
import '../models/barang.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<PostOrderRequested>(_onPostOrderRequested);
  }

  Future<void> _onPostOrderRequested(
      PostOrderRequested event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final baseUrl = AppSetting.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      for (final barang in event.cart) {
        final response = await http.post(
          Uri.parse('$baseUrl/order'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'kode_order': event.kodeOrder,
            'data_otlets_id': event.idOutlet,
            'stocks_id': barang.id,
            'kode_salesman': event.kodeSales,
            'nama_salesman': event.namaSales,
            'nama_barang': barang.namaBarang,
            'harga_dalam_kota': barang.hargaDalamKota,
            'quantity': barang.qty,
          }),
        );
        if (response.statusCode != 200) {
          emit(OrderFailure(
              'Failed to post data for item: ${barang.namaBarang}'));
          return;
        }
      }
      emit(OrderSuccess());
    } catch (e) {
      emit(OrderFailure('Failed to post data'));
    }
  }
}
