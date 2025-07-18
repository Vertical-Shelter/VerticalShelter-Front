import 'package:app/GeneralScreens/Log%20In/log_in_binding.dart';
import 'package:app/GeneralScreens/Log%20In/log_in_screen.dart';
import 'package:app/GeneralScreens/createUser/createUserBinding.dart';
import 'package:app/GeneralScreens/createUser/createUserSceen.dart';
import 'package:app/GeneralScreens/forgotPassword/forgot_password_binding.dart';
import 'package:app/GeneralScreens/forgotPassword/forgot_password_screen.dart';
import 'package:app/GeneralScreens/Email%20Sent/emailSentBinding.dart';
import 'package:app/GeneralScreens/Email%20Sent/emailSentPassword.dart';
import 'package:app/GeneralScreens/welcome/welcome_binding.dart';
import 'package:app/GeneralScreens/welcome/welcome_screen.dart';

import 'package:app/core/app_export.dart';

class GeneralAppRoutes {
  static const String WelcomeScreenRoute = '/app/welcome_screen';


  static const String RegisterScreenRoute = '/app/vt_register_screen';

  static const String CodeValidationScreenRoute = '/app/vt_code_validation_screen';

  static const String VTLogInScreenRoute = '/app/vt_log_in_screen';

  static const String ForgotPasswordScreenRoute = '/app/vt_forgot_password_screen';

  static const String ForgotPasswordCodeScreenRoute =
      '/app/vt_forgot_passwordCode_screen';

  static const String NewPasswordScreenRoute = '/app/vt_new_password_screen';

  static const String EmailSentRoute =
      '/app/vt_password_changed_succesfully_screen';

  static List<GetPage> pages = [
    GetPage(
      name: WelcomeScreenRoute,
      page: () => WelcomeScreen(),
      bindings: [
        WelcomeBinding(),
      ],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RegisterScreenRoute,
      page: () => RegisterScreen(),
      bindings: [
        RegisterBinding(),
      ],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: VTLogInScreenRoute,
      page: () => LogInScreen(),
      bindings: [
        LogInBinding(),
      ],
      transition: Transition.noTransition,
    ),
   
    GetPage(
      name: ForgotPasswordScreenRoute,
      page: () => ForgotPasswordScreen(),
      bindings: [
        ForgotPasswordBinding(),
      ],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: EmailSentRoute,
      page: () => EmailSentScreen(),
      bindings: [
        EmailSentBinding(),
      ],
      transition: Transition.noTransition,
    ),
  ];
}
