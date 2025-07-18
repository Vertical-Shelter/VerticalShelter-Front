import 'package:app/Vertical-Setting/BottomBar/bottomBarScreen.dart';
import 'package:app/Vertical-Setting/GymNews/gymNewsBinding.dart';
import 'package:app/Vertical-Setting/GymNews/gymNewsScreen.dart';
import 'package:app/Vertical-Setting/Wall/wallBinding.dart';
import 'package:app/Vertical-Setting/Wall/wallScreen.dart';
import 'package:app/Vertical-Setting/SprayWallManagmenent/SprayWallManagementBinding.dart';
import 'package:app/Vertical-Setting/SprayWallManagmenent/SprayWallManagementScreen.dart';
import 'package:app/Vertical-Setting/createWall/createWallBinding.dart';
import 'package:app/Vertical-Setting/createWall/createWallScreen.dart';
import 'package:app/Vertical-Setting/editSecteur/editSecteurBinding.dart';
import 'package:app/Vertical-Setting/editSecteur/editSecteurScreen.dart';
import 'package:get/get.dart';
import 'package:app/Vertical-Setting/bottomBar/bottomBarBinding.dart';

class AppRoutesVS {
  static const String LogInScreenRoute = '/app/vs_log_in_screen';

  static const String WallScreenRoute = '/app/vs_wall_screen';

  static const String CreateWallScreenRoute = '/app/vs_create_wall_screen';
  static const String createSprayWallScreen =
      '/app/vs_create_spray_wall_screen';
  static const String myActivityScreen = '/app/vs_my_activity_screen';
  static const String MainPage = '/app/vs_main_page';

  static const String SettingScreenRoute = '/app/vs_setting_screen';

  static const String EditWallScreenRoute = '/app/vs_edit_wall_screen';

  static const String EditSecteurScreenRoute = '/app/vs_edit_secteur_screen';

  static const String notificationScreen = '/app/vs_notification_screen';

  static List<GetPage> pages = [
    GetPage(
        name: notificationScreen,
        page: () => ClimbingLocationNewsScreen(),
        binding: ClimbingLocationNewsBinding(),
        transition: Transition.noTransition),
    GetPage(
        name: EditSecteurScreenRoute,
        page: () => VSEditSecteurScreen(),
        binding: VSEditSecteurBinding(),
        transition: Transition.noTransition),
    GetPage(
        name: WallScreenRoute,
        page: () => VSWallScreen(),
        binding: VSWallBinding(),
        transition: Transition.noTransition),
    GetPage(
        name: createSprayWallScreen,
        page: () => SprayWallManagementScreen(),
        binding: SprayWallManagementBinding(),
        transition: Transition.noTransition),
    GetPage(
        name: MainPage,
        page: () => VSBottomBarScreen(),
        binding: VSBottomBarBinding()),
    GetPage(
      name: CreateWallScreenRoute,
      page: () => VSCreateWallScreen(),
      bindings: [
        VSCreateWallBinding(),
      ],
      transition: Transition.noTransition,
    ),
  ];
}
