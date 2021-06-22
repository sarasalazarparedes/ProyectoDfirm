import 'dart:async';


import 'package:camera/camera.dart';

import 'package:fdirm/ui/paginas/camera_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../camara.dart';
import '../../size_config.dart';
import 'land.dart';


import 'tabs.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isFullSun = false;
  bool isDayMood = true;
  Duration _duration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isFullSun = true;
      });
    });
  }

  void changeMood(int activeTabNum) {
    if (activeTabNum == 0) {
      setState(() {
        isDayMood = true;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isFullSun = true;
        });
      });
    } else {
      setState(() {
        isFullSun = false;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isDayMood = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> lightBgColors = [
      Color(0xFF8C2480),
      Color(0xFFCE587D),
      Color(0xFFFF9485),
      if (isFullSun) Color(0xFFFF9D80),
    ];
    var darkBgColors = [
      Color(0xFF0D1441),
      Color(0xFF283584),
      Color(0xFF376AB2),
    ];
    return AnimatedContainer(
      duration: _duration,
      curve: Curves.easeInOut,
      width: double.infinity,
      height: SizeConfig.screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDayMood ? lightBgColors : darkBgColors,
        ),
      ),
      child: Stack(
        children: [
          Land(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpacing(of: 50),
                  Tabs(
                    press: (value) {
                      changeMood(value);
                    },
                  ),
                  VerticalSpacing(),

                  Center(

                    child: Text(

                      "DFirm",
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  VerticalSpacing(of: 10),
                  Center(
                    child: Text(
                      "Universidad Católica Boliviana \n             San Pablo UCB",
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),

                  ),
                  VerticalSpacing(of: 50),
                  Center(
                    child: Text(
                      "WorkShop  \n    I-2021  ",
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),

                  ),
                  VerticalSpacing(of: 20),
                  Center(
                    child: Text(
                      " Proyecto: Digitalización de firmas \n   mediante el uso de cámara, \n        aplicando  Open CV.  ",
                      style: TextStyle(color: Colors.lightBlue[500],fontSize: 23),
                    ),

                  ),
                  VerticalSpacing(of: 50),
                  Center(

                    child: Text(
                      " Materia:  Dispositivos moviles \n Docente: Jorge Tancara \n Integrantes:\n Sara Salazar Paredes \n Aracely Torrez Velasco  ",
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),

                  ),
                  VerticalSpacing(of: 50),
                  Center(
                    child: CupertinoButton(child: Text("Empecemos...",
                      style: TextStyle(color: Colors.orange[800],fontSize: 23),
                    ), onPressed: ()  {
                      setState(() {
                        main();
                      });

                    }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
