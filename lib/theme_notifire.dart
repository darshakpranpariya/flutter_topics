import 'package:flutter/material.dart';

class ThemeNotifire extends ChangeNotifier{
  ThemeData _themeData;

  ThemeNotifire(this._themeData);

  getTheme(){
    return _themeData;
  }

  setTheme(ThemeData td){
    _themeData = td;
    notifyListeners();
  }
}