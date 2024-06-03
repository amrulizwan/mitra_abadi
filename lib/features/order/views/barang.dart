// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mitra_abadi/features/order/views/cart.dart';
import 'package:mitra_abadi/widget/color.dart';
import 'package:mitra_abadi/widget/rupiah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../../data_barang/bloc/data_barang_bloc.dart';
import '../../data_barang/models/data_barang.dart';
import '../models/barang.dart';

class ItemSelectionPage extends StatefulWidget {
  final String selectedOutlet;

  const ItemSelectionPage({super.key, required this.selectedOutlet});

  @override
  _ItemSelectionPageState createState() => _ItemSelectionPageState();
}

class _ItemSelectionPageState extends State<ItemSelectionPage> {
  late List<DataBarang> allDataBarang;
  late List<DataBarang> displayedData;
  late List<String> dataDivisi;
  late String initialValue;
  String kodeSales = "";
  String namaSales = "";
  String kodeOrder = "";
  List<Barang> cart = [];

  @override
  void initState() {
    super.initState();
    allDataBarang = [];
    displayedData = [];
    dataDivisi = [];
    initialValue = 'ALL DATA';
    generateDetails();
    context.read<DataBarangBloc>().add(GetDataBarang());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: goToCartPage,
          ),
        ],
      ),
      body: BlocConsumer<DataBarangBloc, DataBarangState>(
        listener: (context, state) {
          if (state is DataBarangFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is DataBarangSuccess) {
            allDataBarang = state.dataBarang.map((e) => e).toList();
            dataDivisi =
                allDataBarang.map((item) => item.divisi ?? '').toSet().toList();
            dataDivisi.removeWhere((element) => element == '');
            dataDivisi.sort();
            dataDivisi.insert(0, 'ALL DATA');
            initialValue = dataDivisi[0];
            displayedData = allDataBarang.toList();
          }
        },
        builder: (context, state) {
          if (state is DataBarangLoading && displayedData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search by name...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        displayedData = allDataBarang
                            .where((data) => data.namaBarang
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Select an option'),
                      isExpanded: true,
                      value: initialValue,
                      items: dataDivisi.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          initialValue = newValue!;
                        });
                        initialValue == 'ALL DATA'
                            ? displayedData = allDataBarang
                            : displayedData = allDataBarang
                                .where((data) => data.divisi == newValue)
                                .toList();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < displayedData.length) {
                        final barang = displayedData[index];
                        return ListTile(
                          title: Text(barang.namaBarang),
                          subtitle: Text(
                              'Harga: ${Rupiah.format(num.parse(barang.hargaDalamKota!))}\nDivisi: ${barang.divisi ?? '-'} '),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(MyColor.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () =>
                                showBottomBar(context, barang, cart),
                            child: const Text('+'),
                          ),
                        );
                      } else {
                        if (allDataBarang.length > displayedData.length) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return const Center(child: Text('End of List'));
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  String generateOrderKode(String kodeSalesman) {
    final now = DateTime.now();
    final year = now.year;
    final random = Random();
    final randomDigits = random.nextInt(10000).toString().padLeft(4, '0');
    return 'ORDER$year$randomDigits$kodeSalesman';
  }

  Future<void> generateDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      kodeSales = prefs.getString('kode_salesman') ?? '';
      namaSales = prefs.getString('name') ?? '';
      kodeOrder = generateOrderKode(kodeSales);
    });
  }

  void addToCart(dynamic namaBarang, dynamic hargaDalamKota, dynamic idBarang,
      dynamic qty) {
    setState(() {
      cart.add(
        Barang(
          id: idBarang,
          namaBarang: namaBarang,
          hargaDalamKota: hargaDalamKota,
          qty: qty,
        ),
      );
    });
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cart: cart,
          kodeOrder: kodeOrder,
          idOutlet: widget.selectedOutlet,
          kodeSales: kodeSales,
          namaSales: namaSales,
        ),
      ),
    );
  }

  void showBottomBar(BuildContext context, barang, cart) {
    final TextEditingController packController = TextEditingController();
    final TextEditingController crtController = TextEditingController();
    final TextEditingController pcsController = TextEditingController();
    int pack = 0;
    int crt = 0;
    int pcs = 0;
    packController.text = pack.toString();
    crtController.text = crt.toString();
    pcsController.text = pcs.toString();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'CRT',
                            border: OutlineInputBorder(),
                          ),
                          controller: crtController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Pack',
                            border: OutlineInputBorder(),
                          ),
                          controller: packController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'PCS',
                            border: OutlineInputBorder(),
                          ),
                          controller: pcsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(MyColor.primary),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (cart.contains(barang)) {
                        int newCrt;
                        int newPack;
                        int newPcs;
                        newCrt = int.parse(crtController.text) +
                            int.parse(
                                cart[cart.indexOf(barang)].qty.split(' ')[0]);
                        newPack = int.parse(packController.text) +
                            int.parse(
                                cart[cart.indexOf(barang)].qty.split(' ')[2]);
                        newPcs = int.parse(pcsController.text) +
                            int.parse(
                                cart[cart.indexOf(barang)].qty.split(' ')[4]);
                        final qty = "$newCrt CRT, $newPack PACK, $newPcs PCS";
                        addToCart(
                          barang.namaBarang,
                          num.parse(barang.hargaDalamKota),
                          barang.id,
                          qty,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content:
                                Text('Jumlah barang berhasil ditambahkan!'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        final qty =
                            "${crtController.text} CRT, ${packController.text} PACK, ${pcsController.text} PCS";
                        addToCart(
                          barang.namaBarang,
                          num.parse(barang.hargaDalamKota),
                          barang.id,
                          qty,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Barang berhasil ditambahkan!'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'ADD TO CART',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
