import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/common/widgets/screen_template.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/product_service.dart';
import 'package:flutter_tubes_galon/features/common/controllers/home/order_service.dart';
import 'package:flutter_tubes_galon/utils/constants/sizes.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderService _orderService = OrderService();
  final ProductService _productService = ProductService();
  final UserService _userService = UserService();

  late Future<List<dynamic>> _dataFuture;
  Map<String, dynamic>? _selectedOrder;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<List<dynamic>> _fetchData() async {
    final user = await _userService.getCurrentUser();
    final orders = await _orderService.getOrdersByUserId(user['id']);
    final products = await _productService.getAllProducts();
    return [orders, products, user];
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    setState(() {
      if (_selectedOrder != null && _selectedOrder!['id'] == order['id']) {
        _selectedOrder = null; // Deselect if the same order is tapped again
      } else {
        _selectedOrder = order;
      }
    });
  }

  void _confirmOrderCompletion(
      BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah pesanan sudah selesai?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateOrderStatus(context, order);
                Navigator.of(context).pop();
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  void _updateOrderStatus(
      BuildContext context, Map<String, dynamic> order) async {
    await _orderService.updateOrderStatus(order['id'].toString(), 'Selesai');
    // ScaffoldMessenger.of(context).showSnackBar(
    // SnackBar(content: Text('Status pesanan berhasil diubah menjadi Selesai')),
    // );
    setState(() {
      _dataFuture = _fetchData();
      _selectedOrder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      title: 'Pesanan',
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
              final orders = snapshot.data![0] as List<Map<String, dynamic>>;
              final products = snapshot.data![1] as List<Map<String, dynamic>>;
              final user = snapshot.data![2] as Map<String, dynamic>;

              final filteredOrders = orders
                  .where((order) => order['status'] != 'Selesai')
                  .toList();

              if (filteredOrders.isEmpty) {
                return Center(child: Text('Belum ada pesanan'));
              }

              return Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    final product = products.firstWhere(
                        (p) => p['id'] == order['id_barang'],
                        orElse: () => {'nama_barang': 'Unknown'});

                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              _showOrderDetails(order);
                            },
                            title: Text('${product['nama_barang']}'),
                            subtitle: Text(
                                'Total: ${order['total_transaksi']} \nAlamat: ${user['alamat']}'),
                            trailing: Text('${order['status']}'),
                          ),
                          if (_selectedOrder != null &&
                              _selectedOrder!['id'] == order['id'])
                            Padding(
                              padding:
                                  const EdgeInsets.all(AppSizes.defaultSpace),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Detail Pesanan:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'Barang: ${product['nama_barang']}'),
                                        Text(
                                            'Total: ${order['total_transaksi']}'),
                                        Text('Alamat: ${user['alamat']}'),
                                        Text('Status: ${order['status']}'),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _confirmOrderCompletion(context, order);
                                    },
                                    child: Text('Selesai'),
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
