import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'package:camera/camera.dart';

CameraDescription camera;

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
      home: HomePage('ESP 3D-Scanner')
    );
  }
}

class HomePage extends StatefulWidget{
  final String title;
  HomePage(this.title);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
                print("Going to settings");
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

  @override
  void initState(){
    super.initState();
    _controller = CameraController(
      camera,
      ResolutionPreset.high
    );
    _initializeControllerFuture = _controller.initialize();
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
            for(int i = 0; i < number; i++){
              final image = await _controller.takePicture();
              print(image.path);
              GallerySaver.saveImage(image.path, albumName: "ESP3D-Scanner"); 
              
            }
          },
          child: Text("Start scanning!")
        )
      ]
    );
  }
}