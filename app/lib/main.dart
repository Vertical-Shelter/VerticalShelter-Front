import 'dart:async';

import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/data/models/other/other_api.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:app/core/app_export.dart';
import 'package:firebase_core/firebase_core.dart';
// core Flutter primitives
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:app_links/app_links.dart';

bool islogged = false;
bool isGym = false;
// TODO: Add stream controller
final _messageStreamController = BehaviorSubject<RemoteMessage>();

// TODO: Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> configureFirebase() async {
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) async {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
  });
  // TODO: Request permission
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    try {
      print(message);
      UserNewsController userNewsController = Get.find<UserNewsController>();
      userNewsController.fetchUserNews();
    } catch (e) {
      print('not init yet');
    }
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
    _messageStreamController.sink.add(message);
  });

  // TODO: Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
}

Future<void> main() async {
  Get.put(EnvConfig());
  WidgetsFlutterBinding.ensureInitialized();
  // Only call clearSavedSettings() during testing to reset internal values.
  await Upgrader.clearSavedSettings(); // REMOVE this for release builds

  await configureFirebase();
  //TODO : define environment property in initConfig
  Get.find<EnvConfig>().initConfig();
  await InitialBindings().dependencies();
  // Initialize SharedPreferences
  Account? account = Get.find<MultiAccountManagement>().actifAccount;

  // Check if session token exists
  if (account != null) {
    //   // We have a session token, add it to the Dio headers
    islogged = true;
    //clear cache

    isGym = account.isGym;
  }

  // TODO: Add app lifecycle observer

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late Upgrader up;
  Object? _err;
  String? initialRoute;
  Map<String, String> initialParameters = {};
  StreamSubscription? _streamSubscription;
  late AppLinks _appLinks;

  void initDeepLinks() {
    // 1
    _appLinks = AppLinks();

    if (!kIsWeb) {
      // 2
      _streamSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        //Close all routes
        debugPrint('Received URI: $uri');
        print('Received URI: $uri');
        trackQrCode(uri!);
        //Get the routes
        String routes = '/' + uri!.pathSegments[0] + '/' + uri.pathSegments[1];
        //Get the parameters
        Map<String, String> parameters = {};
        for (var entries in uri.queryParameters.entries) {
          parameters[entries.key] = entries.value;
        }
        parameters['deepLink'] = "true";
        Account? account = Get.find<MultiAccountManagement>().actifAccount;

        // Check if session token exists
        if (account == null) {
          //Check if the user is a gym
          Get.offAllNamed(GeneralAppRoutes.VTLogInScreenRoute,
              parameters: parameters);
          return;
        }

        //Check if climbingId in parameters
        if (parameters['climbingLocationId'] != null &&
            routes != AppRoutesVT.MainPage) {
          Get.offAllNamed(routes, parameters: parameters);

          Get.find<MultiAccountManagement>().updateClimbingLocationId(
              parameters['climbingLocationId']!,
              Get.find<MultiAccountManagement>().actifAccount!.id);
          // Get.find<VTGymController>().getGym();
        }
        if (routes == AppRoutesVT.MainPage) {
          Get.offAllNamed(routes, parameters: parameters);
        }
        setState(() {
          _err = null;
        });
        // 3
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        debugPrint('Error occurred: $err');
        setState(() {
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // <--
    super.initState();
    // _initURIHandler();
    initDeepLinks();
    if (!islogged) {
      initialRoute = GeneralAppRoutes.WelcomeScreenRoute;
    } else if (initialRoute == null) {
      islogged
          ? isGym
              ? AppRoutesVS.MainPage
              : AppRoutesVT.MainPage
          : GeneralAppRoutes.WelcomeScreenRoute;
    }
    if (initialRoute == null) {
      if (isGym) {
        initialRoute = AppRoutesVS.MainPage;
      } else {
        initialRoute = AppRoutesVT.MainPage;
      }
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: ColorsConstantDarkTheme.purple,
            selectedItemColor: ColorsConstantDarkTheme.primary,
            unselectedItemColor: ColorsConstantDarkTheme.purple,
            type: BottomNavigationBarType.shifting,
          ),
          visualDensity: VisualDensity.standard,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: ColorsConstantDarkTheme.purple,
          canvasColor: ColorsConstantDarkTheme.purple,
          snackBarTheme: SnackBarThemeData(
              contentTextStyle: TextStyle(
                  color: ColorsConstantDarkTheme.purple,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          colorScheme: ColorScheme.dark(
              secondary: ColorsConstantDarkTheme.secondary,
              tertiary: ColorsConstantDarkTheme.tertiary,
              surface: ColorsConstantDarkTheme.purple,
              surfaceContainer: ColorsConstantDarkTheme.lightPurple,
              onSurface: ColorsConstantDarkTheme.neutral_white,
              primary: ColorsConstantDarkTheme.secondary),
          textTheme: TextTheme(
            labelLarge: const TextStyle(
                fontSize: 32,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                fontFamily: 'DaxCompact'),
            labelMedium: const TextStyle(
                fontSize: 20,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                fontFamily: 'DaxCompatRegular'),
            labelSmall: const TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: FontWeight.w100,
                fontFamily: 'DaxCompatRegular'),
            bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )),
      theme: ThemeData(
          visualDensity: VisualDensity.standard,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: ColorsConstantLightTheme.background,
          canvasColor: ColorsConstantLightTheme.neutral_tab,
          snackBarTheme: SnackBarThemeData(
              contentTextStyle: TextStyle(
                  color: ColorsConstantLightTheme.neutral_white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          colorScheme: ColorScheme.light(
              background: ColorsConstantLightTheme.background,
              secondary: ColorsConstantLightTheme.secondary,
              tertiary: ColorsConstantLightTheme.tertiary,
              surface: ColorsConstantLightTheme.neutral_white,
              onTertiary: ColorsConstantLightTheme.neutral_white,
              onSurface: ColorsConstantLightTheme.neutral_black,
              primary: ColorsConstantLightTheme.primary),
          textTheme: const TextTheme(
            labelLarge: TextStyle(
                fontSize: 24,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontFamily: 'DaxCompact'),
            labelMedium: TextStyle(
                fontSize: 20,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontFamily: 'DaxCompact'),
            labelSmall: TextStyle(
                fontSize: 16,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'DaxCompact'),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )),
      themeMode: ThemeMode.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(Get.find<PrefUtils>().getLocal()),
      title: 'Vertical Shelter',
      initialBinding: InitialBindings(),
      initialRoute: initialRoute,
      getPages: AppRoutesVS.pages +
          AppRoutesVT.pages(initialParameters) +
          GeneralAppRoutes.pages,
    );
  }
}
