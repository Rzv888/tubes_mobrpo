import 'package:flutter/material.dart';
// import 'package:flutter_tubes_galon/utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(150, 20, 150, 20), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
      
            Image.asset('images/logo.png',width: 200,),   
            Text("Daftar Akun"
            ,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 20
            ),),
          TextField(
cursorColor: Colors.blueAccent,              
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.lightBlue, style: BorderStyle.solid)
                  
                )
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
cursorColor: Colors.blueAccent,              
              decoration: InputDecoration(
                labelText: 'No Telfon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.lightBlue, style: BorderStyle.solid)
                  
                )
              ),
            ),
                        SizedBox(height: 20.0),

            TextField(
              obscureText: true,
cursorColor: Colors.blueAccent,              
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.lightBlue, style: BorderStyle.solid)
                  
                )
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(onPressed: null, child: Text("Daftar")),
            Text("Sudah punya akun? Login"
            ,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              
            ),),
            
          ],
        ),
      ),
    );
  }
}
