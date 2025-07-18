import 'package:app/core/app_export.dart';

import 'package:app/core/utils/progress_dialog_utils.dart';
import 'package:app/data/models/FCMManager/apiFCM.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/appleSigninReq.dart';
import 'package:app/data/models/User/googleSignInReq.dart';
import 'package:app/data/models/login/api.dart';
import 'package:app/data/models/login/post_login_req.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/firebase_utils.dart';
import 'package:app/data/models/login/post_login_resp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInController extends GetxController {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Rx<bool> isShowPassword = false.obs;
  String? loginError;
  String? passwordError;
  RxBool isLoading = false.obs;

  PostLoginResp postLoginResp = PostLoginResp();
  GoogleSignInAccount? _currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: 'your-client_id.apps.googleusercontent.com',0
      );
  @override
  void onReady() {
    _googleSignIn.isSignedIn().then((isSignedIn) {
      if (isSignedIn) {
        _googleSignIn.disconnect();
      } else {}
    });

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...

      _currentUser = account;
    });
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> Login() async {
    bool hasError = false;
    if (emailController.text.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailController.text)) {
      hasError = true;
      loginError = 'Invalid email. Please try again.';
    }
    if (passwordController.text.isEmpty) {
      hasError = true;
      passwordError = 'Invalid password. Please try again.';
    }
    if (hasError) {
      return;
    }
    PostLoginReq postLoginReq = PostLoginReq(
        email: emailController.text, password: passwordController.text);
    try {
      await callCreateLogin(
        postLoginReq,
      );
    } on PostLoginResp catch (e) {
      _onLoginError(e);
    } on NoInternetException catch (e) {
      Get.rawSnackbar(message: e.toString());
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
  }

  void _onLoginError(PostLoginResp e) {
    loginError = e.error?['email'];
    passwordError = e.error?['password'];
  }

  Future<void> handleGoogleSignin() async {
    try {
      isLoading.value = true;
      FirebaseAuth auth = FirebaseAuth.instance;

      User? user;
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        postLoginResp = await signInGoogle(GoogleSignInReq(user: user!));
        _handleCreateLoginSuccess();
      }
      isLoading.value = false;
    } catch (error) {
      print(error);
      isLoading.value = false;
    }
  }

  Future<void> callCreateLogin(PostLoginReq req) async {
    ProgressDialogUtils.showProgressDialog(text: '');
    try {
      postLoginResp = await loginAPI(req);
      if (postLoginResp.error != null) {
        ProgressDialogUtils.hideProgressDialog();

        loginError = postLoginResp.error!['email'];
        passwordError = postLoginResp.error!['password'];
        return;
      }
      _handleCreateLoginSuccess();
      ProgressDialogUtils.hideProgressDialog();
    } on PostLoginResp catch (e) {
      postLoginResp = e;
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    } on Exception catch (e) {
      ProgressDialogUtils.hideProgressDialog();

      rethrow;
    }
  }

  void _handleCreateLoginSuccess() async {
    Get.find<MultiAccountManagement>().addAccount(Account(
      id: postLoginResp.userId!,
      Token: postLoginResp.access_token!,
      name: postLoginResp.name!,
      isGym: postLoginResp.isGym!,
      picture: postLoginResp.picture ?? '',
      email: emailController.text,
      climbingLocationId: postLoginResp.climbingLocation ?? '',
    ));
    Get.find<MultiAccountManagement>().setActifAccount(postLoginResp.userId!);
    sendFCMToServer();
    if (postLoginResp.isGym == true) {
      Get.offAllNamed(AppRoutesVS.MainPage);
    } else {
      Map<String, String> params = {};
      if (Get.parameters['climbingLocationId'] != null) {
        params['climbingLocationId'] = Get.parameters['climbingLocationId']!;
      }
      if (Get.parameters['secteurName'] != null) {
        params['secteurName'] = Get.parameters['secteurName']!;
      }
      Get.offAllNamed(
        AppRoutesVT.MainPage,
        parameters: params,
      );
      FirebaseUtils.firebase_subscribeToTopic(
          postLoginResp.climbingLocation.toString());
    }
  }

  Future<void> handleAppleSignin() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      print("userCredential");
      final UserCredential userCredential =
          await auth.signInWithProvider(AppleAuthProvider());

      print("user");
      User? user = userCredential.user;

      print(user!.uid);

      // ignore: avoid_print
      print("__");

      AppleSigninreq appleSigninreq = AppleSigninreq(
          uid: user!.uid,
          displayName: user.displayName ?? '',
          photoUrl: user.photoURL ?? '',
          email: user.emailVerified ? user.email! : '');

      PostLoginResp userResp = await signInApple(appleSigninreq);
      print(userResp);
      _handleCreateLoginSuccess();
      print("userResp");
    } catch (error) {
      print(error);
    }
    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    // ignore: avoid_print
    // print("Sessions ${session.body}");
  }
}
