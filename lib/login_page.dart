import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensasiq/Client/main_page.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nim = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  var username;

  Future<List> _login() async {
    final response =
        await http.post("http://sensasiq.ml/sensasiq/api/mahasiswa", body: {
      "nim": nim.text,
    });

    var datauser = json.decode(response.body);

    if (datauser['error']) {
      showDialog(
          context: context,
          barrierDismissible: false,
          // ignore: deprecated_member_use
          child: new CupertinoAlertDialog(
            title: new Text("Gagal Masuk"),
            content: new Text(
              "Harap Periksa NIM & Password",
              style: new TextStyle(fontSize: 16.0),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("OK"))
            ],
          ));
    } else {
      if (datauser['mahasiswa'][0]['password'] != pass.text) {
        showDialog(
            context: context,
            barrierDismissible: false,
            // ignore: deprecated_member_use
            child: new CupertinoAlertDialog(
              title: new Text("Gagal Masuk"),
              content: new Text(
                "Harap Periksa NIM & Password",
                style: new TextStyle(fontSize: 16.0),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text("OK"))
              ],
            ));
      } else {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new MainPage(username: username),
        );
        Navigator.of(context).pushReplacement(route);
        /*
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return MainPage();
        }));
        */
        setState(() {
          username = datauser['mahasiswa'][0]['nama_mahasiswa'];
        });
      }
    }
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    /*
    //Agar tidak bisa View Horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    */
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
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'NIM',
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
          /*
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return MainPage();
          }));
          */
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
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
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
