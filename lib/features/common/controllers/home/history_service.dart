import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getHistory() async {
    final user = await UserService().getCurrentUser();

    final orders = await supabase
        .from("orders")
        .select()
        .match({'id_pemesan': user['id']});

    List<Map<String, dynamic>> history = [];

    for (var order in orders) {
      final product = await supabase
          .from("products")
          .select()
          .eq('id', order['id_barang'])
          .single();

      history.add({
        'id_barang': order['id_barang'],
        'jumlah_barang': order['jumlah_barang'],
        'status': order['status'],
        'total_transaksi': order['total_transaksi'],
        'nama_barang': product['nama_barang'],
        'harga_barang': product['harga_barang'],
      });
    }

    return history;
  }
}
