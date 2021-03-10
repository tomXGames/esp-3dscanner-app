import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

int number;

class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{
  @override
  TextEditingController numberFieldEditingController = TextEditingController(text: "16");
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop())
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: numberFieldEditingController  ,
                decoration: InputDecoration(labelText: "Number of Photos"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (text){
                  number = int.parse(text);
                },
              )
            ]
          )
        )
      ),
      bottomSheet:  Padding(
          padding: EdgeInsets.all(20), 
          child: Text("Made by @tomXGames. ESP 3D-Scanner v0.1 Firmware at github.com/tomXGames/esp-3dscanner-firmware"),
        )
      );
  }
}