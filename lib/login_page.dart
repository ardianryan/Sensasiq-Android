import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensasiq/mainPage.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nim = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  var namamahasiswa, nimnya, passwordnya, deviceidnya, kelasnya, result;
  int colorSnackbar;

  Future<List> _login() async {
    // Device ID
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final response = await http.post("http://sensasiq.ml/sensasiq/api/mahasiswa", body: {
      "nim": nim.text,
    });

    var datauser = json.decode(response.body);

    if (datauser['error']) {
      this.colorSnackbar = 0xfff94040;
      this.result = "NIM tidak terdaftar!";
      _showSnackBar();
      nim.clear();
      pass.clear();
    } else {
      if (datauser['mahasiswa'][0]['password'] != generateMd5(pass.text) || datauser['mahasiswa'][0]['nim'] != nim.text) {
        this.colorSnackbar = 0xfff94040;
        this.result = "Harap periksa NIM atau Kata Sandi!";
        _showSnackBar();
        nim.clear();
        pass.clear();
      } else {
          if((datauser['mahasiswa'][0]['device_id'] != null) && (datauser['mahasiswa'][0]['device_id'] != androidInfo.androidId)){
            this.colorSnackbar = 0xfff94040;
            this.result = "NIM sudah terdaftar di perangkat lain!";
            _showSnackBar();
            nim.clear();
            pass.clear();
          } else {
              if (datauser['mahasiswa'][0]['device_id'] == null) {
                //INPUT DEVICE ID KE DB JIKA MASIH KOSONG
                http.put("http://sensasiq.ml/sensasiq/api/mahasiswa/device", body: {
                  "nim": nim.text,
                  "device_id": androidInfo.androidId
                });
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new MainPage(namamahasiswa: namamahasiswa, nimnya: nimnya, passwordnya: passwordnya, deviceidnya: deviceidnya, kelasnya: kelasnya),
                );
                Navigator.of(context).pushReplacement(route);
                setState(() {
                  namamahasiswa = datauser['mahasiswa'][0]['nama_mahasiswa'];
                  nimnya = datauser['mahasiswa'][0]['nim'];
                  passwordnya = datauser['mahasiswa'][0]['password'];
                  deviceidnya = datauser['mahasiswa'][0]['device_id'];
                  kelasnya = datauser['mahasiswa'][0]['kelas'];
                });
              } else {
                if ((datauser['mahasiswa'][0]['device_id'] != null) && (datauser['mahasiswa'][0]['device_id'] == androidInfo.androidId)) {
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new MainPage(namamahasiswa: namamahasiswa, nimnya: nimnya, passwordnya: passwordnya, deviceidnya: deviceidnya, kelasnya: kelasnya),
                  );
                  Navigator.of(context).pushReplacement(route);
                  setState(() {
                    namamahasiswa = datauser['mahasiswa'][0]['nama_mahasiswa'];
                    nimnya = datauser['mahasiswa'][0]['nim'];
                    passwordnya = datauser['mahasiswa'][0]['password'];
                    deviceidnya = datauser['mahasiswa'][0]['device_id'];
                    kelasnya = datauser['mahasiswa'][0]['kelas'];
                  });
                } else {
                  this.colorSnackbar = 0xfff94040;
                  this.result = "Kesalahan tidak diketahui!";
                  _showSnackBar();
                  nim.clear();
                  pass.clear();
                }
              }
            }
        } 
    }
    return null;
  }

  _showSnackBar(){
    final snackBar =  new SnackBar(
      content: new Text(this.result),
      duration: new Duration(seconds: 5),
      backgroundColor: Color(this.colorSnackbar),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      controller: nim,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Nomor Induk Mahasiswa',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: pass,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Kata Sandi',
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
          _login();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Masuk', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Lupa Sandi?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            new Text(
              "SENSASIQ APP",
              style: TextStyle(
                fontSize: 50.0, fontWeight: FontWeight.w100
                ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50.0),
            
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
