import 'package:app/core/app_export.dart';
import 'package:app/core/utils/headers.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> createCheckoutSessionForVsl(String vsl_id) async {
  ApiClient api = Get.find<ApiClient>();
  String? urlForCheckout = null;
  await api.genericPost(
      MyAuthToken(),
      null,
      (json) => urlForCheckout = json['url'],
      api.config.baseUrl + '/create-checkout-session/',
      query: {'vsl_id': vsl_id});

  if (urlForCheckout != null) {
    // Launch the Checkout URL
    if (await canLaunchUrl(Uri.parse(urlForCheckout!))) {
      await launchUrl(Uri.parse(urlForCheckout!));
    } else {
      throw "Could not launch $urlForCheckout";
    }
  } else {
    throw Exception('Failed to create Checkout Session: ${urlForCheckout}');
  }
}
