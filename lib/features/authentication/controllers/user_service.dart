import 'package:flutter_tubes_galon/features/authentication/controllers/auth_service.dart';
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

  Future<dynamic> getCurrentUser() async {
    try {
      final email = await AuthService().getUserEmail();
      final user =
          await supabase.from("users").select().match({'email': email});
      print("nama" + user[0]["nama_lengkap"]);
      return user[0];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<void> updateSaldo(int saldo) async {
    final user = await UserService().getCurrentUser();
    int curSaldo = user["saldo"] + saldo;
    await supabase
        .from("users")
        .update({'saldo': curSaldo}).match({"email": user["email"]});
  }

  Future<void> updateXP(int XP) async {
    final user = await UserService().getCurrentUser();
    int curXP = user["xp"] + XP;
    await supabase
        .from("users")
        .update({'xp': curXP}).match({"email": user["email"]});
  }

  Future<void> setXP(int XP) async {
    final user = await UserService().getCurrentUser();

    await supabase
        .from("users")
        .update({'xp': XP}).match({"email": user["email"]});
  }

  Future<void> addLevel() async {
    final user = await UserService().getCurrentUser();
    int curlevel = user["level"] + 1;
    await supabase
        .from("users")
        .update({'level': curlevel}).match({"email": user["email"]});
  }
}
