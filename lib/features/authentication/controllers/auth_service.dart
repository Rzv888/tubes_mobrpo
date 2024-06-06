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

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     backgroundColor: Colors.redAccent,
      //     content: Text(
      //       e.toString(),
      //       style: TextStyle(color: Colors.deepOrange),
      //     )));
      print(e);
    }
  }

  Future<String> getUserEmail() async {
    try {
      List<UserIdentity> user = await supabase.auth.getUserIdentities();

      return user[0].identityData?["email"];
    } catch (e) {
      print(e);
      return """
default""";
    }
  }

  Future<String> getUserId() async {
    try {
      List<UserIdentity> user = await supabase.auth.getUserIdentities();

      return user[0].identityData?["id"];
    } catch (e) {
      print(e);
      return """
default""";
    }
  }

Future<void> editName(BuildContext context, String new_name) async{
  try{
    final email_user = await getUserEmail(); 
  await supabase
  .from('users')
  .update({ 'nama_lengkap': new_name })
  .match({ 'email': email_user  });
  }
  catch(e){
    print(e);
  }
}


Future<void> editEmail(BuildContext context, String new_email) async {
  try {
    final email_user = await getUserEmail();
     final response = await supabase
      .from('users')
      .update({ 'email': new_email })
      .match({ 'email': email_user });
    
    final UserResponse res = await supabase.auth.updateUser(
      UserAttributes(
        email: new_email,
      ),
    );
    print("user baru" + res.user.toString());

   

    if (response.error != null) {
      throw Exception("Failed to update email in public schema: ${response.error!.message}");
    }
  } catch (e) {
    
  } 
}

Future<void> editPassword(BuildContext context, String new_password) async{
  try{
    final UserResponse res = await supabase.auth.updateUser(
  UserAttributes(
    password: new_password,
  ),
);
  }
  catch(e){
    print(e);
  }
}

Future<void> editWa(BuildContext context, String new_wa) async{
  try{
    final email_user = await getUserEmail(); 
  await supabase
  .from('users')
  .update({ 'no_wa': new_wa })
  .match({ 'email': email_user  });
  }
  catch(e){
    print(e);
  }
}

Future<void> editAlamat(BuildContext context, String new_alamat) async{
  try{
    final email_user = await getUserEmail(); 
  await supabase
  .from('users')
  .update({ 'alamat': new_alamat })
  .match({ 'email': email_user  });
  }
  catch(e){
    print(e);
  }
}
}
