// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

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

/// The scopes required by this application.
// #docregion Initialize

GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',0
    );
// #enddocregion Initialize

/// The SignInDemo app.
class WelcomeScreen extends StatefulWidget {
  ///
  const WelcomeScreen({super.key});

  @override
  State createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    //check if user is already signed in
    _googleSignIn.isSignedIn().then((isSignedIn) {
      if (isSignedIn) {
        print('already signed in');
        _googleSignIn.disconnect();
      } else {
        print('not signed in');
      }
    });
  }

  Future<void> _handleGoogleSignin() async {
    try {
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
        print(user);
        PostLoginResp userResp =
            await signInGoogle(GoogleSignInReq(user: user!));
        _handleCreateLoginSuccess(userResp, user.email ?? '');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleAppleSignin() async {
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
      _handleCreateLoginSuccess(userResp, user.email ?? '');
      print("userResp");
    } catch (error) {
      print(error);
    }
    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    // ignore: avoid_print
    // print("Sessions ${session.body}");
  }

  void _handleCreateLoginSuccess(
      PostLoginResp postLoginResp, String email) async {
    print('handleCreateLoginSuccess');
    Get.find<MultiAccountManagement>().addAccount(Account(
      id: postLoginResp.userId!,
      Token: postLoginResp.access_token!,
      name: postLoginResp.name!,
      isGym: postLoginResp.isGym!,
      picture: postLoginResp.picture ?? '',
      email: email,
      climbingLocationId: postLoginResp.climbingLocation ?? '',
    ));
    print('setActifAccount');
    Get.find<MultiAccountManagement>().setActifAccount(postLoginResp.userId!);
    print('sendFCMToServer');
    sendFCMToServer();
    if (postLoginResp.isGym == true) {
      Get.offAllNamed(AppRoutesVS.MainPage);
    } else {
      Get.offAllNamed(AppRoutesVT.MainPage);
    }
  }

  onTapLoginVS() {
    Get.toNamed(AppRoutesVS.LogInScreenRoute);
  }

  onTapLoginVT() {
    Get.toNamed(GeneralAppRoutes.VTLogInScreenRoute);
  }

  onTapRegister() {
    Get.toNamed(GeneralAppRoutes.RegisterScreenRoute);
  }

  onContacUsTap(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Theme.of(context).colorScheme.surface,
            ),
            padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
            child: Scaffold(
                primary: false,
                backgroundColor: Colors.transparent,
                body: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    height: 8,
                    width: width * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  SizedBox(height: 10),
                  Text(AppLocalizations.of(context)!.contactez_nous,
                      style: Theme.of(context).textTheme.bodyMedium!),
                  SizedBox(height: 20),
                  Row(children: [
                    IconButton(
                        icon: Icon(
                          Icons.mail,
                          size: 20,
                        ),
                        onPressed: () {
                          final Uri mailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'contact@verticalshelter.fr');
                          launchUrl(mailLaunchUri);
                        }),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 0))),
                        onLongPress: () {
                          Clipboard.setData(ClipboardData(
                              text: 'contact@verticalshelter.fr'));
                          HapticFeedback.vibrate();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              margin: EdgeInsets.only(
                                  bottom: 20, left: 20, right: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              behavior: SnackBarBehavior.floating,
                              content: Text(AppLocalizations.of(context)!
                                  .adresse_copie_dans_le_presse_papier)));
                        },
                        onPressed: () {
                          final Uri mailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'contact@verticalshelter.fr');
                          launchUrl(mailLaunchUri);
                        },
                        child: Text('contact@verticalshelter.fr',
                            style: Theme.of(context).textTheme.bodyMedium!)),
                    //Button to copy adress
                  ]),
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    IconButton(
                        icon: Icon(FontAwesomeIcons.whatsapp, size: 20),
                        onPressed: () async {
                          var contact = "XXXXXXXXXXX"; // Replace with the actual contact number
                          var androidUrl =
                              "whatsapp://send?phone=$contact&text=";
                          var iosUrl = "https://wa.me/$contact?text=";

                          try {
                            if (Platform.isIOS) {
                              await launchUrl(Uri.parse(iosUrl));
                            } else {
                              await launchUrl(Uri.parse(androidUrl));
                            }
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 1),
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                margin: EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                behavior: SnackBarBehavior.floating,
                                content: Text(AppLocalizations.of(context)!
                                    .whatsapp_non_disponible)));
                          }
                        }),
                    TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 0))),
                      child: Text('+33 6 51 96 02 56',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyMedium!),
                      onLongPress: () {
                        print('long press');
                        Clipboard.setData(
                            ClipboardData(text: '+33 6 51 96 02 56'));
                        HapticFeedback.vibrate();
                        SystemSound.play(SystemSoundType.click);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1),
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            margin: EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            behavior: SnackBarBehavior.floating,
                            content: Text(AppLocalizations.of(context)!
                                .numero_copie_dans_le_presse_papier)));
                      },
                      onPressed: () async {
                        var contact = "+33651960256";
                        var androidUrl = "whatsapp://send?phone=$contact&text=";
                        var iosUrl = "https://wa.me/$contact?text=";

                        try {
                          if (Platform.isIOS) {
                            await launchUrl(Uri.parse(iosUrl));
                          } else {
                            await launchUrl(Uri.parse(androidUrl));
                          }
                        } on Exception {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              margin: EdgeInsets.only(
                                  bottom: 20, left: 20, right: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              behavior: SnackBarBehavior.floating,
                              content: Text(AppLocalizations.of(context)!
                                  .whatsapp_non_disponible)));
                        }
                      },
                    ),
                    //Button to copy phone number
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    //Button to copy phone number
                    IconButton(
                        icon: Icon(FontAwesomeIcons.instagram, size: 20),
                        onPressed: () async {
                          var nativeUrl =
                              "instagram://user?username=verticalshelter";
                          var webUrl =
                              "https://www.instagram.com/verticalshelter";

                          try {
                            await launchUrlString(nativeUrl,
                                mode: LaunchMode.externalApplication);
                          } catch (e) {
                            print(e);
                            await launchUrlString(webUrl,
                                mode: LaunchMode.platformDefault);
                          }
                        }),
                    TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 0))),
                      child: Text(
                          AppLocalizations.of(context)!
                              .rejoingez_la_team_VS_sur_instagram,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyMedium!),
                      onPressed: () async {
                        var nativeUrl =
                            "instagram://user?username=verticalshelter";
                        var webUrl =
                            "https://www.instagram.com/verticalshelter";

                        try {
                          await launchUrlString(nativeUrl,
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          print(e);
                          await launchUrlString(webUrl,
                              mode: LaunchMode.platformDefault);
                        }
                      },
                    ),
                  ]),
                  SizedBox(height: 10),
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: BuildWhenSingleAccount(context),
    ));
  }

  Widget BuildWhenMultipleAccount(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SvgPicture.asset(
            'assets/newIcons/logo.svg',
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary, BlendMode.srcIn),
          ),
          Spacer(),
          Container(
              // color: Colors.amber,
              width: width,
              constraints: BoxConstraints(
                maxHeight: height * 0.3,
                minHeight: 0,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Account account =
                      Get.find<MultiAccountManagement>().accounts[index];

                  return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.only(
                          bottom: height * 0.02,
                          left: width * 0.04,
                          right: width * 0.04),
                      child: ProfileMiniAccount(
                        id: account.id,
                        isGym: account.isGym,
                        name: account.name,
                        image: account.picture,
                        onTap: () {
                          Get.find<MultiAccountManagement>().actifAccount =
                              account;
                          account.isGym
                              ? Get.offAllNamed(AppRoutesVS.MainPage)
                              : Get.offAllNamed(AppRoutesVT.MainPage);
                        },
                      ));
                },
                itemCount: 2,
              )),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.onSurface,
              )),
              SizedBox(
                width: width * 0.02,
              ),
              Text(
                'Ou',
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Expanded(
                  child: Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.onSurface,
              )),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: onTapLoginVT,
              child: Text(AppLocalizations.of(context)!.se_connecter,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ))),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.vous_navez_pas_de_compte,
              ),
              TextButton(
                  onPressed: onTapRegister,
                  child: Text(AppLocalizations.of(context)!.s_inscrire,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ))),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }

  Widget BuildWhenSingleAccount(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SvgPicture.asset(
            'assets/newIcons/logo.svg',
            width: width * 0.5,
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary, BlendMode.srcIn),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Vertical Shelter",
              style: Theme.of(context).textTheme.labelLarge),
          Spacer(),
          ButtonWidget(
            onPressed: _handleGoogleSignin,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(FontAwesomeIcons.google,
                  color: Theme.of(context).colorScheme.surface, size: 25),
              SizedBox(
                width: 10,
              ),
              Text(AppLocalizations.of(context)!.googleConnection,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.surface))
            ]),
          ),
          if (Platform.isIOS) SizedBox(height: height * 0.02),
          if (Platform.isIOS)
            ButtonWidget(
              onPressed: _handleAppleSignin,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(FontAwesomeIcons.apple,
                    color: Theme.of(context).colorScheme.surface, size: 25),
                SizedBox(
                  width: 10,
                ),
                Text(AppLocalizations.of(context)!.apple_connection,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.surface))
              ]),
            ),
          SizedBox(
            height: height * 0.02,
          ),
          ButtonWidget(
              onPressed: onTapLoginVT,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.mail_outline, size: 25),
                SizedBox(
                  width: 10,
                ),
                Text(AppLocalizations.of(context)!.emailConnection),
              ])),
          Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              AppLocalizations.of(context)!.isGymQuestion,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextButton(
                onPressed: () => onContacUsTap(context),
                child: Text(AppLocalizations.of(context)!.contactez_nous,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )))
          ]),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
