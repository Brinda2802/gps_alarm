import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:shared_preferences/shared_preferences.dart';
import 'Apiutils.dart';
import 'Homescreens/homescreen.dart';
import 'Homescreens/save_alarm_page.dart';
import 'Track.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await initializeService();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_notification');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == "dismiss") {
            await flutterLocalNotificationsPlugin.cancelAll();
          }
          break;
        default:
      }
    },
  );

  runApp(const MyApp());
}
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == "dismiss") {
              await flutterLocalNotificationsPlugin.cancelAll();
            }
            break;
          default:
        }
      },
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(autoStart: false),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  location.Location _locationService = location.Location();
  // bool serviceEnabled = await _locationService.serviceEnabled();
  // if (!serviceEnabled) {
  //   return;
  // }

  location.PermissionStatus permissionStatus = await _locationService
      .hasPermission();
  if (permissionStatus != location.PermissionStatus.granted) {
    return;
  }

  _locationService.onLocationChanged.listen((location.LocationData location) async {
    List<AlarmDetails> alarms = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? alarmsJson = prefs.getStringList('alarms');
    if (alarmsJson != null) {
      alarms.addAll(alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json))).toList());
      for (var alarm in alarms) {
        double distance = calculateDistance(
          LatLng(location!.latitude!, location!.longitude!),
          LatLng(alarm.lat, alarm.lng),
        );

        if (distance <= alarm.locationRadius) {
          // Trigger notification (potentially using a separate channel)
          _showNotification(alarm);
          break; // Exit loop after triggering the first alarm
        }
      }
    }
    }

  );
}
Future<void> _showNotification(AlarmDetails alarm) async {
  // Exit if notification already shown


  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('pachainirame'),
      ticker: 'ticker');
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id++, alarm.alarmName, "Reached your place", notificationDetails,
      payload: 'item x');
  // Exit if notification already shown

}
double degreesToRadians(double degrees) {
  return degrees * math.pi / 180;
}
double calculateDistance(LatLng point1, LatLng point2) {
  const double earthRadius = 6371000; // meters
  double lat1 = degreesToRadians(point1.latitude);
  double lat2 = degreesToRadians(point2.latitude);
  double lon1 = degreesToRadians(point1.longitude);
  double lon2 = degreesToRadians(point2.longitude);
  double dLat = lat2 - lat1;
  double dLon = lon2 - lon1;

  double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  double distance = earthRadius * c;

  return distance;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4345b4)),
        textTheme: GoogleFonts.robotoFlexTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home:MyAlarmsPage(),
    );
  }
}
// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});
//
//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }
//
// class _SplashscreenState extends State<Splashscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.blue, Colors.purple], // Set your gradient colors
//           ),
//         ),
//         child: Center(
//           child: Image.asset("assets/mapimage.png",height: 700,width: 300,),
//         ),
//       ),
//     );
//   }
// }
class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  // Simulate some initialization process (replace it with your actual initialization logic)
  Future<void> _initializeApp() async {
    await Future.delayed(Duration(seconds: 3)); // Simulating a 2-second initialization time
  }

  @override
  void initState() {
    super.initState();
    _initializeApp().then((_) {
      // Initialization complete, navigate to the main screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Homescreen(), // Replace YourMainScreen with the actual main screen widget
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Center(
          child: Image.asset(
            "assets/applogo.png",
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }
}



