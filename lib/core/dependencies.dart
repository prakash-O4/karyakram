import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  SharedPrefs._internal();

  static SharedPrefs get instance => SharedPrefs._internal();

  static Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String? get token => _sharedPrefs?.getString('token');

  setToken(String? value) async =>
      await _sharedPrefs?.setString('token', value ?? '');

  String? get userId => _sharedPrefs?.getString('userId');

  setUserId(String? value) async =>
      await _sharedPrefs?.setString('userId', value ?? '');

  // logout
  Future<bool> logout() async {
    return await _sharedPrefs?.clear() ?? false;
  }
}
