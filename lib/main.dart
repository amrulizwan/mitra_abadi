import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mitra_abadi/features/add_outlet/bloc/add_outlet_bloc.dart';
import 'package:mitra_abadi/features/add_outlet/views/outlet.dart';
import 'package:mitra_abadi/features/check_in/views/check_in.dart';
import 'package:mitra_abadi/features/data_barang/bloc/data_barang_bloc.dart';
import 'package:mitra_abadi/features/data_barang/views/data_barang.dart';
import 'package:mitra_abadi/features/data_outlet/bloc/data_outlet_bloc.dart';
import 'package:mitra_abadi/features/order/bloc/order_bloc.dart';
import 'package:mitra_abadi/features/order/views/outlet.dart';
import 'package:mitra_abadi/onboarding.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/views/login.dart';
import 'features/data_tagihan/bloc/data_tagihan_bloc.dart';
import 'features/data_tagihan/views/data_tagihan.dart';
import 'views/home.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => DataBarangBloc()),
        BlocProvider(create: (context) => DataTagihanBloc()),
        BlocProvider(create: (context) => AddOutletBloc()),
        BlocProvider(create: (context) => OrderBloc()),
        BlocProvider(create: (context) => DataOutletBloc()),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/addOutlet': (context) => const AddOutletPage(),
          '/checkInPage': (context) => const CheckInPage(),
          '/dataBarang': (context) => const DataBarangPage(),
          '/dataTagihan': (context) => const DataTagihanPage(),
          '/order': (context) => const OutletSelectionPage(),
        },
        initialRoute: '/',
      ),
    );
  }
}
