import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/order_bloc.dart';
import '../models/barang.dart';

class CartPage extends StatefulWidget {
  final List<Barang> cart;
  final String kodeOrder;
  final String? idOutlet;
  final String kodeSales;
  final String namaSales;

  const CartPage({
    super.key,
    required this.cart,
    required this.kodeOrder,
    required this.idOutlet,
    required this.kodeSales,
    required this.namaSales,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String kodeSales = "";
  String namaSales = "";
  String kodeOrder = "";
  String? selectedOutlet;
  List<Barang> cart = [];

  String generateOrderKode(String kodeSalesman) {
    final now = DateTime.now();
    final year = now.year;
    final random = Random();
    final nowMinute = now.minute;
    final randomChar = String.fromCharCodes(
        List.generate(7, (index) => random.nextInt(26) + 65));
    return 'MA$year$randomChar$nowMinute$kodeSalesman';
  }

  Future<Map<String, String>> generateDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'kode_salesman': prefs.getString('kode_salesman') ?? '',
      'name': prefs.getString('name') ?? '',
    };
  }

  void checkout(BuildContext context) {
    kodeOrder = generateOrderKode(kodeSales);
    context.read<OrderBloc>().add(PostOrderRequested(
        widget.cart,
        widget.kodeOrder,
        widget.idOutlet!,
        widget.kodeSales,
        widget.namaSales));
  }

  @override
  initState() {
    super.initState();
    generateDetails().then((details) {
      setState(() {
        kodeSales = details['kode_salesman']!;
        namaSales = details['name']!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final barang = widget.cart[index];
                return ListTile(
                    title: Text(barang.namaBarang),
                    subtitle: Text('Jumlah: ${barang.qty}\n'),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Hapus Barang'),
                              content: const Text(
                                  'Apakah anda yakin ingin menghapus barang ini?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.cart.removeAt(index);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ya'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Tidak'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ));
              },
            ),
          ),
          BlocConsumer<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout Berhasil!')),
                );
                Navigator.pushNamed(
                  context,
                  "/home",
                );
              } else if (state is OrderFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        widget.cart.isNotEmpty &&
                                kodeSales.isNotEmpty &&
                                namaSales.isNotEmpty
                            ? checkout(context)
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cart is empty!')),
                              );
                      },
                      child: const Text(
                        'CHECKOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
