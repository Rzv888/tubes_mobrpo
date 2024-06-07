import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/common/widgets/screen_template.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/auth_service.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/product_service.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/order_service.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderService _orderService = OrderService();
  final products = ProductService().getAllProducts();
  final user = UserService().getCurrentUser();

  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _orderService.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: 'Pesanan',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Belum ada pesanan'));
            } else {
              final orders = snapshot.data!;
              final users = snapshot.data!;
              final products = snapshot.data!;
              return Container(
                height: MediaQuery.of(context).size.height, 
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final user = users[index];
                    final product = products[index];
                    return Card(
                      child: ListTile(
                        title: Text('${product['nama_barang']}'),
                        subtitle: Text('${order['total_transaksi']}' + '${user['alamat']}'),
                        trailing: Text('${order['status']}'),
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
