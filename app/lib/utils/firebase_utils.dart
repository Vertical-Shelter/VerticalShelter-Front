import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseUtils {

  static void firebase_unsubscribeFromTopic(String topic) {
    print("Unsubscribing from $topic");
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  static void firebase_subscribeToTopic(String topic) {
    print("Subscribing to $topic");
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
