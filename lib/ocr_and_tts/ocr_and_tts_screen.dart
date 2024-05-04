


import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lottie/lottie.dart';
import 'package:tts_refactor/ocr_and_tts/cubit/states/ocr_tts_states.dart';
import 'package:tts_refactor/ocr_and_tts/cubit/viewmodel/ocr_tts_viewModel.dart';
import 'package:tts_refactor/ocr_and_tts/text_recognition_widget.dart';

import 'cubit/constants.dart';
import 'cubit/image_picker_functions.dart';


class CompineOCRTTSScreen extends StatefulWidget {

  static String routeName="CompineOCRTTSScreen";

  @override
  State<CompineOCRTTSScreen> createState() => _CompineOCRTTSScreenState();
}

class _CompineOCRTTSScreenState extends State<CompineOCRTTSScreen> {


  OCRTTSViewModel _ocrttsViewModel=OCRTTSViewModel();

  @override
  void initState() {
    super.initState();
    _ocrttsViewModel.initTTS();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OCRTTSViewModel,OCRTTSStates>(
      bloc: _ocrttsViewModel,
        builder: (context,state){
        print("Screen rebuilt---------------------");
        if(_ocrttsViewModel.pickedImage !=null && _ocrttsViewModel.flag==0){
          _ocrttsViewModel.extractText(_ocrttsViewModel.pickedImage!);

        }
        return
        Scaffold(appBar: AppBar(),body: SafeArea(
          child: Center(
            child: (state is OCRTTSLoadingState)? CircularProgressIndicator():
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCrossFade(
                  firstCurve: Curves.fastLinearToSlowEaseIn,
                  secondCurve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(seconds: 1),
                  firstChild:Container(width:250,height:250,child: Image.asset("assets/images/woman_talk.JPG"),) ,
                  secondChild:  Container(width:250,height:250,child: Lottie.asset("assets/lottie/speaking.json",repeat: _ocrttsViewModel.repeat),) ,
                  crossFadeState:
                  (_ocrttsViewModel.isFirst)? CrossFadeState.showFirst: CrossFadeState.showSecond,
                ),
                SizedBox(height: 7,),
                Expanded(
                  child: AnimatedCrossFade(
                    firstCurve: Curves.fastLinearToSlowEaseIn,
                    secondCurve: Curves.fastLinearToSlowEaseIn,
                    duration: Duration(seconds: 1),
                    firstChild:
                    Padding(padding: EdgeInsets.symmetric(vertical: 7,horizontal: 12),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black),
                            children: <TextSpan>[
                              //if(_ocrttsViewModel.spokenText !=null && _ocrttsViewModel.currentWordStart !=null)
                              TextSpan(text: _ocrttsViewModel.spokenText.substring(0,_ocrttsViewModel.currentWordStart)),
                              if(_ocrttsViewModel.currentWordStart !=null)
                                TextSpan(text: _ocrttsViewModel.spokenText.substring(_ocrttsViewModel.currentWordStart!,_ocrttsViewModel.currentWordEnd),style: TextStyle(color: Colors.white,backgroundColor: Colors.pinkAccent)),
                              if(_ocrttsViewModel.currentWordEnd !=null)
                                TextSpan(text: _ocrttsViewModel.spokenText.substring(_ocrttsViewModel.currentWordEnd!)),

                            ],)),
                    ),
                    secondChild:
                    SingleChildScrollView(
                      child: Column(children: [
                        Center(
                          child: Container(height: 250,width: 250,
                              child: (_ocrttsViewModel.pickedImage==null)?Text("Choose an image first for text recogintion"):Image.file(_ocrttsViewModel.pickedImage!)),
                        ),
                        (_ocrttsViewModel.pickedImage == null)?Text("No Images Picked yet!"):
                            //start of text recoginition
                        Padding(padding:EdgeInsets.symmetric(vertical: 22,horizontal: 26),
                            child:
                            (state is TextRecoginizedFromImageLoadingState)?
                            CircularProgressIndicator():
                            (state is TextRecoginizedFromImageSuccessState)?
                            RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(text: _ocrttsViewModel.spokenText.substring(0,_ocrttsViewModel.currentWordStart)),
                                    if(_ocrttsViewModel.currentWordStart !=null)
                                      TextSpan(text: _ocrttsViewModel.spokenText.substring(_ocrttsViewModel.currentWordStart!,_ocrttsViewModel.currentWordEnd),style: TextStyle(color: Colors.white,backgroundColor: Colors.pinkAccent)),
                                    if(_ocrttsViewModel.currentWordEnd !=null)
                                      TextSpan(text: _ocrttsViewModel.spokenText.substring(_ocrttsViewModel.currentWordEnd!)),

                                  ],)):
                            (state is CoudntRecognizeTextFromImageState)?
                            Text("Error ${state.ErrorMsg}"):
                            (state is UnExpectedErrorOccuredWhileRecoginizingTextState)?
                            Text("Error ${state.ErrorMsg}"):
                            (state is NoTextInImageState)?
                            Text("${state.ErrorMsg}"):
                            //unreachable condition
                            SizedBox()
                        )
                        // end of text recoginition
                      ],),
                    ),
                    crossFadeState: _ocrttsViewModel.isFirstWidget? CrossFadeState.showFirst: CrossFadeState.showSecond,
                  ),
                )
              ],),
          ),
        ),
          floatingActionButton:   AnimatedCrossFade(
            firstCurve: Curves.fastLinearToSlowEaseIn,
            secondCurve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(seconds: 1),
            firstChild:FloatingActionButton(
              heroTag: "btn1",
              onPressed: (){
                _ocrttsViewModel.onFirstBtnClickListener();
              },child: Icon(Icons.mic),),
            secondChild:
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: (){
                _ocrttsViewModel.dialog(context);
              },
              child: Icon(Icons.perm_media_outlined),),
            crossFadeState: _ocrttsViewModel.isFirstBtn? CrossFadeState.showFirst: CrossFadeState.showSecond,
          ), );

    });
  }





}

