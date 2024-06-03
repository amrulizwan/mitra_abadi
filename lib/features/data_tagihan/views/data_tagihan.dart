import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mitra_abadi/features/data_tagihan/models/data_tagihan.dart';
import 'package:mitra_abadi/widget/rupiah.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/data_tagihan_bloc.dart';

class DataTagihanPage extends StatefulWidget {
  const DataTagihanPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataTagihanPageState createState() => _DataTagihanPageState();
}

class _DataTagihanPageState extends State<DataTagihanPage> {
  late List<Datum> allDataTagihan;
  late List<Datum> displayedData;
  late ScrollController _scrollController;
  final int itemsPerPage = 10;

  String formatTanggal(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMMM, yyyy', 'id_ID');
    return formatter.format(date);
  }

  getKodeSalesman() async {
    final prefs = await SharedPreferences.getInstance();
    kodeSalesman = prefs.getString('kode_salesman');
  }

  String? kodeSalesman;

  @override
  void initState() {
    super.initState();
    allDataTagihan = [];
    displayedData = [];
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    getKodeSalesman().then((kodeSalesman) {
      context.read<DataTagihanBloc>().add(GetDataTagihan());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    final int nextPageIndex = displayedData.length;
    if (nextPageIndex < allDataTagihan.length) {
      setState(() {
        displayedData.addAll(allDataTagihan.getRange(
            nextPageIndex, nextPageIndex + itemsPerPage));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Tagihan'),
      ),
      body: BlocConsumer<DataTagihanBloc, DataTagihanState>(
        listener: (context, state) {
          if (state is DataTagihanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is DataTagihanSuccess) {
            allDataTagihan = state.dataTagihan
                .where((element) => element.kodeSalesman == kodeSalesman)
                .toList();
            displayedData = List.from(allDataTagihan);
            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is DataTagihanLoading && displayedData.isEmpty) {
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
                        displayedData = allDataTagihan
                            .where((data) => data.namaCustomer
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: displayedData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < displayedData.length) {
                        final dataTagihan = displayedData[index];
                        return ListTile(
                          isThreeLine: true,
                          title: Text(
                            dataTagihan.namaCustomer,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Total Nota: ${Rupiah.format(num.parse(dataTagihan.totalNota))}\nSales: ${dataTagihan.namaSalesman}\nLokasi: ${dataTagihan.daerah}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                // ignore: unnecessary_null_comparison
                                dataTagihan.sisaHutang == null
                                    ? '-'
                                    : ' -${Rupiah.format(num.parse(dataTagihan.sisaHutang))}',
                                style: TextStyle(
                                  color: Colors.red[600],
                                ),
                              ),
                              Text(formatTanggal(dataTagihan.tanggal)),
                            ],
                          ),
                        );
                      } else {
                        if (allDataTagihan.length > displayedData.length) {
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
