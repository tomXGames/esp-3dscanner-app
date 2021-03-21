import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'devices.dart';
import 'dart:convert';

CameraDescription camera;
BluetoothDevice device;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  camera = cameras.first;
  runApp(App());
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP 3D-Scanner',
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context, future) {
          if (future.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                height: double.infinity,
                child: Center(
                  child: Icon(
                    Icons.bluetooth_disabled,
                    size: 200.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          } else if (future.connectionState == ConnectionState.done) {
            return Devices();
          }
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget{
  final String title;
  final BluetoothDevice server;
  HomePage(this.title, this.server);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    device = widget.server;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Camera(),
            ]
          )
        ),
      );
  }
}

class Camera extends StatefulWidget{
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera>{
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState(){
    super.initState();
    _controller = CameraController(
      camera,
      ResolutionPreset.high
    );
    _initializeControllerFuture = _controller.initialize();
  
    super.initState();

    BluetoothConnection.toAddress(device.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }
  void _sendMessage(String text) async {
    print(text);
    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\n"));
        await connection.output.allSent;
        print("sent"+ text);
      } catch (e) {
        print(e);
        setState(() {});
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<void> (
          future: _initializeControllerFuture,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return CameraPreview(_controller);
            }
            else{
              return CircularProgressIndicator();
            }
          }
        ),
        ElevatedButton(
          onPressed: () async{
            _sendMessage("1");
            for(int i = 0; i < number; i++){
              final image = await _controller.takePicture();
              print(image.path);
              GallerySaver.saveImage(image.path, albumName: "ESP3D-Scanner"); 
              await Future.delayed(Duration(milliseconds: timeIntervall));
            }
            _sendMessage("1");
          },
          child: Text("Start scanning!")
        )
      ]
    );
  }
}