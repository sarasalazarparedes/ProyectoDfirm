import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
class CustomBottomSheet extends StatelessWidget {

  final Function cerrar;
  final Uint8List image;
  CustomBottomSheet ({this.cerrar,this.image});
  @override
  Widget build(BuildContext context) {


    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top:Radius.circular(16) ),
          color: Color(0xff2C2C2E),
        

      ),
      child: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Resultado',style: TextStyle(color: CupertinoColors.white),),
              GestureDetector(
                onTap: cerrar,
                  child: Text('Salir',style: TextStyle(color: CupertinoTheme.of(context).primaryColor),))
            ],
          ),),
          Expanded(child: Container(height: 300,
          width: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(
                  image),fit: BoxFit.cover
            ),
          ),)),
          CupertinoTabBar(
              onTap: (int value){
                print(value);
              },
              items: [
            BottomNavigationBarItem(

              // ignore: deprecated_member_use
              icon: Icon(CupertinoIcons.folder_solid),title: Text("Descargar")),

            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.share),title: Text("Compartir")),

          ]),
        ],
      ),
    );
  }
}
