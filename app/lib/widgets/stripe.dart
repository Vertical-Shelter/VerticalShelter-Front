import 'package:app/core/app_export.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeWidget {

  Future<void> createCheckoutSession() async {
    Dio dio = Dio();
    String userId = '123';
    var response = await dio.post(
      'http://192.168.68.61:8000/create-checkout-session',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'user_id': userId, // Send the user ID to attach as client_reference_id
      },
    );

    if (response.statusCode == 200) {
      final url = response.data['url'];

      // Launch the Checkout URL
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw "Could not launch $url";
      }
    } else {
      throw Exception('Failed to create Checkout Session: ${response.data}');
    }
  }

}
