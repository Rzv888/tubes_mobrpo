import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await supabase
          .from('orders')
          .update({'status': status}).eq('id', orderId);
      if (response.error != null) {
        throw response.error!;
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  Future<void> insertOrder(String productId, int jumlahBarang,
      int totalTransaksi, DateTime waktuPemesanan, BuildContext context) async {
    try {
      final user = await UserService().getCurrentUser();
      await supabase.from('orders').insert({
        'id_barang': productId,
        'id_pemesan': user['id'],
        'jumlah_barang': jumlahBarang,
        'status': 'Dalam Proses',
        'total_transaksi': totalTransaksi,
        'created_at': waktuPemesanan.toIso8601String()
      });
      UserService().updateSaldo(-1 * totalTransaksi);
      UserService().updateXP(10 * jumlahBarang); // nambah xp
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

  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    final response =
        await supabase.from('orders').select().eq('id_pemesan', userId);
    return List<Map<String, dynamic>>.from(response);
  }
}
