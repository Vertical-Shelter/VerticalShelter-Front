import 'package:app/core/app_export.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: must_be_immutable
class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;
  static Map<String, dynamic> _cache = {};

  Future<PrefUtils> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
    return this;
  }

  Future<void> clearPreferencesData() {
    return _sharedPreferences!.clear();
  }

  //Id

  Future<void> addUserId(String value) {
    List<String> _ids = _sharedPreferences!.getStringList('id') ?? [];
    _ids.add(value);
    return _sharedPreferences!.setStringList('id', _ids);
  }

  Future<void> removeUserId(int index) {
    List<String> _ids = _sharedPreferences!.getStringList('id') ?? [];
    _ids.removeAt(index);
    return _sharedPreferences!.setStringList('id', _ids);
  }

  Future<void> setUserIdFirstPlace(String value, int index) {
    List<String> _ids = _sharedPreferences!.getStringList('id') ?? [];

    _ids.removeAt(index);
    _ids.insert(0, value);
    return _sharedPreferences!.setStringList('id', _ids);
  }

  //local
  Future<void> addLocal(String value) async {
    _sharedPreferences!.setString('local', value);
  }

  String getLocal() {
    return _sharedPreferences!.getString('local') ??
        Get.deviceLocale!.languageCode;
  }

  //Token
  Future<void> addToken(String value) {
    List<String> _tokens = _sharedPreferences!.getStringList('token') ?? [];
    _tokens.add(value);
    return _sharedPreferences!.setStringList('token', _tokens);
  }

  Future<int> removeToken(int index) async {
    List<String> _tokens = _sharedPreferences!.getStringList('token') ?? [];
    _tokens.removeAt(index);
    await _sharedPreferences!.setStringList('token', _tokens);
    return index;
  }

  Future<void> setTokenFirstPlace(String value, int index) {
    List<String> _tokens = _sharedPreferences!.getStringList('token') ?? [];
    _tokens.removeAt(index);
    _tokens.insert(0, value);
    return _sharedPreferences!.setStringList('token', _tokens);
  }

  //Email

  Future<void> addEmail(String value) {
    List<String> _emails = _sharedPreferences!.getStringList('email') ?? [];
    _emails.add(value);
    return _sharedPreferences!.setStringList('email', _emails);
  }

  Future<void> removeEmail(int index) async {
    List<String> _emails = _sharedPreferences!.getStringList('email') ?? [];
    _emails.removeAt(index);
    await _sharedPreferences!.setStringList('email', _emails);
  }

  Future<void> setEmailFirstPlace(String value, int index) {
    List<String> _emails = _sharedPreferences!.getStringList('email') ?? [];
    _emails.removeAt(index);
    _emails.insert(0, value);
    return _sharedPreferences!.setStringList('email', _emails);
  }

  //ClimbingLocationId

  Future<void> addClimbingLocationId(String value) {
    List<String> _ids =
        _sharedPreferences!.getStringList('climbingLocationId') ?? [];
    _ids.add(value.toString());
    return _sharedPreferences!.setStringList('climbingLocationId', _ids);
  }

  Future<void> removeClimbingLocationId(int index) {
    List<String> _ids =
        _sharedPreferences!.getStringList('climbingLocationId') ?? [];
    _ids.removeAt(index);
    return _sharedPreferences!.setStringList('climbingLocationId', _ids);
  }

  Future<void> setClimbingLocationIdFirstPlace(String id, int index) {
    List<String> _ids =
        _sharedPreferences!.getStringList('climbingLocationId') ?? [];
    _ids.removeAt(index);
    _ids.insert(0, id.toString());
    return _sharedPreferences!.setStringList('climbingLocationId', _ids);
  }

  //name

  Future<void> addName(String value) {
    List<String> _names = _sharedPreferences!.getStringList('name') ?? [];
    _names.add(value);
    return _sharedPreferences!.setStringList('name', _names);
  }

  Future<void> removeName(int index) {
    List<String> _names = _sharedPreferences!.getStringList('name') ?? [];
    _names.removeAt(index);
    return _sharedPreferences!.setStringList('name', _names);
  }

  Future<void> setNameFirstPlace(String value, int index) {
    List<String> _names = _sharedPreferences!.getStringList('name') ?? [];
    _names.removeAt(index);
    _names.insert(0, value);
    return _sharedPreferences!.setStringList('name', _names);
  }

  //picture

  Future<void> addPicture(String value) {
    List<String> _pictures = _sharedPreferences!.getStringList('picture') ?? [];
    _pictures.add(value);
    return _sharedPreferences!.setStringList('picture', _pictures);
  }

  Future<void> removePicture(int index) {
    List<String> _pictures = _sharedPreferences!.getStringList('picture') ?? [];
    _pictures.removeAt(index);
    return _sharedPreferences!.setStringList('picture', _pictures);
  }

  Future<void> setPictureFirstPlace(String value, int index) {
    List<String> _pictures = _sharedPreferences!.getStringList('picture') ?? [];
    _pictures.removeAt(index);
    _pictures.insert(0, value);
    return _sharedPreferences!.setStringList('picture', _pictures);
  }

  //isGym

  Future<void> addIsGym(bool value) {
    List<String> _isGym = _sharedPreferences!.getStringList('isGym') ?? [];
    _isGym.add(value.toString());
    return _sharedPreferences!.setStringList('isGym', _isGym);
  }

  Future<void> removeIsGym(int index) {
    List<String> _isGym = _sharedPreferences!.getStringList('isGym') ?? [];
    _isGym.removeAt(index);
    return _sharedPreferences!.setStringList('isGym', _isGym);
  }

  Future<void> setIsGymFirstPlace(bool value, int index) {
    List<String> _isGym = _sharedPreferences!.getStringList('isGym') ?? [];
    _isGym.removeAt(index);
    _isGym.insert(0, value.toString());
    return _sharedPreferences!.setStringList('isGym', _isGym);
  }

  void setGradeSystem(List<GradeResp> value) {
    _cache['gradeSystem'] = value;
    return;
  }

  // ADS
  //TODO : if payed remove ads

  // increment  umber of wall for ads
  int getNumberOfWallForAds() {
    try {
      return _sharedPreferences!.getInt('numberOfWallForAds') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  int setNumberOfWallForAds() {
    int value = getNumberOfWallForAds() + 1;
    value = value % 3;
    _sharedPreferences!.setInt('numberOfWallForAds', value);
    return value;
  }

  List<GradeResp> getGradeSystem() {
    try {
      return _cache['gradeSystem'];
    } catch (e) {
      return [];
    }
  }

  bool hasFCM() {
    return _sharedPreferences!.containsKey('fcm');
  }

  Future<void> setFCM(String value) {
    if (hasFCM()) {
      _sharedPreferences!.remove('fcm');
    }
    return _sharedPreferences!.setString('fcm', value);
  }

  bool hasMembership() {
    return _sharedPreferences!.containsKey('hasMembership') &&
        _sharedPreferences!.getBool('hasMembership')!;
  }

  Future<void> setMembership(bool value) {
    if (hasMembership()) {
      _sharedPreferences!.remove('hasMembership');
    }
    return _sharedPreferences!.setBool('hasMembership', value);
  }
}
