import 'package:app/Vertical-Tracking/BottomBar/bottomBarScreen.dart';
import 'package:app/Vertical-Tracking/CreateBlocSprayWall/CreateBlocBinding.dart';
import 'package:app/Vertical-Tracking/CreateBlocSprayWall/SelectHolds.dart';
import 'package:app/Vertical-Tracking/MyStats/progressionScreen.dart';

import 'package:app/Vertical-Tracking/VSL/TeamDescription/decriptionTeamBinder.dart';
import 'package:app/Vertical-Tracking/VSL/TeamDescription/descriptionTeamScreen.dart';
import 'package:app/Vertical-Tracking/VSL/createTeam/createTeamBinding.dart';
import 'package:app/Vertical-Tracking/VSL/createTeam/createTeamScreen.dart';
import 'package:app/Vertical-Tracking/VSL/descriptionVSL/descriptionVslBinding.dart';
import 'package:app/Vertical-Tracking/VSL/descriptionVSL/descriptionVslScreen.dart';
import 'package:app/Vertical-Tracking/VSL/joinTeam/joinTeamBinding.dart';
import 'package:app/Vertical-Tracking/VSL/joinTeam/selectTeamScreen.dart';
import 'package:app/Vertical-Tracking/SprayWall/sprayWallBinding.dart';
import 'package:app/Vertical-Tracking/SprayWall/sprayWallScreen.dart';
import 'package:app/Vertical-Tracking/contest/ContestFile/contestFile.dart';
import 'package:app/Vertical-Tracking/contest/ContestFile/contestFileBinding.dart';
import 'package:app/Vertical-Tracking/contest/ContestList/contestBinding.dart';
import 'package:app/Vertical-Tracking/contest/ContestList/contestScreen.dart';
import 'package:app/Vertical-Tracking/MyStats/progressionBinding.dart';
import 'package:app/Vertical-Tracking/Setting/setting_binding.dart';
import 'package:app/Vertical-Tracking/Setting/setting_screen.dart';
import 'package:app/Vertical-Tracking/Ranking/RankingBinding.dart';
import 'package:app/Vertical-Tracking/UserProfile/userProfile_binding.dart';
import 'package:app/Vertical-Tracking/UserProfile/userProfile_screen.dart';
import 'package:app/Vertical-Tracking/changeClimbingGym/ChangeClimbingLocScreen.dart';
import 'package:app/Vertical-Tracking/changeClimbingGym/changeClimbingLocBinding.dart';
import 'package:app/Vertical-Tracking/contest/contestRanking/contestRankingBinding.dart';
import 'package:app/Vertical-Tracking/contest/contestRanking/contestRankingFile.dart';
import 'package:app/Vertical-Tracking/createWallAmbassadeur/createWallBinding.dart';
import 'package:app/Vertical-Tracking/createWallAmbassadeur/createWallScreen.dart';
import 'package:app/Vertical-Tracking/editSecteurAmbassadeur/editSecteurBinding.dart';
import 'package:app/Vertical-Tracking/editSecteurAmbassadeur/editSecteurScreen.dart';
import 'package:app/Vertical-Tracking/edit_profil_screen/edit_profil_binding.dart';
import 'package:app/Vertical-Tracking/edit_profil_screen/edit_profil_screen.dart';

import 'package:app/Vertical-Tracking/Wall/wallBinding.dart';
import 'package:app/Vertical-Tracking/Wall/wallScreen.dart';
import 'package:app/Vertical-Tracking/bottomBar/bottomBarBinding.dart';
import 'package:app/Vertical-Tracking/news/NewsFile/newsFileBinding.dart';
import 'package:app/Vertical-Tracking/news/NewsFile/newsFileScreen.dart';
import 'package:app/Vertical-Tracking/news/UserNews/userNewsBinding.dart';
import 'package:app/Vertical-Tracking/news/UserNews/userNewsScreen.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsBinding.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsList.dart';
import 'package:app/Vertical-Tracking/profil/profilBinding.dart';
import 'package:app/core/app_export.dart';

class AppRoutesVT {
  static const String changeClimbingLoc = '/app/vt_change_climbing_loc';

  static const String WallScreenRoute = '/app/vt_wall_screen';

  static const String NewsRoute = '/app/news_List';
  static const String editWallAmbassador = '/app/edit_wall_ambassador';
  static const String newsDetailsRoute = '/app/news_details';
  static const String createWallAmbasseur = '/app/create_wall_ambassadeur';
  static const String appNavigationScreen = '/app/app_navigation_screen';
  static const String contestList = '/app/contest_list';
  static const String contestDetaiil = '/app/contest_detail';
  static const String EditProfileScreenRoute = '/app/edit_profil_screen';
  static const String myActivityScreen = '/app/my_activity_screen';
  static const String myStatsScreen = '/app/my_stats_screen';
  static const String MainPage = '/app/vt_main_page';
  static const String userNewsScreen = '/app/user_news_screen';
  static const String UserProfileScreenRoute = '/app/userprofile_screen';

  static const String FriendListScreenRoute = '/app/friendlist_screen';
  static const String avatarScreenRoute = '/app/avatar_screen';
  static const String baniereScreenRoute = '/app/baniere_screen';
  static const String SettingScreenRoute = '/app/setting_screen';
  static const String shopScreenRoute = '/app/shop_screen';
  static const String gymScreen = '/app/gym_screen';
  static const String sprayWallScreen = '/app/spray_wall_screen';

  static const String statScreen = '/app/stat_screen';

  static const String contestRankingScreen = '/app/contest_ranking_screen';
  static const String seasonPassScreenRoute = '/app/season_pass_screen';
  static const String spQuestsScreenRoute = '/app/spQuests_screen';

