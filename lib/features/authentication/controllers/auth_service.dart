import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/main_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      print("email" + email + "password " + password);
      final AuthResponse res = await supabase.auth
          .signInWithPassword(email: email, password: password);
      final User? user = res.user;
      print(user.toString());
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainMenu()),
            (route) => false);
      }
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
      print(e);
    }
  }

  Future<void> register(String email, String password, String name,
      String alamat, String no_wa, BuildContext context) async {
    try {
      print(":masuk sini" + email + password);
      final AuthResponse res =
          await supabase.auth.signUp(email: email, password: password);
      print("yum: _" + res.toString());
      final User? user = res.user;

      print("Berhasil regis" + user.toString());
      if (user != null) {
        UserService().createUser(name, alamat, no_wa, email, context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainMenu()),
            (route) => false);
      }
    } on AuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blueAccent,
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
      print(e);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut(scope: SignOutScope.global);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainMenu()),
          (route) => false);
    } on AuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            e.message,
            style: TextStyle(color: Colors.deepOrange),
          )));
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            e.toString(),
            style: TextStyle(color: Colors.deepOrange),
          )));
      print(e);
    }
  }

  Future<String> getUserEmail() async {
    List<UserIdentity> user = await supabase.auth.getUserIdentities();
    return user[0].identityData?["email"];
  }
}
