import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static SharedPreferences sharedPrefernces;

  static init() async
  {
    sharedPrefernces = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    @required String key,
    @required bool value,
  })async
  {
    return await sharedPrefernces.setBool(key,value );
  }

  static bool getBoolean({
    @required String key,

  })
  {
    return sharedPrefernces.getBool(key);
  }
}