import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:app/core/app_export.dart';

void handle_error<T>(T e) {
  if (e is NoInternetException) {
    //c'est un peu faux car si jamais c'est une connection serveur coupé bah ca renvoie la meme erreur
    Get.snackbar(
      "Erreur",
      "Pas de connexion internet, veuillez vérifier votre connexion et réessayer",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: ColorsConstantDarkTheme.neutral_white,
    );
  }
  if (e is ServerException)
    Get.snackbar(
      "Erreur",
      "Une erreur anormal est survenue, veuillez contacter notre support",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: ColorsConstantDarkTheme.neutral_white,
    );
  if (e is UnauthorizedException)
    Get.snackbar(
      "Erreur",
      "Vous n'êtes pas autorisé à effectuer cette action",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: ColorsConstantDarkTheme.neutral_white,
    );
}
