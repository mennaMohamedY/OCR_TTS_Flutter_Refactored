
abstract class OCRTTSStates{}
class OCRTTSLoadingState extends OCRTTSStates{}
class OCRTTSRELOAdScreenState extends OCRTTSStates{}
class MakeWomanTalkState extends OCRTTSStates{
  bool isFirst=true;
  //MakeWomanTalkState({required this.isFirst});
}
class MakeWomanStopTakingState extends OCRTTSStates{
  bool isFirst=false;
//MakeWomanTalkState({required this.isFirst});
}

//on Chosing image from gallery or from camera part
class TextRecoginizedFromImageLoadingState extends OCRTTSStates{}
class TextRecoginizedFromImageSuccessState extends OCRTTSStates{}
class CoudntRecognizeTextFromImageState extends OCRTTSStates{
  String ErrorMsg;
  CoudntRecognizeTextFromImageState({required this.ErrorMsg});
}
class NoTextInImageState extends OCRTTSStates{
  String ErrorMsg;
  NoTextInImageState({required this.ErrorMsg});
}

class UnExpectedErrorOccuredWhileRecoginizingTextState extends OCRTTSStates{
  String ErrorMsg;
  UnExpectedErrorOccuredWhileRecoginizingTextState({required this.ErrorMsg});
}