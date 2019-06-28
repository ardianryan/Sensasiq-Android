import 'package:flutter/material.dart';
TextEditingController passlama = new TextEditingController();
TextEditingController passbaru = new TextEditingController();
TextEditingController passbaru2 = new TextEditingController();
class EditAkun extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    /*
    //Agar tidak bisa View Horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    */
    final passwdlama = TextFormField(
      controller: passlama,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Kata Sandi Lama',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passbaru,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Kata Sandi Baru',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final password2 = TextFormField(
      controller: passbaru2,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Konfirmasi Kata Sandi',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          //_login();
          /*
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return MainPage();
          }));
          */
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Ubah', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Edit Akun"),),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            passwdlama,
            SizedBox(height: 24.0),
            password,
            SizedBox(height: 24.0),
            password2,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }}