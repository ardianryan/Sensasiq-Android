import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:package_info/package_info.dart';

class MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var title = '', indexMenu = 0, idqr, nip;
  String result = "Selamat Datang di SENSASIQ APP", version;
  int colorSnackbar;
  TextEditingController passlama = new TextEditingController();
  TextEditingController passbaru = new TextEditingController();
  TextEditingController passbaru2 = new TextEditingController();

  Future <List<Jadwal>> _getJadwal() async {
    var jadwalRespon = await http.post('http://192.168.12.1/sensasiq/api/jadwal/jadwal', body: {
      "nim": widget.nimnya
    });
    var dataJadwal = json.decode(jadwalRespon.body);

    List<Jadwal> jadwals = [];
    for (var j in dataJadwal) {
      Jadwal jadwal = Jadwal(j["nama_matkul"], j["waktu"], j["nama_dosen"]);
      jadwals.add(jadwal);
    }
    print(jadwals.length);

    return jadwals;
  }

  Future <List<Riwayat>> _getRiwayat() async {
    var riwayatRespon = await http.post('http://192.168.12.1/sensasiq/api/absen/absen', body: {
      "nim": widget.nimnya
    });
    var dataRiwayat = json.decode(riwayatRespon.body);

    List<Riwayat> riwayats = [];
    for (var r in dataRiwayat) {
      Riwayat riwayat = Riwayat(r["waktu"], r["nama_matkul"], r["nama_dosen"]);
      riwayats.add(riwayat);
    }
    print(riwayats.length);

    return riwayats;
  }

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
              });
              Navigator.pop(context);
            },
          ),
          new ListTile(
            title: new Text('Tentang'),
            onTap: (){
              setState(() {
                this.title = 'Tentang Aplikasi';
                this.indexMenu = 6;
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
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
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
    });
    Future<List> _updatePass() async {
      if((passlama.text!=null) || (passbaru.text!=null) || (passbaru2.text!=null)){
        if(generateMd5(passlama.text)==widget.passwordnya){
          if(passbaru.text == passbaru2.text){
            final responUpdatePass = await http.put("http://192.168.12.1/sensasiq/api/mahasiswa/update", body: {
              "nim": widget.nimnya,
              "password" : generateMd5(passbaru.text)
            });
            var dataUpdatePass = json.decode(responUpdatePass.body);
            if(!dataUpdatePass['error']){
              //BERHASIL
              this.colorSnackbar = 0xff4caf50;
              this.result = "Kata Sandi berhasil diperbarui!";
              _showSnackBar();
              passlama.clear();
              passbaru.clear();
              passbaru2.clear();
            } else {
              this.colorSnackbar = 0xfff94040;
              this.result = "Gagal! Server tidak menanggapi!";
              _showSnackBar();
              passlama.clear();
              passbaru.clear();
              passbaru2.clear();
            }
          } else {
            this.colorSnackbar = 0xfff94040;
            this.result = "Gagal! Harap periksa Kata Sandi baru!";
            _showSnackBar();
            passlama.clear();
            passbaru.clear();
            passbaru2.clear();
          }
        } else {
          this.colorSnackbar = 0xfff94040;
          this.result = "Gagal! Kata Sandi lama tidak valid!";
          _showSnackBar();
          passlama.clear();
          passbaru.clear();
          passbaru2.clear();
        }
      }
      return null;
    }

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
          _updatePass();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Ubah', style: TextStyle(color: Colors.white)),
      ),
    );

    Future _scanQR() async {
      try {
        String qrResult = await BarcodeScanner.scan();
        this.result = qrResult;
          this.indexMenu = 1;
          final response = await http.post("http://192.168.12.1/sensasiq/api/qr/cocok", body: {
           "qr": result,
          });
          var datauser = json.decode(response.body);
          if((datauser['error']) || (datauser['qr'][0]['qr']!=result)){
            setState(() {
              result = "Kode QR tidak valid!";
            });
          } else {
            this.indexMenu = 7;
            nip = datauser['qr'][0]['nip'];
            final hasil = await http.post("http://192.168.12.1/sensasiq/api/absen/add", body: {
              "id_jadwal": datauser['qr'][0]['qr'].split('-')[0],
              "id_qr": datauser['qr'][0]['id_qr'],
              "nim": widget.nimnya
            });
            json.decode(hasil.body);
            setState(() {
              result = "Berhasil Scan QR! Absen Berhasil!";
            });
          }
      } on FormatException {
        setState(() {
          this.result = "Anda menekan tombol kembali sebelum memindai apa pun";
        });
      } catch (ex) {
        setState(() {
          this.result = "Unknown Error $ex";
        });
      }
    }

    switch (this.indexMenu) {
      case 1:
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
        break;
      case 2:
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(this.title),
            centerTitle: true,
          ),
          // KONTEN
          body: Container(
            child: FutureBuilder(
              future: _getJadwal(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null){
                  return Container(
                    child: Center(
                      child: Text("Memuat...")
                    )
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data[index].namamatkul ?? ''),
                          subtitle: Text(snapshot.data[index].waktu+"\n Dosen : "+snapshot.data[index].namadosen ?? ''),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          drawer: _buildDrawer(context),
        );
        break;
      case 3:
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(this.title),
            centerTitle: true,
          ),
          // KONTEN
          body: Container(
            child: FutureBuilder(
              future: _getRiwayat(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null){
                  return Container(
                    child: Center(
                      child: Text("Memuat...")
                    )
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data[index].riwayatwaktu ?? ''),
                          subtitle: Text(snapshot.data[index].riwayatmatkul+"\n Dosen : "+snapshot.data[index].riwayatdosen ?? ''),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          drawer: _buildDrawer(context),
        );
        break;
      case 4:
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: Text("Edit Akun"),
            centerTitle: true,
          ),
          body: Center(
            child: ListView(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 70),
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
          drawer: _buildDrawer(context),
        );
        break;
      case 5:
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(this.title),
            centerTitle: true,
          ),
          // KONTEN
          body: new Center(
            child: ListView(
              padding: const EdgeInsets.all(50.0),
              children: <Widget>[
                new Image.asset(
                  "assets/bantuan.png",
                  height: 250.0,
                  width: 300.0,
                ),
                SizedBox(height: 40.0),
                new Text(
                  "Layanan Bermasalah?",
                  style: TextStyle(
                    fontSize: 50.0, fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                ),
                new Text(
                  "Pastikan beberapa hal berikut",
                  style: TextStyle(
                    fontSize: 25.0, fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                ),
                new Text(
                  "\n\n\u2022   Gadget wajib terhubung dengan internet melalui jaringan di Kampus Universitas Nusantara PGRI Kediri, kalian dapat menggunakan fasilitas WiFI pada Kampus.",
                  style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w200
                  ),
                  textAlign: TextAlign.left,
                ),
                new Text(
                  "\n\u2022   SENSASIQ APP memerlukan akses GPS, untuk itu harap menyalakan fitur GPS pada Gadget kalian.",
                  style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w200
                  ),
                  textAlign: TextAlign.left,
                ),
                new Text(
                  "\n\u2022   SENSASIQ APP memerlukan akses Kamera, untuk itu harap memberikan ijin penggunaan Kamera kepada aplikasi SENSASIQ.",
                  style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w200
                  ),
                  textAlign: TextAlign.left,
                ),
                new Text(
                  "\n\u2022   Akun hanya dapat digunakan pada satu Gadget saja dan tidak diperkenankan untuk melakukan Log In pada Gadget lain. Apabila akun bermasalah, silahkan hubungi pihak Program Studi masing - masing.",
                  style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w200
                  ),
                  textAlign: TextAlign.left,
                ),
              ] 
            ),
          ),
          drawer: _buildDrawer(context),
        );
        break;
      case 6:
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(this.title),
            centerTitle: true,
          ),
          // KONTEN
          body: new Center(
            child: ListView(
              padding: const EdgeInsets.all(50.0),
              children: <Widget>[
                new Image.asset(
                  "assets/tentangMenu.png",
                  height: 250.0,
                  width: 300.0,
                ),
                SizedBox(height: 40.0),
                new Text(
                  "Apa itu SENSASIQ?",
                  style: TextStyle(
                    fontSize: 50.0, fontWeight: FontWeight.w300
                  ),
                  textAlign: TextAlign.center,
                ),
                new Text(
                  "\n\nSolusi Absensi Cerdas Anti Curang Berbasis QR Code atau disingkat SENSASIQ merupakan  pengganti dari sistem absensi konvensional biasa yang memakan waktu karena antrian dan biaya untuk pengadaan lembar kertas absensi. Selain itu, SENSASIQ juga dibangun untuk mengurangi kecurangan terhadap absen dengan beberapa macam lapisan kemanan seperti pemanfaatan GPS serta alamat IP dari Gadget pengguna untuk pencocokan lokasi absen.",
                  style: TextStyle(
                    fontSize: 17.0, fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.justify,
                ),
                new Text(
                  "\n\ncontact@sensasiq.ml",
                  style: TextStyle(
                    fontSize: 11.0, fontWeight: FontWeight.w300
                  ),
                  textAlign: TextAlign.left,
                ),
                new Text(
                  "Version: "+this.version,
                  style: TextStyle(
                    fontSize: 10.37, fontWeight: FontWeight.w300
                  ),
                  textAlign: TextAlign.left,
                ),
                new Text(
                  "Copyleft © 2019 SENSASIQ.ML",
                  style: TextStyle(
                    fontSize: 10.0, fontWeight: FontWeight.w300
                  ),
                  textAlign: TextAlign.left,
                ),
              ] 
            ),
          ),
          drawer: _buildDrawer(context),
        );
        break;
      case 7:
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
          drawer: _buildDrawer(context),
        );
        break;
      default:
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(this.title),
            centerTitle: true,
          ),
          // KONTEN
          body: new Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Text(
                  "Selamat datang, "+widget.namamahasiswa+"!",
                  style: TextStyle(
                    fontSize: 30.0, fontWeight: FontWeight.w300
                  ),
                  textAlign: TextAlign.center,
                ),
                new Image.asset(
                  "assets/landing.png",
                  height: 300.0,
                  width: 300.0,
                ),
                SizedBox(height: 40.0),
                new Text(
                  "SENSASIQ",
                  style: TextStyle(
                    fontSize: 50.0, fontWeight: FontWeight.w100
                  ),
                  textAlign: TextAlign.center,
                ),
                new Text(
                  "Solusi Absensi Cerdas Anti Curang Berbasis QR Code",
                  style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w200
                  ),
                  textAlign: TextAlign.center,
                ),
              ] 
            ),
          ),
          drawer: _buildDrawer(context),
        );
        break;
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

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

class Jadwal {
  final String namamatkul, waktu, namadosen;
  Jadwal(this.namamatkul, this.waktu, this.namadosen);
}

class Riwayat {
  final String riwayatwaktu, riwayatmatkul, riwayatdosen;
  Riwayat(this.riwayatwaktu, this.riwayatmatkul, this.riwayatdosen);
}