import 'dart:async';
import 'dart:io';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/FCMManager/apiFCM.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/appleSigninReq.dart';
import 'package:app/data/models/User/googleSignInReq.dart';
import 'package:app/data/models/login/post_login_resp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/profil/profilMiniAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeController extends GetxController {
 


}
