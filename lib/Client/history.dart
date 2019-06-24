import 'package:flutter/material.dart';

void main(){
  runApp(new MaterialApp(

    home: new History(data: new List<String>.generate(300, (i)=>"Ini data ke $i"),),
  ));
}

class History extends StatelessWidget {
  final List<String> data;
  History ({this.data});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Login"),),
        body: new Container(
          child: new ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index){
              return new ListTile(
                leading: new Icon(Icons.widgets),
                title: new Text("${data[index]}"),
              );
            },
          ),
        )
    );
  }
}