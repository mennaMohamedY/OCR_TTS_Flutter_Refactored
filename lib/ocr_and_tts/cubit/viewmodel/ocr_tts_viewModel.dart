

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:tts_refactor/ocr_and_tts/cubit/states/ocr_tts_states.dart';

import '../constants.dart';
import '../image_picker_functions.dart';

class OCRTTSViewModel extends Cubit<OCRTTSStates>{
  OCRTTSViewModel():super(OCRTTSLoadingState());

  //tts
  FlutterTts flutterTts=FlutterTts();
  Map<dynamic, dynamic> currentVoice={};
  bool repeat=true;
  double opacity=0;
  List<Map> voicesList=[];

  bool isFirst= true;
  bool isFirstBtn=true;
  bool isFirstWidget=true;
  int? currentWordStart;
  int? currentWordEnd;
  bool wentInsidetheFunction=false;
  var count=0;
  //ocr
  File? pickedImage;
  var spokenText=Constants.tts_input2;

  int flagForReload=0;


  void initTTS(){
    flutterTts.setProgressHandler((text, start, end, word) {
      //next 2 lines dol 3lshan al highlight
      currentWordStart=start;
      currentWordEnd=end;
      print("the endd 1${end}");
      print("Current state is .................................> OCRTTSRELOAdScreenState first stage ii");
      emit(OCRTTSRELOAdScreenState());
    });

    //3lshan n3ml list feha kol alvoices aly mmkn nstkhdmha
    flutterTts.getVoices.then((data) {
      try{
        voicesList=List<Map>.from(data);
        print(voicesList);

        voicesList=voicesList.where((voice) => voice["name"].contains("en")).toList();
        currentVoice=voicesList.first;
        setVoice(currentVoice);
        print("Current state is .................................> OCRTTSRELOAdScreenState first stage ii");
        emit(OCRTTSRELOAdScreenState());
      }catch(e){
        print("Error in getting list of voices ${e}");
      }
    });
  }

  void setVoice(Map voice){
    flutterTts.setVoice({"name":voice["name"],"locale": voice["locale"]});
  }

  void dialog(context){
    showDialog(context: context, builder: (context)=>AlertDialog(
      content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: ()async {
                File? temp=await ImageFunctions.cameraPicker();
                if(temp !=null){
                  pickedImage=temp;
                  count=0;
                  initTTS();
                }
                print("Current state is .................................> OCRTTSRELOAdScreenState first stage ii");
                emit(OCRTTSRELOAdScreenState());
              }, icon: Icon(Icons.camera_alt,color: Colors.pinkAccent,size: 37,)),
              Text("Camera")
            ],),
          Column(mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: ()async {
                File? temp=await ImageFunctions.galleryPicker();
                if(temp !=null){
                  pickedImage=temp;
                  count=0;
                  initTTS();
                }
                print("Current state is .................................> OCRTTSRELOAdScreenState first stage ii");
                emit(OCRTTSRELOAdScreenState());
              }, icon: Icon(Icons.perm_media_sharp,color: Colors.pinkAccent,size: 37,)),
              Text("Gallery")

            ],)
        ],),));
  }

  void onFirstBtnClickListener(){
    flutterTts.speak(spokenText);
    opacity=1;
    isFirst=false;
    flutterTts.awaitSpeakCompletion(true);
    //emit(MakeWomanTalkState());
    flutterTts.setCompletionHandler(() {
      isFirst=true;
     // talkProvider.stopTalking();
      isFirstBtn=false;
      isFirstWidget=false;
      print("Current state is .................................> OCRTTSRELOAdScreenState first stage ii");
      emit(OCRTTSRELOAdScreenState());
      //emit(MakeWomanStopTakingState());
    });
    print("Current state is .................................> OCRTTSRELOAdScreenState first stage ii");
    emit(OCRTTSRELOAdScreenState());
  }


  //on Chosing image from gallery or from camera part

  void extractText(File file,context)async {
    final textRecoginizer=TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage=InputImage.fromFile(file);
    print("Current state is .................................> TextRecoginizedFromImageLoadingState second stage ii");
    emit(TextRecoginizedFromImageLoadingState());
    try{
      final RecognizedText recognizedText=await textRecoginizer.processImage(inputImage);
      String? text=recognizedText.text;
      textRecoginizer.close();
      if(text !=null){
        //spokenText=snapshot.data.toString();
        spokenText=recognizedText.text.toString();
        print("lenggthhhh${spokenText.length}");
        print("lenggthhhh ${(spokenText==null)?"true":"false"}");

        var n=spokenText.split(" ");
        print("----------> ${n.length}");
        // _Tts.speak(spokenText);
        isFirst=true;
        //emit(MakeWomanStopTakingState());
        //emit(TextRecoginizedFromImageSuccessState());
        if(count<=n.length && spokenText.length !=0){
          flutterTts.speak(spokenText);
          isFirst=false;
          flutterTts.setProgressHandler((text, start, end, word) {
            currentWordStart=start;
            currentWordEnd=end;
            print("the endd 2${end}");
            count+=1;
            print("Current state is .................................> TextRecoginizedFromImageLoadingState second stage ii");
            emit(TextRecoginizedFromImageSuccessState());

          });
        }
        else{
          emit(NoTextInImageState(ErrorMsg: "There is No Text in the image "));
        }
        print("Current state is .................................> TextRecoginizedFromImageLoadingState second stage ii");
        //emit(TextRecoginizedFromImageSuccessState());
      }
      else{
        print("Current state is .................................> CoudntRecognizeTextFromImageState second stage iii");
        emit(CoudntRecognizeTextFromImageState( ErrorMsg: "Text Is Null"));
      }
    }
    catch(e){
      print("Current state is .................................> CoudntRecognizeTextFromImageState second stage iv");
      emit(UnExpectedErrorOccuredWhileRecoginizingTextState(ErrorMsg: "Error ${e}"));
    }

  }

  void reload(){
    emit(OCRTTSRELOAdScreenState());
  }






}