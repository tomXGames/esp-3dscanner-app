import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(App(camera: firstCamera));
}

class App extends StatelessWidget{
  final CameraDescription camera;
  const App({
    @required this.camera
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP 3D-Scanner',
      theme: ThemeData.dark(),
      home: HomePage(camera: camera)
    );
  }
}

class HomePage extends StatefulWidget{
  final CameraDescription camera;
  const HomePage({
    @required this.camera
  });

  @override
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
                print("Going to settings");
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Camera(camera: widget.camera),
            ]
          )
        ),
      );
  }
}

class Camera extends StatefulWidget{
  final CameraDescription camera;

  const Camera({
    Key key,
    @required this.camera,
  }) : super(key: key);

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
      widget.camera,
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
            final image = await _controller.takePicture();
            print(image.path);
            GallerySaver.saveImage(image.path, albumName: "ESP3D-Scanner"); /*This plugin has a lot of bugs... Has to change some stuff around in the FileUtils.kt 
                                                                            file to acutally get it to work. Also just saves in the "Pictures" folder, not the 
                                                                            specified album. Might wanna contribute to that repo if I have the time.*/
          },
          child: Text("Take a goddamn Picture!")
        )
      ]
    );
  }
}