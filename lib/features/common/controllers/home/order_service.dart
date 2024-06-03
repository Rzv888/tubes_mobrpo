import 'package:flutter_tubes_galon/features/authentication/controllers/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getOrders() async {
    final id = await AuthService().getUserId();

    List<Map<String, dynamic>> dummyOrders = [
      {
        'id': '1',
        'brandImage': 'https://via.placeholder.com/150',
        'nama_barang': 'Air Mineral Aqua',
        'status': 'Dalam Pengiriman',
        'alamat': 'Sukabirus',
        'no_wa': '08123456789',
        'nama_lengkap': 'Udin',
      },
      {
        'id': '2',
        'brandImage': 'https://via.placeholder.com/150',
        'nama_barang': 'Air Mineral Cleo',
        'status': 'Dalam Pengiriman',
        'alamat': 'Sukpur',
        'no_wa': '08123456789',
        'nama_lengkap': 'Cucu',
      },
    ];
    return dummyOrders;
  }

  Future<void> updateOrderStatus(String orderId) async {
    await Future.delayed(Duration(seconds: 1));
    print("Order status updated for orderId: $orderId");
  }
}
