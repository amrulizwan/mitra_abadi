// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mitra_abadi/widget/button.dart';
import 'package:mitra_abadi/widget/form.dart';
import 'package:mitra_abadi/widget/scan.dart';

import '../../../widget/color.dart';
import '../bloc/add_outlet_bloc.dart';

class AddOutletPage extends StatefulWidget {
  const AddOutletPage({super.key});

  @override
  State<AddOutletPage> createState() => _AddOutletPageState();
}

class _AddOutletPageState extends State<AddOutletPage> {
  String initialValue = 'Grosir';
  TextEditingController namaController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  String? typeOutletSelected;
  List<String> typeOutlet = [
    'Grosir',
    'Kios',
    'Lapak',
    'Minimarket',
    'Online',
    'Restaurant',
    'Retail',
    'SM',
    'Supermarket',
    'Warung'
  ];
  File? imageKTP;
  File? imageToko;

  final ImagePicker _picker = ImagePicker();

  Future<void> selectImageFromCamera(String imageType) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        setState(() {
          if (imageType == 'KTP') {
            imageKTP = File(pickedFile.path);
          } else if (imageType == 'Toko') {
            imageToko = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil gambar'),
        ),
      );
    }
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
          child: BlocConsumer<AddOutletBloc, AddOutletState>(
            listener: (context, state) {
              if (state is AddOutletFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }

              if (state is AddOutletSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Outlet berhasil ditambahkan'),
                  ),
                );
                namaController.clear();
                limitController.clear();
                noTelpController.clear();
                imageKTP = null;
                imageToko = null;
                initialValue = 'Grosir';
              }
            },
            builder: (context, state) {
              return Column(
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
                        'Tambah Outlet Baru',
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
                  MyForm(
                    controller: namaController,
                    label: 'Nama Toko',
                  ),
                  MyForm(
                    controller: noTelpController,
                    label: 'Nomor HP',
                  ),
                  ScanCamera(
                    image: imageKTP != null
                        ? imageKTP!
                        : File('/assets/camera.png'),
                    label: 'Foto KTP',
                    onPressed: () => selectImageFromCamera('KTP'),
                    child: imageKTP != null
                        ? const SizedBox()
                        : Image.asset(
                            "assets/camera.png",
                            height: 20,
                            width: 20,
                            fit: BoxFit.contain,
                          ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  ScanCamera(
                    image: imageToko != null
                        ? imageToko!
                        : File('/assets/camera.png'),
                    label: 'Foto Toko',
                    onPressed: () => selectImageFromCamera('Toko'),
                    child: imageToko != null
                        ? const SizedBox()
                        : Image.asset(
                            "assets/camera.png",
                            height: 20,
                            width: 20,
                            fit: BoxFit.contain,
                          ),
                  ),
                  const Text(
                    'Type Outlet',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(MyColor.primary),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  InputDecorator(
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
                      items: typeOutlet.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          initialValue = newValue!;
                          typeOutletSelected = newValue;
                        });
                      },
                    ),
                  ),
                  MyForm(
                    label: 'Pengajuan Limit',
                    controller: limitController,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyButton(
                        text: 'Ajukan',
                        onPressed: () {
                          namaController.text.isNotEmpty &&
                                  noTelpController.text.isNotEmpty &&
                                  imageKTP != null &&
                                  imageToko != null &&
                                  typeOutletSelected != null &&
                                  limitController.text.isNotEmpty
                              ? BlocProvider.of<AddOutletBloc>(context).add(
                                  AddOutletRequested(
                                    nama: namaController.text,
                                    type: typeOutletSelected!,
                                    limit: int.parse(limitController.text),
                                    image_ktp: imageKTP!,
                                    image_toko: imageToko!,
                                    noTelp: noTelpController.text,
                                  ),
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Pastikan semua data sudah terisi!'),
                                  ),
                                );
                        }),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
