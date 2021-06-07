import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_fdirm/controladores/custom_bottom_sheet_controller.dart';
import 'package:proyecto_fdirm/controladores/loading_controller.dart';
import 'package:proyecto_fdirm/service/process_image_service.dart';
import 'package:proyecto_fdirm/ui/paginas/result_page.dart';
import 'package:proyecto_fdirm/ui/widgets/cargando_widget.dart';
import 'package:proyecto_fdirm/ui/widgets/custom_bottom_sheet.dart';
import 'package:proyecto_fdirm/ui/widgets/marker_canvas.dart';
import 'package:path_provider/path_provider.dart';
class CameraPage extends StatefulWidget {
    final List<CameraDescription> cameras;

    CameraPage(this.cameras);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>with SingleTickerProviderStateMixin {
  CameraController _cameraController;
  LoadingController _controller=LoadingController.instance;
  CustomBottomSheetController _customBottomSheetController;
  Uint8List result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController =CameraController(widget.cameras[0],ResolutionPreset.high);
    _cameraController.initialize().then((value) {
      if(!mounted){
        return;
      }
      setState(() {

      });
    } );
    _customBottomSheetController=CustomBottomSheetController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }
  
  Widget ButtonCamera(){
    return GestureDetector(
      onTap: ()async{

        final image = _customBottomSheetController.open();
        final path =await getExternalStorageDirectory();
        final now = DateTime.now();

        //final name="${now.year}"
        print (path);
          await _cameraController.takePicture("");
         // await processImage();


      },
      child: Center(
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
            color: CupertinoColors.black,
            borderRadius: BorderRadius.circular(30),
              ),
            child: Center(

                child: Icon(CupertinoIcons.camera,color: CupertinoColors.systemRed,size: 30,),
      ),),),
    );
  }
  Widget CameraMArkers(){
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: CustomPaint(
        child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment:Alignment.bottomCenter,
                  child:
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text("Capture la fotografia dentro del \n cuadro del marco",style: TextStyle(fontSize: 14,color: CupertinoColors.white),textAlign: TextAlign.center ,),
                  ),
                )
              ],
            )),
        size: Size.infinite,
        painter: MarkerCanvas(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width:  MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
       CameraPreview(_cameraController),
          CupertinoPageScaffold(
            backgroundColor: Color(0x00000000),
            navigationBar: CupertinoNavigationBar(
              trailing: GestureDetector(
                onTap: ()async{
                  // ignore: deprecated_member_use
                  File  image=await ImagePicker.pickImage(source: ImageSource.gallery);

                  Navigator.push(context, CupertinoPageRoute(
                    builder:(context) =>ResultPage(image: image,)
                  ));
                  },
                  child: Text("Galeria",style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
               ) ,
              middle: Text("Captura Fotografia"),
            ),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                        child: CameraMArkers(),
                    ),
                    Flexible(
                      flex: 1,
                      child: ButtonCamera(),
                    )
                  ],
                ),
              ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller.isloading,
            builder: (context,value,child){
              return value? LoadingWidget():Container();
            },
          ),
          Transform.translate(
              offset: Offset(
                  0.0,
                  MediaQuery.of(context).size.height -
                      (400 * _customBottomSheetController.value)),
              child: CustomBottomSheet(

                cerrar: (){
                _customBottomSheetController.close();
              },)
          )
        ],
      ),
    );


  }
}
