import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:sensasiq/Client/history.dart';
import 'package:sensasiq/Client/edit_akun.dart';

class MainPage extends StatefulWidget {

  final String namamhs;
  final String nimnya;
  MainPage({Key key, this.namamhs, this.nimnya}) : super(key: key);

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<MainPage> {

  String result = "Tekan Scan Untuk\nMemindai QR Code";
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Izin kamera ditolak";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "Anda menekan tombol kembali sebelum memindai apa pun";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      /// For Drawer
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('${widget.namamhs}'),
              accountEmail: new Text('${widget.nimnya}'),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.lightBlue,
                  child: new Icon(Icons.person,color: Colors.white,),
                ),
              ),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('assets/bg_profil.png'),
                    fit: BoxFit.fill,
                  )
              ),
            ),
            new InkWell(
              onTap: (){},
              child: new ListTile(
                title: new Text('Scan QR',),
                leading: new Icon(Icons.camera_alt),
              ),
            ),
            new InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (test){
                  return EditAkun();
                }));
              },
              child: new ListTile(
                title: new Text('Edit Akun',),
                leading: new Icon(Icons.account_circle),
              ),
            ),
            new InkWell(
              onTap: (){},
              child: new ListTile(
                title: new Text('Lihat Jadwal',),
                leading: new Icon(Icons.calendar_today),
              ),
            ),
            new InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return History();
                }));
              },
              child: new ListTile(
                title: new Text('Riwayat Absen',),
                leading: new Icon(Icons.access_time),
              ),
            ),
            new Divider(
              color: Colors.black12,
              height: 4.0,
            ),
            new InkWell(
              onTap: (){},
              child: new ListTile(
                title: new Text('Pengaturan',),
                leading: new Icon(Icons.settings),
              ),
            ),
            new InkWell(
              onTap: (){},
              child: new ListTile(
                title: new Text('Bantuan',),
                leading: new Icon(Icons.help),
              ),
            ),
          ],
        ),
      ),

      /// For Body
      body: Center(
        child: Text(
          result,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan",style: new TextStyle(fontWeight: FontWeight.bold)),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}