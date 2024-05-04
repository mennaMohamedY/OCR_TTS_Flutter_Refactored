
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tts_refactor/ocr_and_tts/cubit/states/ocr_tts_states.dart';
import 'package:tts_refactor/ocr_and_tts/cubit/viewmodel/ocr_tts_viewModel.dart';


class TextRecoginitionWidget extends StatelessWidget {

  OCRTTSViewModel _ocrttsViewModel=OCRTTSViewModel();
  File file;
  TextRecoginitionWidget({required this.file});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<OCRTTSViewModel,OCRTTSStates>(
      bloc: _ocrttsViewModel..extractText(file),
        builder: (context,state){
        print("widet screen is built");
          return  Padding(padding:EdgeInsets.symmetric(vertical: 22,horizontal: 26),
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
          );
        });
  }


}
/*
return Padding(padding:EdgeInsets.symmetric(vertical: 22,horizontal: 26),
            child:RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: "${_ocrttsViewModel.spokenText}"),
                    if(_ocrttsViewModel.spokenText !=null &&_ocrttsViewModel.currentWordStart !=null )
                      TextSpan(text: _ocrttsViewModel.spokenText.substring(0,_ocrttsViewModel.currentWordStart)),
                    if(_ocrttsViewModel.currentWordStart !=null)
                      TextSpan(text: _ocrttsViewModel.spokenText.substring(_ocrttsViewModel.currentWordStart!,_ocrttsViewModel.currentWordEnd),style: TextStyle(color: Colors.white,backgroundColor: Colors.pinkAccent)),
                    if(_ocrttsViewModel.currentWordEnd !=null)
                      TextSpan(text: _ocrttsViewModel.spokenText.substring(_ocrttsViewModel.currentWordEnd!)),

                  ],))
        );
 */

