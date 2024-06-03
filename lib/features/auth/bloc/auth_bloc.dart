import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:mitra_abadi/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      final baseUrl = AppSetting.baseUrl;
      if (event is LoginRequested) {
        final email = event.email;
        final password = event.password;
        emit(AuthLoading());
        try {
          final response = await http.post(Uri.parse('$baseUrl/login'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'email': email,
                'password': password,
              }));

          if (response.statusCode == 200) {
            final user = User.fromJson(jsonDecode(response.body));
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt('userId', user.user.id!);
            prefs.setString('token', user.token);
            prefs.setString('name', user.user.name);
            prefs.setString('email', user.user.email);
            prefs.setString('role', user.user.role);
            prefs.setString('kode_salesman', user.user.kodeSalesman ?? '');
            emit(AuthSuccess(user));
          } else {
            emit(AuthFailure('Login failed'));
          }
        } catch (e) {
          emit(AuthFailure(e.toString()));
        }
      }
      if (event is CheckLogin) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId');
        String? token = prefs.getString('token');
        String? name = prefs.getString('name');
        String? email = prefs.getString('email');
        String? role = prefs.getString('role');
        String? kodeSalesman = prefs.getString('kode_salesman');
        if (userId != null &&
            token != null &&
            name != null &&
            email != null &&
            role != null) {
          User user = User(
              token: token,
              user: UserClass(
                id: int.parse(userId),
                name: name,
                email: email,
                role: role,
                kodeSalesman: kodeSalesman,
              ));
          emit(AuthSuccess(user));
        }
      }
      if (event is LogoutRequested) {
        emit(AuthLoading());
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString('token');
          final response = await http.post(
            Uri.parse('$baseUrl/logout'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
          if (response.statusCode == 200) {
            final data = response.body;
            AuthLogout(data);
          } else {
            emit(AuthFailure('Logout failed'));
          }
        } catch (e) {
          emit(AuthFailure(e.toString()));
        }
      }
    });
  }
}
