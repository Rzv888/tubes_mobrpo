import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<void> updateOrderStatus(String orderId) async {
    await Future.delayed(Duration(seconds: 1));
    print("Order status updated for orderId: $orderId");
  }

  Future<void> insertOrder(String productId, int jumlahBarang,
      int totalTransaksi, BuildContext context) async {
    try {
      final user = await UserService().getCurrentUser();
      await supabase.from('orders').insert({
        'id_barang': productId,
        'id_pemesan': user['id'],
        'jumlah_barang': jumlahBarang,
        'status': 'Dalam Proses',
        'total_transaksi': totalTransaksi
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Berhasil membuat order')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent, content: Text(e.toString())));
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await supabase.from('orders').select();
    if (response.isEmpty) {
      return [];
    }
    return List<Map<String, dynamic>>.from(response);
  }
}
