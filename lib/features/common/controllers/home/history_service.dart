import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryService {
  final supabase = Supabase.instance.client;
  Future<List<Map<String, dynamic>>> getHistory() async {
    final user = await UserService().getCurrentUser();
    final response = await supabase
        .from("orders")
        .select()
        .match({'id_pemesan': user['id']}).eq('status', 'Selesai');
    if (response.isEmpty) {
      return [];
    }
    return List<Map<String, dynamic>>.from(response);
  }
}
