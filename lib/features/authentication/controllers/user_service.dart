import 'package:flutter_tubes_galon/main_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class UserService {
  final supabase = Supabase.instance.client;
  Future<void> createUser(String name, String alamat, String no_wa,
      String email, BuildContext context) async {
    try {
      print("a");
      await supabase.from('users').insert({
        'nama_lengkap': name,
        'no_wa': no_wa,
        'saldo': 0,
        "xp": 0,
        "level": 0,
        "alamat": alamat,
        'email': email
      });
    } on AuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            e.message,
            style: TextStyle(color: Colors.white),
          )));
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          )));
    }
  }
}
