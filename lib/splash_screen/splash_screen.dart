

import 'dart:async';

//import 'package:animation_bulb/ocr_and_tts/compine_ocr_tts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ocr_and_tts/ocr_and_tts_screen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName="SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirst=true;
  @override
  Widget build(BuildContext context) {
    if(isFirst==false){
      Timer(Duration(seconds: 5),(){
        Navigator.pushNamed(context, CompineOCRTTSScreen.routeName);
      }
      );
    }
    if(isFirst == true){
      Timer(Duration(seconds: 2),(){
        isFirst=false;
        setState(() {
        });
      }
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),body:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start ,
      children: [
        Center(
          child: AnimatedCrossFade(
            duration: Duration(seconds: 3),
            firstChild:Container(width:250,height:250,decoration: BoxDecoration(shape:BoxShape.rectangle, ),child: Image.asset("assets/images/bulb10.jpg"),) ,
            secondChild: Container(width:250,height:250,decoration: BoxDecoration(shape:BoxShape.circle,
            ),child: Image.asset("assets/images/bulb5.jpg")),
            crossFadeState: isFirst? CrossFadeState.showFirst: CrossFadeState.showSecond,
          ),
        ),
        Center(
          child: Container(padding: EdgeInsets.symmetric(vertical: 3,horizontal: 12),decoration: BoxDecoration(
              color: Color(0x5E5D5D1F),
              border: Border.all(width: 1,color: Color(0x7A6A1FFF), ),borderRadius: BorderRadius.all(Radius.circular(19) )),
            child: Text("Innovate..!",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400,fontStyle: FontStyle.italic),),
          ),
        ),
      ],),);
  }
}
