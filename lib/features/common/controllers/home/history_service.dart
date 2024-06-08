import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryService {
  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final supabase = Supabase.instance.client;
      final user = await UserService().getCurrentUser();
      print('User: $user'); // Print nilai user

      final ordersResponse = await supabase
          .from("orders")
          .select('id_barang, jumlah_barang, total_transaksi, status')
          .match({'id_pemesan': user['id']}).eq('status', 'Selesai');
      print('Orders Response: $ordersResponse'); // Print nilai ordersResponse

      final orders = List<Map<String, dynamic>>.from(ordersResponse);

      for (final order in orders) {
        final productId = order['id_barang'];
        final productResponse = await supabase
            .from('products')
            .select('id, nama_barang, harga_barang')
            .eq('id', productId)
            .single();
        print(
            'Product Response: $productResponse'); // Print nilai productResponse

        final product = productResponse;
        order['product'] = product;
      }

      return orders;
    } catch (error) {
      print('Error in getHistory: $error');
      throw Exception('Internal Server Error');
    }
  }
}
