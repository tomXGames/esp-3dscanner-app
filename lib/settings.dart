import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

int number = 16;
int timeIntervall = 500;

class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{
  TextEditingController numberFieldEditingController = TextEditingController(text: number.toString());
  TextEditingController timeFieldEditingController = TextEditingController(text: timeIntervall.toString());
  @override
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
              ),
              TextField(
                controller: numberFieldEditingController  ,
                decoration: InputDecoration(labelText: "Time delay between OPhotos"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (text){
                  timeIntervall = int.parse(text);
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

