// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mitra_abadi/widget/button.dart';
import 'package:mitra_abadi/widget/form.dart';

import '../../../widget/color.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  List<String> namaToko = [
    'Toko 1',
    'Toko 2',
    'Toko 3',
    'Toko 4',
    'Toko 5',
  ];

  @override
  Widget build(BuildContext context) {
    String initialValue = namaToko.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MITRA ABADI",
          style: TextStyle(
            color: Color(MyColor.primary),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Color.fromARGB(50, 0, 0, 0),
              ),
            ],
          ),
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(MyColor.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Konfirmasi Kunjungan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Color.fromARGB(83, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Toko',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(MyColor.primary),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: DropdownButton(
                        value: initialValue,
                        hint: const Text('Silahkan pilih nama toko'),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(16),
                        items: namaToko.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                MyForm(
                  maxlines: 5,
                  label: 'Alasan *(Isi jika ada orderan)',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      text: 'Jam Masuk',
                      onPressed: () {},
                    ),
                    MyButton(
                      text: 'Jam Keluar',
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
