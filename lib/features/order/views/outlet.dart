import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mitra_abadi/features/data_outlet/bloc/data_outlet_bloc.dart';

import 'barang.dart';

class OutletSelectionPage extends StatefulWidget {
  const OutletSelectionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OutletSelectionPageState createState() => _OutletSelectionPageState();
}

class _OutletSelectionPageState extends State<OutletSelectionPage> {
  String? selectedOutlet;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<DataOutletBloc>().add(GetDataOutlet());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void selectOutletAndNavigate(String outletId) {
    setState(() {
      selectedOutlet = outletId;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemSelectionPage(selectedOutlet: outletId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Outlet'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search outlets...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<DataOutletBloc, DataOutletState>(
        builder: (context, state) {
          if (state is DataOutletLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DataOutletSuccess) {
            final Set<String> uniqueKodes = {};
            final filteredOutlets = state.dataOutlet.where((outlet) {
              final isUnique = !uniqueKodes.contains(outlet.kode);
              final matchesSearchQuery =
                  outlet.namaCustomer!.toLowerCase().contains(_searchQuery);
              if (isUnique) {
                uniqueKodes.add(outlet.kode ?? '');
              }
              return isUnique && matchesSearchQuery;
            }).toList();

            return ListView.builder(
              itemCount: filteredOutlets.length,
              itemBuilder: (context, index) {
                final outlet = filteredOutlets[index];
                return ListTile(
                  title: Text(outlet.namaCustomer!),
                  onTap: () => selectOutletAndNavigate(outlet.id.toString()),
                );
              },
            );
          } else {
            return const Center(child: Text('Failed to load outlets'));
          }
        },
      ),
    );
  }
}
