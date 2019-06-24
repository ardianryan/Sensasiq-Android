import 'package:flutter/material.dart';
import 'package:sensasiq/Admin/second_page.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: new Text(""),
      ),
      /// For Drawer
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('Jokowi Prabowo'),
              accountEmail: new Text('16.1.03.02.0000'),
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
                //color: Colors.orange,
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
              onTap: (){},
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
              onTap: (){},
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
        child: new Text(
          "Tekan Scan Untuk\nMemindai QR Code",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan",style: new TextStyle(fontWeight: FontWeight.bold)),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SecondPage();
          }));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}