import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'settings.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP 3D-Scanner',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(title: 'Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
            },
          )
        ],
      ),
      body:Center(
        child: Column(
          children: <Widget>[
            Camera()
          ],
        )
      )
    );
  }
}


class Camera extends StatefulWidget{
  

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera>{
  CameraDescription camera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  @override
  void initState() async{
    final cameras = await availableCameras();
    camera = cameras.first;
    _controller = CameraController(
      camera,
      ResolutionPreset.low
    );
    _initializeControllerFuture = _controller.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return CameraPreview(_controller);
  }
}

