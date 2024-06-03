// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:mitra_abadi/setting.dart';
import 'package:mitra_abadi/widget/color.dart';
import 'package:mitra_abadi/widget/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? name;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? prefs;

  getDataUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs!.getString('name');
    });
  }

  @override
  void initState() {
    getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MITRA ABADI",
          style: TextStyle(
            color: Color(MyColor.primary),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //JUMBROTRON
            Container(
              padding: const EdgeInsets.all(16.0),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(MyColor.primary),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 64.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Selamat Datang!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          name != null ? name! : "Sales!",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "${AppSetting.currentAddress}\n${formatTanggal(DateTime.now())}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            //MENU BARIS PERTAMA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MenuWidget(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/dataBarang",
                      );
                    },
                    title: 'Data Barang',
                    icon: Bootstrap.box_seam,
                  ),
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: MenuWidget(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/dataTagihan",
                      );
                    },
                    title: 'Data Tagihan',
                    icon: Bootstrap.bank,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            //MENU BARIS KEDUA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuWidget(
                  onTap: () {
                    Navigator.pushNamed(context, '/addOutlet');
                  },
                  title: 'Outlet Baru',
                  icon: Bootstrap.shop,
                ),
                MenuWidget(
                  onTap: () {
                    Navigator.pushNamed(context, '/checkInPage');
                  },
                  title: 'Check In',
                  icon: Bootstrap.clipboard2_check,
                ),
                MenuWidget(
                  title: 'Input Tagihan',
                  icon: Bootstrap.receipt,
                ),
                MenuWidget(
                  onTap: () {
                    Navigator.pushNamed(context, '/order');
                  },
                  title: 'Input Orderan',
                  icon: Bootstrap.file_earmark_arrow_down,
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Expanded(
              child: Text(
                'JALUR HARI INI',
                style: TextStyle(
                  color: Color(MyColor.primary),
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 2,
                    )
                  ],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(
              child: Text(
                'JUMLAH OMSET HARI INI',
                style: TextStyle(
                  color: Color(MyColor.primary),
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 2,
                    )
                  ],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(
              child: Text(
                'DAFTAR OUTLET HARI INI',
                style: TextStyle(
                  color: Color(MyColor.primary),
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 2,
                    )
                  ],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatTanggal(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMMM, yyyy', 'id_ID');
    return formatter.format(date);
  }
}
