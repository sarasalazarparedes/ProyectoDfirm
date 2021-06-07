import 'package:flutter/cupertino.dart';

class LoadingController{

  static  final instance=LoadingController._();
  LoadingController._();

  ValueNotifier<bool> _isloading =ValueNotifier<bool>(false);
  ValueNotifier<String> _text=ValueNotifier<String>("");

  get isloading => _isloading;
  get text => _text;

  void loading(){
    _isloading.value=true;
  }
  void close(){
    _isloading.value=false;
  }
  void changeText(String text){
    _text.value=text;
  }
  void cleanText(){
    _text.value="";
  }
}