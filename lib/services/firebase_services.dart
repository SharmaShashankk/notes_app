import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

// inslization of notification
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    initPushNotification();
    try {
      _firebaseMessaging.getToken().then((value) async {
        print('My device token $value');
      });
    } catch (e) {}
  }

// handle operation
  void handleMessage(
    RemoteMessage? message,
  ) async {
    print('My Notification event ${message?.notification!.title}');
  }

  // handle selctnotification
  Future initPushNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((event) async {
      handleMessage(event);
    });
  }

  removeToken() {
    _firebaseMessaging.deleteToken();
  }
}
