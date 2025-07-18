import 'package:app/core/app_export.dart';
import 'package:app/utils/firebase_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account {
  String email;
  String Token;
  String id;
  String name;
  String picture;
  String climbingLocationId;
  bool isGym;

  Account(
      {required this.email,
      required this.Token,
      required this.id,
      required this.name,
      required this.picture,
      required this.isGym,
      required this.climbingLocationId});
}

class MultiAccountManagement {
  List<Account> accounts = [];
  late PrefUtils _prefUtils;

  MultiAccountManagement() {
    _prefUtils = Get.find<PrefUtils>();
  }

  Account? actifAccount;

  Future<MultiAccountManagement> init() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    if (_sharedPreferences.get('token') is String) {
      _sharedPreferences.clear();
      return this;
    }

    List<String> _tokens = _sharedPreferences.getStringList('token') ?? [];
    List<String> _emails = _sharedPreferences.getStringList('email') ?? [];
    List<String> _ids = _sharedPreferences.getStringList('id') ?? [];
    List<String> _names = _sharedPreferences.getStringList('name') ?? [];
    List<String> _pictures = _sharedPreferences.getStringList('picture') ?? [];
    List<String> _isGyms = _sharedPreferences.getStringList('isGym') ?? [];
    List<String> _climbingLocationIds =
        _sharedPreferences.getStringList('climbingLocationId') ?? [];
    for (int i = 0; i < _tokens.length; i++) {
      accounts.add(Account(
          name: _names[i],
          picture: _pictures[i],
          Token: _tokens[i],
          email: _emails[i],
          isGym: _isGyms[i] == 'true',
          id: _ids[i],
          climbingLocationId: _climbingLocationIds[i]));
    }
    if (accounts.isNotEmpty) {
      actifAccount = accounts.first;
    }
    return this;
  }

  void addAccount(Account account) {
    Account? accountExist = accounts.firstWhereOrNull((element) {
      return element.id == account.id;
    });
    if (accountExist != null) {
      accounts.remove(accountExist);
    }
    _prefUtils.addToken(account.Token);
    _prefUtils.addUserId(account.id.toString());
    _prefUtils.addEmail(account.email);
    _prefUtils.addIsGym(account.isGym);
    _prefUtils.addClimbingLocationId(account.climbingLocationId);
    _prefUtils.addName(account.name);
    _prefUtils.addPicture(account.picture);
    accounts.add(account);
  }

  void removeAccount() async {
    int id = accounts.indexOf(actifAccount!);
    FirebaseUtils.firebase_unsubscribeFromTopic(
        actifAccount!.climbingLocationId.toString());

    _prefUtils.removeUserId(id);
    _prefUtils.removeIsGym(id);
    _prefUtils.removeToken(id);
    _prefUtils.removeEmail(id);
    _prefUtils.removeClimbingLocationId(id);
    _prefUtils.removeName(id);
    _prefUtils.removePicture(id);
    accounts.remove(actifAccount);
  }

  void setActifAccount(String Id) {
    //set actif account
    actifAccount = accounts.firstWhere((element) => element.id == Id);

    //set actif account in first in list
    int index = accounts.indexOf(actifAccount!);
    _prefUtils.setUserIdFirstPlace(actifAccount!.id.toString(), index);
    _prefUtils.setIsGymFirstPlace(actifAccount!.isGym, index);
    _prefUtils.setTokenFirstPlace(actifAccount!.Token, index);
    _prefUtils.setEmailFirstPlace(actifAccount!.email, index);
    _prefUtils.setClimbingLocationIdFirstPlace(
        actifAccount!.climbingLocationId, index);
    _prefUtils.setNameFirstPlace(actifAccount!.name, index);
    _prefUtils.setPictureFirstPlace(actifAccount!.picture, index);
    accounts.remove(actifAccount);
    accounts.insert(0, actifAccount!);
    if (actifAccount!.climbingLocationId.isNotEmpty) {
      FirebaseUtils.firebase_subscribeToTopic(
          actifAccount!.climbingLocationId.toString());
    }
  }

  void updateClimbingLocationId(String climbingLocationId, String UserId) {
    accounts.firstWhere((element) => element.id == UserId).climbingLocationId =
        climbingLocationId;
    _prefUtils.setClimbingLocationIdFirstPlace(
        climbingLocationId, accounts.indexOf(actifAccount!));
  }
}
