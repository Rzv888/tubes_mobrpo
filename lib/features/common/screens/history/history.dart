import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/common/widgets/screen_template.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/product_service.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/history_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  final products = ProductService().getAllProducts();
  final user = UserService().getCurrentUser();

  late Future<List<Map<String, dynamic>>> _historysFuture;

  @override
  void initState() {
    super.initState();
    _historysFuture = _historyService.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: 'Riwayat Pesanan',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _historysFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Belum ada pesanan'));
            } else {
              final historys = snapshot.data!;
              final users = snapshot.data!;
              final products = snapshot.data!;
              return Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: historys.length,
                  itemBuilder: (context, index) {
                    final history = historys[index];
                    final user = users[index];
                    final product = products[index];
                    return Card(
                      child: ListTile(
                        title: Text('${product['nama_barang']}'),
                        subtitle: Text('${history['total_transaksi']}' +
                            '${user['alamat']}'),
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
