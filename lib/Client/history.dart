import 'package:flutter/material.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Login"),),
        body: _dataListBuilder(),
    );
  }
}

Widget _dataListBuilder() {
  final items = List<String>.generate(100, (i) => "Item ke-$i");
  return new ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item),
        );
      }
  );
}