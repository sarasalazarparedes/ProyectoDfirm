import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:fdirm/controladores/camera_controller.dart';
import 'package:fdirm/controladores/custom_bottom_sheet_controller.dart';
import 'package:fdirm/controladores/loading_controller.dart';
import 'package:fdirm/service/process_image_service.dart';
import 'package:fdirm/ui/paginas/result_page.dart';
import 'package:fdirm/ui/widgets/cargando_widget.dart';
import 'package:fdirm/ui/widgets/custom_bottom_sheet.dart';
import 'package:fdirm/ui/widgets/marker_canvas.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraPage(this.cameras);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  CameraController _cameraController;
  LoadingController _controller = LoadingController.instance;
  CustomBottomSheetController _customBottomSheetController;

  Uint8List result;

  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _customBottomSheetController = CustomBottomSheetController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  Widget CameraMarkers() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: CustomPaint(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Capture la fotografía dentro del\ncuadro de enmarque',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        size: Size.infinite,
        painter: MarkerCanvas(),
      ),
    );
  }

  Widget ButtonCamera() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          try {
            _controller.loading();
            final directory = await getExternalStorageDirectory();
            final now = DateTime.now();
            var mg = "${directory.path}/${now.toString()}.png";

            XFile file = await _cameraController
                .takePicture();

            //File file = File("${directory.path}/${now.toString()}.png");

            Uint8List convert = await file.readAsBytes();
            Uint8List imageProcess =
            await processImage(convert);

            _controller.close();
            setState(() {
              result = imageProcess;
            });

            _customBottomSheetController.open();
          }
          catch(e){
            _controller.close();
          }
        },
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
              color: CupertinoColors.black,
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Icon(
              CupertinoIcons.camera,
              color: CupertinoColors.systemRed,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CameraControllerState.instance.cameraActive,
      builder: (context, value, child) {
        return value
            ? SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              CameraPreview(_cameraController),
              CupertinoPageScaffold(
                backgroundColor: Color(0x00000000),
                navigationBar: CupertinoNavigationBar(
                  trailing: GestureDetector(
                    onTap: () async {
                      CameraControllerState.instance.pauseCamera();
                      // ignore: deprecated_member_use
                      File image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);

                      if (image != null) {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    ResultPage(image: image)));
                      } else {
                        CameraControllerState.instance.activeCamera();
                      }
                    },
                    child: Text(
                      'Galeria',
                      style: TextStyle(
                          color: CupertinoTheme.of(context).primaryColor),
                    ),
                  ),
                  middle: Text('Captura una fotografía'),
                ),
                child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Flexible(flex: 3, child: CameraMarkers()),
                        Flexible(flex: 1, child: ButtonCamera())
                      ],
                    )),
              ),
              ValueListenableBuilder(
                valueListenable: _controller.isloading,
                builder: (context, value, child) {
                  return value ? LoadingWidget() : Container();
                },
              ),
              Transform.translate(
                offset: Offset(
                    0.0,
                    MediaQuery.of(context).size.height -
                        (400 * _customBottomSheetController.value)),
                child: CustomBottomSheet(
                  image: result,
                  cerrar: () {
                    _customBottomSheetController.close();
                  },
                ),
              )
            ],
          ),
        )
            : Container();
      },
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _customBottomSheetController.dispose();

    super.dispose();
  }
}