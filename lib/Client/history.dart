import 'package:flutter/material.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Login"),),
      body: Center(
        child: RaisedButton(
          child: Text("Back"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}