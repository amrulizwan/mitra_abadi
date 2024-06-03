// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mitra_abadi/widget/rupiah.dart';
import '../bloc/data_barang_bloc.dart';
import '../models/data_barang.dart';

class DataBarangPage extends StatefulWidget {
  const DataBarangPage({super.key});

  @override
  _DataBarangPageState createState() => _DataBarangPageState();
}

class _DataBarangPageState extends State<DataBarangPage> {
  late List<DataBarang> allDataBarang;
  late List<DataBarang> displayedData;
  late List<String> dataDivisi;
  late String initialValue;

  @override
  void initState() {
    super.initState();
    allDataBarang = [];
    displayedData = [];
    dataDivisi = [];
    initialValue = 'ALL DATA';

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
        title: const Text('Data Barang'),
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
                      isExpanded: true,
                      hint: const Text('Select an option'),
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
                        final dataBarang = displayedData[index];
                        return ListTile(
                          isThreeLine: true,
                          title: Text(
                            dataBarang.namaBarang,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Harga: ${Rupiah.format(num.parse(dataBarang.hargaDalamKota ?? '0'))}\nStok: ${dataBarang.stock ?? 0}\nJenis: ${dataBarang.jenisBarang ?? '-'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            dataBarang.divisi == null
                                ? '-'
                                : ' ${dataBarang.divisi}',
                            style: TextStyle(
                              color: Colors.green[600],
                            ),
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
}
