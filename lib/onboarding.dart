import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mitra_abadi/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      Timer(const Duration(seconds: 5), () {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      });
    } else {
      Timer(const Duration(seconds: 5), () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo1.png',
                width: 200, height: 200, fit: BoxFit.contain),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  double? _latitude;
  double? _longitude;

  Future<void> _requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          AppSetting.currentAddress = 'Mataram';
        });
      }
    } else if (permission == LocationPermission.deniedForever) {
      setState(() {
        AppSetting.currentAddress = 'Mataram';
      });
    } else {
      final position = await _getCurrentPosition();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      await _getAddressFromLatLng();
    }
  }

  Future<Position> _getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(_latitude ?? 0.0, _longitude ?? 0.0);

      Placemark place = placemarks[0];
      setState(() {
        AppSetting.currentAddress = place.subAdministrativeArea!;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get current location'),
        ),
      );
    }
  }
}
