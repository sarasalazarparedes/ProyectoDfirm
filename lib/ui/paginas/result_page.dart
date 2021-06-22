import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fdirm/controladores/camera_controller.dart';
import 'package:fdirm/controladores/loading_controller.dart';
import 'package:fdirm/service/process_image_service.dart';
import 'package:fdirm/ui/widgets/cargando_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
class ResultPage extends StatelessWidget {
  LoadingController _controller=LoadingController.instance;

  File image;
  ResultPage({this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("Resultado"),
            leading: GestureDetector(
              onTap: (){
                CameraControllerState.instance.activeCamera();
                Navigator.pop(context);
              },
              child: Icon(CupertinoIcons.back),
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 68),
              Expanded(child: _Body(image: image,)),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _controller.isloading,
          builder: (context,value,child){
            return value? LoadingWidget():Container();
          },
        ),
      ],
    );
  }
}
class _Body extends StatefulWidget {
  File image;

  _Body({this.image});

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  Uint8List resultado;
  DateTime now;
  Widget imagenContainer(Uint8List image) {
    return Container(
      height: 300.0,
      width: 300.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(fit: BoxFit.cover, image: MemoryImage(image))),
    );
  }

  Widget imageResultContainer(){
    return Column(
      children:<Widget> [
        imagenContainer(resultado),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              color: CupertinoTheme.of(context).primaryColor,
              child: Text("Descargar",
                style: TextStyle(color: CupertinoColors.white),),
              onPressed: () async{
                final directory = await getExternalStorageDirectory();
                print(directory.path);
                File file = File("${directory.path}/${now.toString()}-firma.png");
                await file.writeAsBytes(resultado);
                showCupertinoDialog(context: context, builder: (context){
                  return CupertinoAlertDialog(
                    title: Text('Descarga Completa'),
                    content: Text('Se descargo la imagen de forma satisfactoria'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('Aceptar'),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              },
            ),

            CupertinoButton(
              child: Text("Compartir"),
              onPressed: () async{
                final directory = await getExternalStorageDirectory();
                File file = File("${directory.path}/${now.toString()}-firma.png");
                await file.writeAsBytes(resultado);
                Share.shareFiles(["${directory.path}/${now.toString()}-firma.png"]);
              },
            ),

          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            imagenContainer(widget.image.readAsBytesSync()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CupertinoButton(
                onPressed: ()async{
                  LoadingController.instance.loading();
                  LoadingController.instance.changeText("Procesando imagen");
                  await  Future.delayed(Duration(seconds: 2),(){});
                  setState(() {

                  });
                  LoadingController.instance.close();
                },
                child: GestureDetector(
                  onTap: ()async{
                    LoadingController.instance.loading();
                    /*Uint8List decode = await widget.image.readAsBytes();
                      final imgb64 = base64Encode(decode);
                      String resultService = await convertPhoto(imgb64);
                      decode = base64Decode(resultService);*/
                    Uint8List decode =
                    await processImage(await widget.image.readAsBytes());
                    LoadingController.instance.close();
                    setState(() {
                      resultado=decode;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Aplicar Filtro"),
                  ),
                ),
              ),
            ),
            resultado==null ? Container():imageResultContainer(),
          ],
        ),
      ),
    );
  }
}