  static const String badgeScreen = '/app/badge_screen';
  static const String createBlocSprayWall = '/create_bloc_spray_wall';

  static const String createTeamScreen = '/app/createTeamScreen';
  static const String joinTeamScreen = '/app/joinTeamScreen';
  static const String descriptionVSL = '/app/descriptionVSL';
  static const String descriptionTeamScreen = '/app/decriptionTeamScreen';

  static List<GetPage> pages(Map<String, String> parameters) {
    return [
      GetPage(
          name: sprayWallScreen,
          page: () => SprayWallDetailScreen(),
          binding: SprayWallbinding(),
          transition: Transition.noTransition),
      GetPage(
          name: contestRankingScreen,
          parameters: parameters,
          page: () => ContestRankingFile(),
          binding: ContestRankingBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: descriptionVSL,
          page: () => DescriptionVslScreen(),
          binding: DescriptionVslBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: createWallAmbasseur,
          parameters: parameters,
          page: () => CreateWallAmbassadeurScreen(),
          transition: Transition.noTransition,
          binding: CreateWallAmbassadeurBinding()),
      GetPage(
          name: changeClimbingLoc,
          parameters: parameters,
          page: () => VTChangeClimbingLocScreen(),
          binding: VTChangeClimbingLocBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: contestDetaiil,
          parameters: parameters,
          page: () => ContestFile(),
          binding: ContestFileBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: userNewsScreen,
          page: () => UserNewsScreen(),
          parameters: parameters,
          binding: UserNewsBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: statScreen,
          page: () => ProgressionScreen(),
          parameters: parameters,
          binding: ProgressionBindings(),
          transition: Transition.noTransition),
      GetPage(
          name: newsDetailsRoute,
          parameters: parameters,
          page: () => NewsDetailsScreen(),
          binding: NewsDetailsBinding(),
          transition: Transition.noTransition),
    
      GetPage(
          name: contestRankingScreen,
          page: () => ContestRankingFile(),
          binding: ContestRankingBinding(),
          transition: Transition.noTransition),
      GetPage(
        name: NewsRoute,
        page: () => NewsListScreen(),
        parameters: parameters,
        bindings: [
          NewsListBinding(),
        ],
        transition: Transition.noTransition,
      ),
      GetPage(
          name: contestList,
          page: () => ContestList(),
          parameters: parameters,
          binding: ContestBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: editWallAmbassador,
          page: () => EditSecteurAmabassadeurScreen(),
          parameters: parameters,
          transition: Transition.noTransition,
          binding: EditSecteurAmabassadeurBinding()),
      GetPage(
          name: WallScreenRoute,
          page: () => VTWallScreen(),
          binding: VTWallBinding(),
          parameters: parameters,
          transition: Transition.noTransition),
      GetPage(
          name: EditProfileScreenRoute,
          page: () => VTEditProfilScreen(),
          parameters: parameters,
          binding: VTEditProfilBinding(),
          transition: Transition.noTransition),
      GetPage(
        name: MainPage,
        parameters: parameters,
        page: () => VTBottomBarScreen(),
        bindings: [
          VTBottomBarBinding(),
          ProgressionBindings(),
          VTProfilBinding(),
          RankingBindings()
        ],
      ),
      GetPage(
        name: UserProfileScreenRoute,
        page: () => VTUserProfileScreen(),
        parameters: parameters,
        binding: VTUserProfileBinding(),
        transition: Transition.noTransition,
      ),
      GetPage(
          name: WallScreenRoute,
          page: () => VTWallScreen(),
          binding: VTWallBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: EditProfileScreenRoute,
          page: () => VTEditProfilScreen(),
          binding: VTEditProfilBinding(),
          transition: Transition.noTransition),
      GetPage(
        name: MainPage,
        page: () => VTBottomBarScreen(),
        bindings: [
          VTBottomBarBinding(),
          ProgressionBindings(),
          VTProfilBinding(),
          RankingBindings()
        ],
      ),
      GetPage(
        name: UserProfileScreenRoute,
        page: () => VTUserProfileScreen(),
        binding: VTUserProfileBinding(),
        transition: Transition.noTransition,
      ),
      GetPage(
        name: SettingScreenRoute,
        page: () => VTSettingScreen(),
        bindings: [
          VTSettingBinding(),
        ],
        transition: Transition.noTransition,
      ),
      GetPage(
          name: WallScreenRoute,
          page: () => VTWallScreen(),
          binding: VTWallBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: EditProfileScreenRoute,
          page: () => VTEditProfilScreen(),
          binding: VTEditProfilBinding(),
          transition: Transition.noTransition),
      GetPage(
        name: MainPage,
        page: () => VTBottomBarScreen(),
        bindings: [
          VTBottomBarBinding(),
          ProgressionBindings(),
          VTProfilBinding(),
          RankingBindings()
        ],
      ),
      GetPage(
        name: UserProfileScreenRoute,
        page: () => VTUserProfileScreen(),
        binding: VTUserProfileBinding(),
        transition: Transition.noTransition,
      ),
      GetPage(
        name: SettingScreenRoute,
        page: () => VTSettingScreen(),
        bindings: [
          VTSettingBinding(),
        ],
        transition: Transition.noTransition,
      ),
      GetPage(
          name: createBlocSprayWall,
          page: () => SelectHoldsScreen(),
          binding: CreateblocBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: createTeamScreen,
          page: () => CreateTeamscreen(),
          binding: CreateTeamBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: joinTeamScreen,
          page: () => SelectTeamscreen(),
          binding: JoinTeamBinding(),
          transition: Transition.noTransition),
      GetPage(
          name: descriptionTeamScreen,
          page: () => DescriptionTeamscreen(),
          binding: DescriptionTeamBinding(),
          transition: Transition.noTransition),
    ];
  }
}
