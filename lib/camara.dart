import 'package:fdirm/ui/paginas/camera_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras=await availableCameras();
  print(cameras.length);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0x00000000)
    ));
    return CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemIndigo,
      ),
      title: 'DFirm',
      home:CameraPage(cameras),
      //home: ResultPage(),

    );
  }
}
