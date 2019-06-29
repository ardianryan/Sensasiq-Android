import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';

class MainPageState extends State<MainPage> {
  var title = '', indexMenu = 0;
  String result = "Tekan Scan Untuk Memindai QR Code";
  Drawer _buildDrawer(context) {
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text('${widget.namamahasiswa}'),
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
          new ListTile(
            leading: new Icon(Icons.camera_alt),
            title: new Text('Scan QR Absensi'),
            onTap: (){
              setState(() {
                this.title = 'QR Scanner';
                this.indexMenu = 1;
                this.result = "Tekan Scan Untuk Memindai QR Code";
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            leading: new Icon(Icons.calendar_today),
            title: new Text('Jadwal Kuliah'),
            onTap: (){
              setState(() {
                this.title = 'Jadwal Kuliah';
                this.indexMenu = 2;
                this.result = "Ini halaman Jadwal";
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            leading: new Icon(Icons.history),
            title: new Text('Riwayat Absensi'),
            onTap: (){
              setState(() {
                this.title = 'Riwayat Absensi';
                this.indexMenu = 3;
                this.result = "Ini halaman Riwayat";
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            leading: new Icon(Icons.settings_applications),
            title: new Text('Pengaturan Akun'),
            onTap: (){
              setState(() {
                this.title = 'Pengaturan Akun';
                this.indexMenu = 4;
                this.result = "Ini halaman Pengaturan";
              });
              Navigator.pop(context);
            },
          ),
          new Divider(
            color: Colors.black12,
            indent: 15.0,
          ),
          new ListTile(
            title: new Text('Bantuan'),
            onTap: (){
              setState(() {
                this.title = 'Bantuan';
                this.indexMenu = 5;
                this.result = "Ini halaman Bantuan";
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            title: new Text('Tentang'),
            onTap: (){
              setState(() {
                this.title = 'Tentang';
                this.indexMenu = 6;
                this.result = "Ini halaman Tentang";
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
  @override
  

  Widget build(BuildContext context) {
    Future _scanQR() async {
      try {
        String qrResult = await BarcodeScanner.scan();
        setState(() {
          result = qrResult;
        });
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
    if(this.indexMenu == 0 || this.indexMenu == 1 ){
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.title),
          centerTitle: true,
        ),
        // KONTEN
        body: Center(
          child: Text(
            result,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          label: Text("Scan",style: new TextStyle(fontWeight: FontWeight.bold)),
          onPressed: _scanQR,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: _buildDrawer(context),
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(this.title),
          centerTitle: true,
        ),
        // KONTEN
        body: Center(
          child: Text(
            result,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        drawer: _buildDrawer(context),
      );
    }
  }
}

class MainPage extends StatefulWidget {
  final String namamahasiswa, nimnya, kelasnya, deviceidnya, passwordnya;
  MainPage({
    Key key,
    this.namamahasiswa,
    this.nimnya,
    this.kelasnya,
    this.deviceidnya,
    this.passwordnya
    }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}