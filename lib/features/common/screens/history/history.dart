import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/history_service.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<Map<String, dynamic>>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = HistoryService().getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No order history found.'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final product = order['product'];

              return ListTile(
                title: Text(product['nama_barang']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah: ${order['jumlah_barang']}'),
                    Text('Total: ${order['total_transaksi']}'),
                    Text('Status: ${order['status']}'),
                  ],
                ),
                trailing: Text('Harga: ${product['harga_barang']}'),
              );
            },
          );
        },
      ),
    );
  }
}
