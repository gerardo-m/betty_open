import 'dart:io';

import 'package:betty/config.dart';

class AdmobHelper{

  static const _testing = false;

  static String get interstitialAdUnitId{
    if (_testing) {
      return _getTestInterstitialAdUnitId();
    } else {
      return _getProdInterstitialAdUnitId();
    }
  }

  static String _getProdInterstitialAdUnitId(){
    if (Platform.isAndroid){
      return Config.interstitialAdUnitId;
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  static String _getTestInterstitialAdUnitId(){
    if (Platform.isAndroid){
      return 'ca-app-pub-3940256099942544/8691691433';
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }
}