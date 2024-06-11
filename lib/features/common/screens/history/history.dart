import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/common/widgets/screen_template.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/product_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/history_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/order_service.dart';
import 'package:flutter_tubes_galon/features/common/screens/order/order.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  final ProductService _productService = ProductService();
  final UserService _userService = UserService();

  late Future<List<dynamic>> _dataFuture;
  Map<String, dynamic>? _selectedHistory;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<List<dynamic>> _fetchData() async {
    final user = await _userService.getCurrentUser();
    final historys = await _historyService.getHistory();
    final products = await _productService.getAllProducts();
    return [historys, products, user];
  }

  void _showHistoryDetails(Map<String, dynamic> history) {
    setState(() {
      if (_selectedHistory != null &&
          _selectedHistory!['id'] == history['id']) {
        _selectedHistory = null;
      } else {
        _selectedHistory = history;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: 'Riwayat Pesanan',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: FutureBuilder<List<dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data![0].isEmpty) {
              return Center(child: Text('Belum ada pesanan'));
            } else {
              final historys = snapshot.data![0] as List<Map<String, dynamic>>;
              final products = snapshot.data![1] as List<Map<String, dynamic>>;

              final filteredHistorys = historys;

              if (filteredHistorys.isEmpty) {
                return Center(child: Text('Belum ada pesanan'));
              }

              return Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: filteredHistorys.length,
                  itemBuilder: (context, index) {
                    final history = filteredHistorys[index];
                    final product = products.firstWhere(
                        (p) => p['id'] == history['id_barang'],
                        orElse: () => {
                              'nama_barang': 'Unknown',
                              'image': 'https://via.placeholder.com/150'
                            });

                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              _showHistoryDetails(history);
                            },
                            leading: Icon(Icons.water),
                            title: Text('${product['nama_barang']}'),
                            subtitle: Text(
                                'Total: ${history['jumlah_barang'] * history['total_transaksi']}'),
                            trailing: Text(
                                '${DateFormat('d MMMM y - HH:mm').format(DateTime.parse(history['created_at']))}'),
                          ),
                          if (_selectedHistory != null &&
                              _selectedHistory!['id'] == history['id'])
                            Padding(
                              padding:
                                  const EdgeInsets.all(AppSizes.defaultSpace),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Detail Pesanan:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Barang: ${product['nama_barang']}'),
                                  Text('Jumlah: ${history['jumlah_barang']}'),
                                  Text(
                                      'Total: ${history['jumlah_barang'] * history['total_transaksi']}'),
                                  Text(
                                      'Waktu Pemesanan : ${DateFormat('d MMMM y - HH:mm').format(DateTime.parse(history['created_at']))}'),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          OrderService().insertOrder(
                                              history['id_barang'],
                                              history['jumlah_barang'],
                                              history['total_transaksi'],
                                              DateTime.now(),
                                              context);
                                          SnackBar(
                                              content: Text(
                                                  "Order Berhasil Dibuat"));
                                        },
                                        child: Text('Pesan lagi'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
