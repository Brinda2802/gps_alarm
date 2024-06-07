// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:io';
// // import 'dart:ui';
// // import 'dart:math' as math;
// // import 'package:flutter/material.dart';
// // import 'package:flutter_background_service/flutter_background_service.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart' as location;
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:untitiled/Homescreens/settings.dart';
// // import 'package:uuid/uuid.dart';
// // import 'Apiutils.dart';
// // import 'Homescreens/homescreen.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'Homescreens/save_alarm_page.dart';
// //
// //
// // const notificationChannelId = 'my_foreground';
// // const notificationId = 888;
// //
// //
// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   // const AndroidInitializationSettings initializationSettingsAndroid =
// //   // AndroidInitializationSettings('ic_notification');
// //   // const InitializationSettings initializationSettings = InitializationSettings(
// //   //   android: initializationSettingsAndroid,
// //   // );
// //   //
// //   // await flutterLocalNotificationsPlugin.initialize(
// //   //   initializationSettings,
// //   //   onDidReceiveNotificationResponse:
// //   //       (NotificationResponse notificationResponse) async {
// //   //     switch (notificationResponse.notificationResponseType) {
// //   //       case NotificationResponseType.selectedNotificationAction:
// //   //         if (notificationResponse.actionId == "dismiss") {
// //   //           await flutterLocalNotificationsPlugin.cancelAll();
// //   //         }
// //   //         break;
// //   //       default:
// //   //     }
// //   //   },
// //   // );
// //   // BackgroundLocation.setAndroidNotification(
// //   //   title: "GPS Alarm",
// //   //   message: "Reached your place",
// //   //   icon: "@mipmap/ic_launcher",
// //   // );
// //   // BackgroundLocation.setAndroidConfiguration(1000);
// //   // BackgroundLocation.stopLocationService(); //To ensure that previously started services have been stopped, if desired
// //   // BackgroundLocation.startLocationService(distanceFilter : 10,forceAndroidLocationManager: true);
// //   // BackgroundLocation.getLocationUpdates((location) async {
// //   //   List<AlarmDetails> alarms = [];
// //   //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   //   List<String>? alarmsJson = prefs.getStringList('alarms');
// //   //   if (alarmsJson != null) {
// //   //     alarms.addAll(
// //   //         alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
// //   //             .toList());
// //   //     for (var alarm in alarms) {
// //   //       if (!alarm.isEnabled) {
// //   //         continue;
// //   //       }
// //   //       double distance = calculateDistance(
// //   //         LatLng(location.latitude!, location.longitude!),
// //   //         LatLng(alarm.lat, alarm.lng),
// //   //       );
// //   //
// //   //       if (distance <= alarm.locationRadius) {
// //   //         var index=alarms.indexOf(alarm);
// //   //         alarms[index].isEnabled=false;
// //   //         SharedPreferences prefs = await SharedPreferences.getInstance();
// //   //
// //   //         List<Map<String, dynamic>> alarmsJson =
// //   //         alarms.map((alarm) => alarm.toJson()).toList();
// //   //
// //   //         await prefs.setStringList(
// //   //             'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
// //   //         // Trigger notification (potentially using a separate channel)
// //   //         _showNotification(alarm);
// //   //         break; // Exit loop after triggering the first alarm
// //   //       }
// //   //       print("distance:"+distance.toString());
// //   //       print("location radius:"+alarm.locationRadius.toString());
// //   //       print("location:"+location.toString());
// //   //     }
// //   //   }
// //   // });
// //   //await initializeService();
// //   location.Location ls = new location.Location();
// //   if(await Permission.notification.request().isGranted && await Permission.location.request().isGranted && await ls.serviceEnabled()){
// //     await initializeService();
// //   }
// //   runApp(const MyApp());
// // }
// // Future<void> initializeService() async {
// //   final service = FlutterBackgroundService();
// //
// //   /// OPTIONAL, using custom notification channel id
// //
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //
// //   if (Platform.isAndroid) {
// //     await flutterLocalNotificationsPlugin.initialize(
// //       const InitializationSettings(
// //         android: AndroidInitializationSettings('ic_notification'),
// //       ),
// //     );
// //   }
// //
// //   // await flutterLocalNotificationsPlugin
// //   //     .resolvePlatformSpecificImplementation<
// //   //     AndroidFlutterLocalNotificationsPlugin>()
// //   //     ?.createNotificationChannel(channel);
// //
// //   await service.configure(
// //     androidConfiguration: AndroidConfiguration(
// //       // this will be executed when app is in foreground or background in separated isolate
// //       onStart: onStart,
// //
// //       // auto start service
// //       autoStart: true,
// //       isForegroundMode: true,
// //     ), iosConfiguration: IosConfiguration(
// //     // auto start service
// //     autoStart: true,
// //
// //     // this will be executed when app is in foreground in separated isolate
// //     onForeground: onStart,
// //   ),
// //   );
// // }
// // @pragma('vm:entry-point')
// // Future<void> onStart(ServiceInstance service) async {
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //   FlutterLocalNotificationsPlugin();
// //   await flutterLocalNotificationsPlugin.initialize(
// //     const InitializationSettings(
// //       android: AndroidInitializationSettings('ic_notification'),
// //     ),
// //   );
// //
// //   final LocationSettings locationSettings = LocationSettings(
// //       accuracy: LocationAccuracy.high,
// //       distanceFilter: 100);
// //
// //   Geolocator.getPositionStream(locationSettings: locationSettings).listen(
// //           (Position? position) async {
// //         List<AlarmDetails> alarms = [];
// //         SharedPreferences prefs = await SharedPreferences.getInstance();
// //         prefs.reload();
// //         List<String>? alarmsJson = prefs.getStringList('alarms');
// //         print(alarmsJson?.join(","));
// //         if (alarmsJson != null) {
// //           alarms.addAll(
// //               alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
// //                   .toList());
// //           for (var alarm in alarms) {
// //             print("location radius:" + alarm.locationRadius.toString());
// //             print("alarmname:" + alarm.alarmName);
// //             if (!alarm.isEnabled) {
// //               continue;
// //             }
// //             double distance = calculateDistance(
// //               LatLng(position!.latitude, position.longitude),
// //               LatLng(alarm.lat, alarm.lng),
// //             );
// //             print("distance:" + distance.toString());
// //             if (distance <= alarm.locationRadius) {
// //               var index = alarms.indexOf(alarm);
// //               alarms[index].isEnabled = false;
// //               List<Map<String, dynamic>> alarmsJson =
// //               alarms.map((alarm) => alarm.toJson()).toList();
// //               await prefs.setStringList(
// //                   'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
// //               // Trigger notification with sound regardless of service state
// //               final savedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
// //               print(savedRingtone);
// //               flutterLocalNotificationsPlugin.show(
// //                 notificationId,
// //                 alarm.alarmName,
// //                 'Reached your place',
// //                 NotificationDetails(
// //                   android: AndroidNotificationDetails(
// //                     Uuid().v4(),
// //                     'MY FOREGROUND SERVICE',
// //                     icon: 'ic_notification',
// //                     sound: RawResourceAndroidNotificationSound(savedRingtone.replaceAll(".mp3", "")),
// //                     priority: Priority.high,
// //                     actions: [
// //                       // Dismiss action
// //                       AndroidNotificationAction(
// //                         Uuid().v4(),
// //                         'Dismiss',
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //               break; // Exit loop after triggering the first alarm
// //             }
// //           }
// //         }
// //       });
// // }
// //
// // double degreesToRadians(double degrees) {
// //   return degrees * math.pi / 180;
// // }
// // double calculateDistance(LatLng point1, LatLng point2) {
// //   const double earthRadius = 6371000; // meters
// //   double lat1 = degreesToRadians(point1.latitude);
// //   double lat2 = degreesToRadians(point2.latitude);
// //   double lon1 = degreesToRadians(point1.longitude);
// //   double lon2 = degreesToRadians(point2.longitude);
// //   double dLat = lat2 - lat1;
// //   double dLon = lon2 - lon1;
// //
// //   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
// //       math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
// //   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
// //   double distance = earthRadius * c;
// //
// //   return distance;
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       theme: ThemeData(
// //         useMaterial3: true,
// //         colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4345b4)),
// //         textTheme: GoogleFonts.robotoFlexTextTheme(),
// //       ),
// //       debugShowCheckedModeBanner: false,
// //       home:Splashscreen(),
// //     );
// //   }
// //
// // }
// //
// //
// //
// // class Splashscreen extends StatefulWidget {
// //   @override
// //   _SplashscreenState createState() => _SplashscreenState();
// // }
// //
// // class _SplashscreenState extends State<Splashscreen> {
// //   // Simulate some initialization process (replace it with your actual initialization logic)
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance!.addPostFrameCallback((_) {
// //       _checkUserStatus();
// //     });
// //   }
// //   Future<void> _checkUserStatus() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     bool hasSetSettings = prefs.getBool('hasSetSettings') ?? false; // Default to false if not set
// //     print("hasSetSettings value: $hasSetSettings");
// //     if (hasSetSettings) {
// //       // User has set settings before, navigate to MyAlarmsPage
// //       Navigator.of(context).pushReplacement(
// //         MaterialPageRoute(builder: (context) => MyAlarmsPage()),
// //       );
// //     } else {
// //       // User is setting settings for the first time, navigate to Settings page
// //       Navigator.of(context).pushReplacement(
// //         MaterialPageRoute(builder: (context) => Settings()),
// //       );
// //     }
// //   }
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //
// //     );
// //   }
// // }
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// import 'dart:math' as math;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import 'Apiutils.dart';
// import 'Homescreens/homescreen.dart';
// import 'package:geolocator/geolocator.dart';
// import 'Homescreens/save_alarm_page.dart';
// import 'Homescreens/settings.dart';
// import 'Map screen page.dart';
// import 'about page.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// const notificationChannelId = 'my_foreground';
// const notificationId = 888;
//
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await platform.invokeMethod('initialize');
//   // platform.setMethodCallHandler((call) async {
//   //   if (call.method == 'handleNotificationAction') {
//   //     final String? action = call.arguments['action'];
//   //     if (action == 'Dismiss') {
//   //       print("audioplayer will be stopped");
//   //       AudioPlayer audioPlayer = AudioPlayer();
//   //       // Stop the sound associated with the alarm
//   //       audioPlayer.stop();
//   //     }
//   //   }
//   // });
//   // const AndroidInitializationSettings initializationSettingsAndroid =
//   // AndroidInitializationSettings('ic_notification');
//   // const InitializationSettings initializationSettings = InitializationSettings(
//   //   android: initializationSettingsAndroid,
//   // );
//   //
//   // await flutterLocalNotificationsPlugin.initialize(
//   //   initializationSettings,
//   //   onDidReceiveNotificationResponse:
//   //       (NotificationResponse notificationResponse) async {
//   //     switch (notificationResponse.notificationResponseType) {
//   //       case NotificationResponseType.selectedNotificationAction:
//   //         if (notificationResponse.actionId == "dismiss") {
//   //           await flutterLocalNotificationsPlugin.cancelAll();
//   //         }
//   //         break;
//   //       default:
//   //     }
//   //   },
//   // );
//   // BackgroundLocation.setAndroidNotification(
//   //   title: "GPS Alarm",
//   //   message: "Reached your place",
//   //   icon: "@mipmap/ic_launcher",
//   // );
//   // BackgroundLocation.setAndroidConfiguration(1000);
//   // BackgroundLocation.stopLocationService(); //To ensure that previously started services have been stopped, if desired
//   // BackgroundLocation.startLocationService(distanceFilter : 10,forceAndroidLocationManager: true);
//   // BackgroundLocation.getLocationUpdates((location) async {
//   //   List<AlarmDetails> alarms = [];
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   List<String>? alarmsJson = prefs.getStringList('alarms');
//   //   if (alarmsJson != null) {
//   //     alarms.addAll(
//   //         alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//   //             .toList());
//   //     for (var alarm in alarms) {
//   //       if (!alarm.isEnabled) {
//   //         continue;
//   //       }
//   //       double distance = calculateDistance(
//   //         LatLng(location.latitude!, location.longitude!),
//   //         LatLng(alarm.lat, alarm.lng),
//   //       );
//   //
//   //       if (distance <= alarm.locationRadius) {
//   //         var index=alarms.indexOf(alarm);
//   //         alarms[index].isEnabled=false;
//   //         SharedPreferences prefs = await SharedPreferences.getInstance();
//   //
//   //         List<Map<String, dynamic>> alarmsJson =
//   //         alarms.map((alarm) => alarm.toJson()).toList();
//   //
//   //         await prefs.setStringList(
//   //             'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//   //         // Trigger notification (potentially using a separate channel)
//   //         _showNotification(alarm);
//   //         break; // Exit loop after triggering the first alarm
//   //       }
//   //       print("distance:"+distance.toString());
//   //       print("location radius:"+alarm.locationRadius.toString());
//   //       print("location:"+location.toString());
//   //     }
//   //   }
//   // });
//   //await initializeService();
//   location.Location ls = new location.Location();
//   if (await Permission.notification.request().isGranted &&
//       await Permission.location.request().isGranted &&
//       await ls.serviceEnabled()) {
//     await initializeService();
//   }
//   runApp(const MyApp());
// }
//
// Future<void> initializeService() async {
//
//   final service = FlutterBackgroundService();
//
//   /// OPTIONAL, using custom notification channel id
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//
//   if (Platform.isAndroid) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('ic_bg_service_small'),
//       ),
//     );
//   }
//
//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<
//   //     AndroidFlutterLocalNotificationsPlugin>()
//   //     ?.createNotificationChannel(channel);
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//       initialNotificationTitle: 'Running in Background',
//       initialNotificationContent: 'This is required to trigger alarm',
//       // auto start service
//       autoStart: false,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: false,
//
//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,
//     ),
//   );
// }
//
//
// class MyStream {
//   StreamController<int> _controller = StreamController<int>();
//
//   Stream<int> get stream => _controller.stream;
//
//   void start() {
//     // Start emitting values
//     for (int i = 0; i < 10; i++) {
//       _controller.add(i);
//       Future.delayed(Duration(milliseconds: 500), () => _controller.add(i));
//     }
//   }
//
//   void cancel() {
//     _controller.close(); // Close the stream controller to stop emitting values
//   }
// }
//
// @pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings('ic_bg_service_small'),
//     ),
//
//   );
//  // int uniqueNotificationId = 888 ;
//
//   final LocationSettings locationSettings =
//       LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);
//
//   late StreamSubscription subscription;
//   subscription = Geolocator.getPositionStream(locationSettings: locationSettings)
//       .listen((Position? position) async {
//     List<AlarmDetails> alarms = [];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.reload();
//     List<String>? alarmsJson = prefs.getStringList('alarms');
//     print(alarmsJson?.join(","));
//     if (alarmsJson != null) {
//       alarms.addAll(alarmsJson
//           .map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//           .where((element) => element.isEnabled)
//           .toList());
//       for (var alarm in alarms) {
//         print("location radius:" + alarm.locationRadius.toString());
//         print("alarmname:" + alarm.alarmName);
//         if (!alarm.isEnabled) {
//           continue;
//         }
//         double distance = calculateDistance(
//           LatLng(position!.latitude, position.longitude),
//           LatLng(alarm.lat, alarm.lng),
//         );
//         print("distance:" + distance.toString());
//         if (distance <= alarm.locationRadius) {
//           var index = alarms.indexOf(alarm);
//           alarms[index].isEnabled = false;
//           List<Map<String, dynamic>> alarmsJson =
//               alarms.map((alarm) => alarm.toJson()).toList();
//           await prefs.setStringList(
//               'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//           // Trigger notification with sound regardless of service state
//           final savedRingtone =
//               prefs.getString('selectedRingtone') ?? "alarm6.mp3";
//           // await audioPlayer.play(savedRingtone as Source,);
//           print(savedRingtone);
//            flutterLocalNotificationsPlugin.show(
//             notificationId,
//             alarm.alarmName,
//             'Reached your place',
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 Uuid().v4(),
//                 'MY FOREGROUND SERVICE',
//                 icon: 'ic_bg_service_small',
//                 sound: RawResourceAndroidNotificationSound(
//                     savedRingtone.replaceAll(".mp3", "")),
//                 priority: Priority.high,
//                 importance: Importance.max,
//                 ticker: 'ticker',
//                 actions: [
//
//                   // Dismiss action
//                   AndroidNotificationAction(
//                     Uuid().v4(),
//                     'Dismiss',
//                   ),
//                   // Stop action
//                   // AndroidNotificationAction(
//                   //   'stop_action',
//                   //   'Stop',
//                   // ),
//                   // Snooze action
//                 ],
//                 styleInformation: DefaultStyleInformation(true, true),
//               ),
//             ),
//
//           );
//           // if (MethodChannel('dexterx.dev/flutter_local_notifications') != null) {
//           //   const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications');
//           //   platform.setMethodCallHandler((MethodCall call) async {
//           //     switch (call.method) {
//           //       case 'didReceiveLocalNotification':
//           //         final String? progress = call.arguments['progress'];
//           //         if (progress != null) {
//           //           // Extract alarm ID from payload and stop sound
//           //           final alarmId = int.tryParse(progress.split('_')[1]);
//           //           if (alarmId != null) {
//           //             // Stop the sound associated with the tapped alarm
//           //
//           //             await audioPlayer.stop();
//           //             // You can handle further actions based on alarm ID
//           //           }
//           //         }
//           //         break;
//           //       default:
//           //         break;
//           //     }
//           //   });
//           // } else {
//           //   print('didReceiveLocalNotification method not available in this version');
//           // }
//           print('preparing to stop service');
//           break; // Exit loop after triggering the first alarm
//         }
//       }
//
//       alarms = alarms.where((element) => element.isEnabled).toList();
//       if(alarms.isEmpty ) {
//         subscription.cancel();
//         service.stopSelf();
//       }
//     }
//
//   });
//   service.on('stopService').listen((event) {
//     print('stopping service');
//     service.stopSelf();
//     subscription.cancel();
//   });
// }
//
// Future<void> stopService() async {
//   // 1. Cancel location updates:// Cancels the location stream
//
//   // 2. Stop foreground service (if running):
//   if (defaultTargetPlatform == TargetPlatform.android) {
//     const methodChannel = MethodChannel('com.yourdomain.yourapp/service');
//     try {
//       await methodChannel.invokeMethod('stopForegroundService');
//     } on PlatformException catch (e) {
//       // Handle platform exceptions (optional)
//       print("Error stopping service: $e");
//     }
//   }
//
//   // 3. (Optional) Clear notifications:
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.cancelAll();
//
//   // 4. (Optional) Persist alarm data if needed:
//   // ... Save alarms to SharedPreferences or other storage ...
//
//   // 5. (Optional) Unregister any other listeners or resources
//
//   print('Service stopped.');
// }
//
// double degreesToRadians(double degrees) {
//   return degrees * math.pi / 180;
// }
//
// double calculateDistance(LatLng point1, LatLng point2) {
//   const double earthRadius = 6371000; // meters
//   double lat1 = degreesToRadians(point1.latitude);
//   double lat2 = degreesToRadians(point2.latitude);
//   double lon1 = degreesToRadians(point1.longitude);
//   double lon2 = degreesToRadians(point2.longitude);
//   double dLat = lat2 - lat1;
//   double dLon = lon2 - lon1;
//
//   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//       math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
//   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//   double distance = earthRadius * c;
//
//   return distance;
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4345b4)),
//         textTheme: GoogleFonts.robotoFlexTextTheme(),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: Splashscreen(),
//       routes: {
//         // Define your routes (optional)
//         '/home': (context) => MyAlarmsPage(),
//         '/secondpage': (context) => MyHomePage(),
//         '/thirdpage': (context) => Settings(),
//         'fouthpage': (context) => About(),
//       },
//     );
//   }
// }
//
// class Splashscreen extends StatefulWidget {
//   @override
//   _SplashscreenState createState() => _SplashscreenState();
// }
//
// class _SplashscreenState extends State<Splashscreen> {
//   // Simulate some initialization process (replace it with your actual initialization logic)
//   @override
//   void initState() {
//     super.initState();
//     _checkUserStatus();
//   }
//
//   Future<void> _checkUserStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool hasSetSettings =
//         prefs.getBool('hasSetSettings') ?? false; // Default to false if not set
//     print("hasSetSettings value: $hasSetSettings");
//     if (hasSetSettings) {
//       // User has set settings before, navigate to MyAlarmsPage
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => MyAlarmsPage()),
//       );
//     } else {
//       // User is setting settings for the first time, navigate to Settings page
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => Settings()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:untitiled/Homescreens/settings.dart';
// import 'package:uuid/uuid.dart';
// import 'Apiutils.dart';
// import 'Homescreens/homescreen.dart';
// import 'package:geolocator/geolocator.dart';
// import 'Homescreens/save_alarm_page.dart';
//
//
// const notificationChannelId = 'my_foreground';
// const notificationId = 888;
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // const AndroidInitializationSettings initializationSettingsAndroid =
//   // AndroidInitializationSettings('ic_notification');
//   // const InitializationSettings initializationSettings = InitializationSettings(
//   //   android: initializationSettingsAndroid,
//   // );
//   //
//   // await flutterLocalNotificationsPlugin.initialize(
//   //   initializationSettings,
//   //   onDidReceiveNotificationResponse:
//   //       (NotificationResponse notificationResponse) async {
//   //     switch (notificationResponse.notificationResponseType) {
//   //       case NotificationResponseType.selectedNotificationAction:
//   //         if (notificationResponse.actionId == "dismiss") {
//   //           await flutterLocalNotificationsPlugin.cancelAll();
//   //         }
//   //         break;
//   //       default:
//   //     }
//   //   },
//   // );
//   // BackgroundLocation.setAndroidNotification(
//   //   title: "GPS Alarm",
//   //   message: "Reached your place",
//   //   icon: "@mipmap/ic_launcher",
//   // );
//   // BackgroundLocation.setAndroidConfiguration(1000);
//   // BackgroundLocation.stopLocationService(); //To ensure that previously started services have been stopped, if desired
//   // BackgroundLocation.startLocationService(distanceFilter : 10,forceAndroidLocationManager: true);
//   // BackgroundLocation.getLocationUpdates((location) async {
//   //   List<AlarmDetails> alarms = [];
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   List<String>? alarmsJson = prefs.getStringList('alarms');
//   //   if (alarmsJson != null) {
//   //     alarms.addAll(
//   //         alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//   //             .toList());
//   //     for (var alarm in alarms) {
//   //       if (!alarm.isEnabled) {
//   //         continue;
//   //       }
//   //       double distance = calculateDistance(
//   //         LatLng(location.latitude!, location.longitude!),
//   //         LatLng(alarm.lat, alarm.lng),
//   //       );
//   //
//   //       if (distance <= alarm.locationRadius) {
//   //         var index=alarms.indexOf(alarm);
//   //         alarms[index].isEnabled=false;
//   //         SharedPreferences prefs = await SharedPreferences.getInstance();
//   //
//   //         List<Map<String, dynamic>> alarmsJson =
//   //         alarms.map((alarm) => alarm.toJson()).toList();
//   //
//   //         await prefs.setStringList(
//   //             'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//   //         // Trigger notification (potentially using a separate channel)
//   //         _showNotification(alarm);
//   //         break; // Exit loop after triggering the first alarm
//   //       }
//   //       print("distance:"+distance.toString());
//   //       print("location radius:"+alarm.locationRadius.toString());
//   //       print("location:"+location.toString());
//   //     }
//   //   }
//   // });
//   //await initializeService();
//   location.Location ls = new location.Location();
//   if(await Permission.notification.request().isGranted && await Permission.location.request().isGranted && await ls.serviceEnabled()){
//     await initializeService();
//   }
//   runApp(const MyApp());
// }
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   /// OPTIONAL, using custom notification channel id
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   if (Platform.isAndroid) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('ic_notification'),
//       ),
//     );
//   }
//
//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<
//   //     AndroidFlutterLocalNotificationsPlugin>()
//   //     ?.createNotificationChannel(channel);
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//
//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ), iosConfiguration: IosConfiguration(
//     // auto start service
//     autoStart: true,
//
//     // this will be executed when app is in foreground in separated isolate
//     onForeground: onStart,
//   ),
//   );
// }
// @pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings('ic_notification'),
//     ),
//   );
//
//   final LocationSettings locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100);
//
//   Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//           (Position? position) async {
//         List<AlarmDetails> alarms = [];
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.reload();
//         List<String>? alarmsJson = prefs.getStringList('alarms');
//         print(alarmsJson?.join(","));
//         if (alarmsJson != null) {
//           alarms.addAll(
//               alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//                   .toList());
//           for (var alarm in alarms) {
//             print("location radius:" + alarm.locationRadius.toString());
//             print("alarmname:" + alarm.alarmName);
//             if (!alarm.isEnabled) {
//               continue;
//             }
//             double distance = calculateDistance(
//               LatLng(position!.latitude, position.longitude),
//               LatLng(alarm.lat, alarm.lng),
//             );
//             print("distance:" + distance.toString());
//             if (distance <= alarm.locationRadius) {
//               var index = alarms.indexOf(alarm);
//               alarms[index].isEnabled = false;
//               List<Map<String, dynamic>> alarmsJson =
//               alarms.map((alarm) => alarm.toJson()).toList();
//               await prefs.setStringList(
//                   'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//               // Trigger notification with sound regardless of service state
//               final savedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
//               print(savedRingtone);
//               flutterLocalNotificationsPlugin.show(
//                 notificationId,
//                 alarm.alarmName,
//                 'Reached your place',
//                 NotificationDetails(
//                   android: AndroidNotificationDetails(
//                     Uuid().v4(),
//                     'MY FOREGROUND SERVICE',
//                     icon: 'ic_notification',
//                     sound: RawResourceAndroidNotificationSound(savedRingtone.replaceAll(".mp3", "")),
//                     priority: Priority.high,
//                     actions: [
//                       // Dismiss action
//                       AndroidNotificationAction(
//                         Uuid().v4(),
//                         'Dismiss',
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//               break; // Exit loop after triggering the first alarm
//             }
//           }
//         }
//       });
// }
//
// double degreesToRadians(double degrees) {
//   return degrees * math.pi / 180;
// }
// double calculateDistance(LatLng point1, LatLng point2) {
//   const double earthRadius = 6371000; // meters
//   double lat1 = degreesToRadians(point1.latitude);
//   double lat2 = degreesToRadians(point2.latitude);
//   double lon1 = degreesToRadians(point1.longitude);
//   double lon2 = degreesToRadians(point2.longitude);
//   double dLat = lat2 - lat1;
//   double dLon = lon2 - lon1;
//
//   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//       math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
//   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//   double distance = earthRadius * c;
//
//   return distance;
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4345b4)),
//         textTheme: GoogleFonts.robotoFlexTextTheme(),
//       ),
//       debugShowCheckedModeBanner: false,
//       home:Splashscreen(),
//     );
//   }
//
// }
//
//
//
// class Splashscreen extends StatefulWidget {
//   @override
//   _SplashscreenState createState() => _SplashscreenState();
// }
//
// class _SplashscreenState extends State<Splashscreen> {
//   // Simulate some initialization process (replace it with your actual initialization logic)
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       _checkUserStatus();
//     });
//   }
//   Future<void> _checkUserStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool hasSetSettings = prefs.getBool('hasSetSettings') ?? false; // Default to false if not set
//     print("hasSetSettings value: $hasSetSettings");
//     if (hasSetSettings) {
//       // User has set settings before, navigate to MyAlarmsPage
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => MyAlarmsPage()),
//       );
//     } else {
//       // User is setting settings for the first time, navigate to Settings page
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => Settings()),
//       );
//     }
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//     );
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// import 'dart:math' as math;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
// import 'Apiutils.dart';
// import 'Homescreens/homescreen.dart';
// import 'package:geolocator/geolocator.dart';
// import 'Homescreens/save_alarm_page.dart';
// import 'Homescreens/settings.dart';
// import 'Map screen page.dart';
// import 'about page.dart';
//
// const notificationChannelId = 'my_foreground';
// const notificationId = 888;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // const AndroidInitializationSettings initializationSettingsAndroid =
//   // AndroidInitializationSettings('ic_notification');
//   // const InitializationSettings initializationSettings = InitializationSettings(
//   //   android: initializationSettingsAndroid,
//   // );
//   //
//   // await flutterLocalNotificationsPlugin.initialize(
//   //   initializationSettings,
//   //   onDidReceiveNotificationResponse:
//   //       (NotificationResponse notificationResponse) async {
//   //     switch (notificationResponse.notificationResponseType) {
//   //       case NotificationResponseType.selectedNotificationAction:
//   //         if (notificationResponse.actionId == "dismiss") {
//   //           await flutterLocalNotificationsPlugin.cancelAll();
//   //         }
//   //         break;
//   //       default:
//   //     }
//   //   },
//   // );
//   // BackgroundLocation.setAndroidNotification(
//   //   title: "GPS Alarm",
//   //   message: "Reached your place",
//   //   icon: "@mipmap/ic_launcher",
//   // );
//   // BackgroundLocation.setAndroidConfiguration(1000);
//   // BackgroundLocation.stopLocationService(); //To ensure that previously started services have been stopped, if desired
//   // BackgroundLocation.startLocationService(distanceFilter : 10,forceAndroidLocationManager: true);
//   // BackgroundLocation.getLocationUpdates((location) async {
//   //   List<AlarmDetails> alarms = [];
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   List<String>? alarmsJson = prefs.getStringList('alarms');
//   //   if (alarmsJson != null) {
//   //     alarms.addAll(
//   //         alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//   //             .toList());
//   //     for (var alarm in alarms) {
//   //       if (!alarm.isEnabled) {
//   //         continue;
//   //       }
//   //       double distance = calculateDistance(
//   //         LatLng(location.latitude!, location.longitude!),
//   //         LatLng(alarm.lat, alarm.lng),
//   //       );
//   //
//   //       if (distance <= alarm.locationRadius) {
//   //         var index=alarms.indexOf(alarm);
//   //         alarms[index].isEnabled=false;
//   //         SharedPreferences prefs = await SharedPreferences.getInstance();
//   //
//   //         List<Map<String, dynamic>> alarmsJson =
//   //         alarms.map((alarm) => alarm.toJson()).toList();
//   //
//   //         await prefs.setStringList(
//   //             'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//   //         // Trigger notification (potentially using a separate channel)
//   //         _showNotification(alarm);
//   //         break; // Exit loop after triggering the first alarm
//   //       }
//   //       print("distance:"+distance.toString());
//   //       print("location radius:"+alarm.locationRadius.toString());
//   //       print("location:"+location.toString());
//   //     }
//   //   }
//   // });
//   //await initializeService();
//   location.Location ls = new location.Location();
//   if (await Permission.notification.request().isGranted &&
//       await Permission.location.request().isGranted &&
//       await ls.serviceEnabled()) {
//     await initializeService();
//   }
//   runApp(const MyApp());
// }
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   /// OPTIONAL, using custom notification channel id
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   if (Platform.isAndroid) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('ic_bg_service_small'),
//       ),
//     );
//   }
//
//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<
//   //     AndroidFlutterLocalNotificationsPlugin>()
//   //     ?.createNotificationChannel(channel);
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//       initialNotificationTitle: 'Running in Background',
//       initialNotificationContent: 'This is required to trigger alarm',
//       // auto start service
//       autoStart: false,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: false,
//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,
//     ),
//   );
// }
//
// class MyStream {
//   StreamController<int> _controller = StreamController<int>();
//
//   Stream<int> get stream => _controller.stream;
//
//   void start() {
//     // Start emitting values
//     for (int i = 0; i < 10; i++) {
//       _controller.add(i);
//       Future.delayed(Duration(milliseconds: 500), () => _controller.add(i));
//     }
//   }
//
//   void cancel() {
//     _controller.close(); // Close the stream controller to stop emitting values
//   }
// }
//
// // Future<void> loadSelectedNotificationType() async {
// //
// //   try {
// //     final prefs = await SharedPreferences.getInstance();
// //      selectedRingtone = prefs.getString('selectedRingtone') ?? "" ;
// //      isSwitched = prefs.getBool(kSharedPrefVibrate!) ?? false;
// //      // Check for "Both" state based on the stored value
// //      _selectedOption = prefs.getString(kSharedPrefBoth!) == 'Both' ? 'Both' : _selectedOption;
// //      // Maintain existing selection if not "Both"
// //
// //   } catch (e) {
// //     print('Error loading settings: $e');
// //   }
// // }
// // late NotificationType selectedNotificationType = NotificationType.Alarm; // Initialize it with a default value
// //  // Initialize it with a default value
// //
// // // Function to store data
// // void storeData(SharedPreferences prefs) {
// //   prefs.setString('selectedNotificationType', selectedNotificationType.toString());
// // }
// String _selectedOption = 'Alarms';
// String? selectedRingtone ;
// String? kSharedPrefVibrate = 'vibrateEnabled';
// String? kSharedPrefBoth = 'useBoth';
// bool isSwitched = false;
//
//
//
// @pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings('ic_bg_service_small'),
//     ),
//   );
//   // final AudioPlayer audioPlayer = AudioPlayer();
//   final LocationSettings locationSettings =
//   LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);
//   late StreamSubscription subscription;
//   subscription = Geolocator.getPositionStream(locationSettings: locationSettings)
//       .listen((Position? position) async{
//     List<AlarmDetails> alarms = [];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.reload();
//     List<String>? alarmsJson = prefs.getStringList('alarms');
//     print(alarmsJson?.join(","));
//     if (alarmsJson != null) {
//       alarms.addAll(alarmsJson
//           .map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//           .where((element) => element.isEnabled)
//           .toList());
//       for (var alarm in alarms) {
//         print("location radius:" + alarm.locationRadius.toString());
//         print("alarmname:" + alarm.alarmName);
//         if (!alarm.isEnabled) {
//           continue;
//         }
//         double distance = calculateDistance(
//           LatLng(position!.latitude, position.longitude),
//           LatLng(alarm.lat, alarm.lng),
//         );
//         print("distance:" + distance.toString());
//         if (distance <= alarm.locationRadius) {
//           var index = alarms.indexOf(alarm);
//           alarms[index].isEnabled = false;
//           print("false:");
//           List<Map<String, dynamic>> alarmsJson =
//           alarms.map((alarm) => alarm.toJson()).toList();
//           await prefs.setStringList(
//               'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//           // Trigger notification with sound regardless of service state
//           // final savedRingtone =
//           //     prefs.getString('selectedRingtone') ?? "alarm6.mp3";
//           // print("savedringtone:" + savedRingtone);
//           // final AudioPlayer audioPlayer = AudioPlayer();
//           // await audioPlayer.play(AssetSource(savedRingtone));
//           // print("audio will be play");
//           if ( selectedRingtone != null) {
//             final savedRingtone =
//                 prefs.getString('selectedRingtone') ?? "alarm6.mp3";
//             print("savedringtone:" + savedRingtone);
//             final AudioPlayer audioPlayer = AudioPlayer();
//             await audioPlayer.play(AssetSource(savedRingtone));
//             print("audio will be play");
//
//             // final savedRingtone =
//             //     prefs.getString('selectedRingtone') ?? "alarm6.mp3";
//
//
//
//             print("audio will be play");
//             // Play alarm sound
//             flutterLocalNotificationsPlugin.show(
//               notificationId,
//               alarm.alarmName,
//               'Reached destination radius',
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   Uuid().v4(),
//                   'MY FOREGROUND SERVICE',
//                   icon: 'ic_bg_service_small',
//                   sound: RawResourceAndroidNotificationSound(selectedRingtone!.replaceAll(".mp3", "")),
//                   priority: Priority.high,
//                   importance: Importance.max,
//                   additionalFlags: Int32List.fromList(<int>[4]),
//                  enableVibration: false,
//                   fullScreenIntent: true,
//                   actions: [
//                     // Dismiss action
//                     AndroidNotificationAction(
//                       Uuid().v4(),
//                       'Dismiss',
//                     ),
//                     // Stop action
//                     // AndroidNotificationAction(
//                     //   'stop_action',
//                     //   'Stop',
//                     // ),
//                     // Snooze action
//                   ],
//                   styleInformation: DefaultStyleInformation(true, true),
//                 ),
//               ),
//             );
//           }
//           else  if (kSharedPrefVibrate != null){
//             // Show notification with vibration
//             flutterLocalNotificationsPlugin.show(
//               notificationId,
//               alarm.alarmName,
//               'Reached destination radius',
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   Uuid().v4(),
//                   'MY FOREGROUND SERVICE',
//                   icon: 'ic_bg_service_small',
//                   priority: Priority.high,
//                   importance: Importance.max,
//                   vibrationPattern: Int64List.fromList(<int>[
//                     0, // Start immediately
//                     1000, // Vibrate for 1 second
//                     500, // Pause for 0.5 seconds
//                     1000, // Vibrate for 1 second
//                   ]), // Include vibration for other notification types
//                   fullScreenIntent: true,
//                   actions: [
//                     // Dismiss action
//                     AndroidNotificationAction(
//                       Uuid().v4(),
//                       'Dismiss',
//                     ),
//                     // Stop action
//                     // AndroidNotificationAction(
//                     //   'stop_action',
//                     //   'Stop',
//                     // ),
//                     // Snooze action
//                   ],
//                   styleInformation: DefaultStyleInformation(true, true),
//                 ),
//               ),
//             );
//           } else{
//
//           }
//              // Or use other source types (e.g., UrlSource)
//             // Play the audio using the correct Source type
//           print('preparing to stop service');
//             break; // Exit loop after triggering the first alarm
//           }
//         }
//         alarms = alarms.where((element) => element.isEnabled).toList();
//         if (alarms.isEmpty) {
//           print("service is stopped");
//           subscription.cancel();
//           service.stopSelf();
//         }
//       }
//     });
//
//   service.on('stopService').listen((event) {
//     print('stopping service');
//     service.stopSelf();
//     subscription.cancel();
//   });
// }
//
// Future<void> stopService() async {
//   // 1. Cancel location updates:// Cancels the location stream
//
//   // 2. Stop foreground service (if running):
//   if (defaultTargetPlatform == TargetPlatform.android) {
//     const methodChannel = MethodChannel('com.yourdomain.yourapp/service');
//     try {
//       await methodChannel.invokeMethod('stopForegroundService');
//     } on PlatformException catch (e) {
//       // Handle platform exceptions (optional)
//       print("Error stopping service: $e");
//     }
//   }
//
//   // 3. (Optional) Clear notifications:
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.cancelAll();
//
//   // 4. (Optional) Persist alarm data if needed:
//   // ... Save alarms to SharedPreferences or other storage ...
//
//   // 5. (Optional) Unregister any other listeners or resources
//
//   print('Service stopped.');
// }
//
// double degreesToRadians(double degrees) {
//   return degrees * math.pi / 180;
// }
//
// double calculateDistance(LatLng point1, LatLng point2) {
//   const double earthRadius = 6371000; // meters
//   double lat1 = degreesToRadians(point1.latitude);
//   double lat2 = degreesToRadians(point2.latitude);
//   double lon1 = degreesToRadians(point1.longitude);
//   double lon2 = degreesToRadians(point2.longitude);
//   double dLat = lat2 - lat1;
//   double dLon = lon2 - lon1;
//
//   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//       math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
//   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//   double distance = earthRadius * c;
//
//   return distance;
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4345b4)),
//         textTheme: GoogleFonts.robotoFlexTextTheme(),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: Splashscreen(),
//       routes: {
//         // Define your routes (optional)
//         '/home': (context) => MyAlarmsPage(),
//         '/secondpage': (context) => MyHomePage(),
//         '/thirdpage': (context) => Settings(),
//         'fouthpage': (context) => About(),
//       },
//     );
//   }
// }
//
// class Splashscreen extends StatefulWidget {
//   @override
//   _SplashscreenState createState() => _SplashscreenState();
// }
//
// class _SplashscreenState extends State<Splashscreen> {
//   // Simulate some initialization process (replace it with your actual initialization logic)
//   @override
//   void initState() {
//     super.initState();
//     _checkUserStatus();
//   }
//
//   Future<void> _checkUserStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool hasSetSettings =
//         prefs.getBool('hasSetSettings') ?? false; // Default to false if not set
//     print("hasSetSettings value: $hasSetSettings");
//     if (hasSetSettings) {
//       // User has set settings before, navigate to MyAlarmsPage
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => MyAlarmsPage()),
//       );
//     } else {
//       // User is setting settings for the first time, navigate to Settings page
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => Settings()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:untitiled/Homescreens/settings.dart';
// import 'package:uuid/uuid.dart';
// import 'Apiutils.dart';
// import 'Homescreens/homescreen.dart';
// import 'package:geolocator/geolocator.dart';
// import 'Homescreens/save_alarm_page.dart';
//
//
// const notificationChannelId = 'my_foreground';
// const notificationId = 888;
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // const AndroidInitializationSettings initializationSettingsAndroid =
//   // AndroidInitializationSettings('ic_notification');
//   // const InitializationSettings initializationSettings = InitializationSettings(
//   //   android: initializationSettingsAndroid,
//   // );
//   //
//   // await flutterLocalNotificationsPlugin.initialize(
//   //   initializationSettings,
//   //   onDidReceiveNotificationResponse:
//   //       (NotificationResponse notificationResponse) async {
//   //     switch (notificationResponse.notificationResponseType) {
//   //       case NotificationResponseType.selectedNotificationAction:
//   //         if (notificationResponse.actionId == "dismiss") {
//   //           await flutterLocalNotificationsPlugin.cancelAll();
//   //         }
//   //         break;
//   //       default:
//   //     }
//   //   },
//   // );
//   // BackgroundLocation.setAndroidNotification(
//   //   title: "GPS Alarm",
//   //   message: "Reached your place",
//   //   icon: "@mipmap/ic_launcher",
//   // );
//   // BackgroundLocation.setAndroidConfiguration(1000);
//   // BackgroundLocation.stopLocationService(); //To ensure that previously started services have been stopped, if desired
//   // BackgroundLocation.startLocationService(distanceFilter : 10,forceAndroidLocationManager: true);
//   // BackgroundLocation.getLocationUpdates((location) async {
//   //   List<AlarmDetails> alarms = [];
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   List<String>? alarmsJson = prefs.getStringList('alarms');
//   //   if (alarmsJson != null) {
//   //     alarms.addAll(
//   //         alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//   //             .toList());
//   //     for (var alarm in alarms) {
//   //       if (!alarm.isEnabled) {
//   //         continue;
//   //       }
//   //       double distance = calculateDistance(
//   //         LatLng(location.latitude!, location.longitude!),
//   //         LatLng(alarm.lat, alarm.lng),
//   //       );
//   //
//   //       if (distance <= alarm.locationRadius) {
//   //         var index=alarms.indexOf(alarm);
//   //         alarms[index].isEnabled=false;
//   //         SharedPreferences prefs = await SharedPreferences.getInstance();
//   //
//   //         List<Map<String, dynamic>> alarmsJson =
//   //         alarms.map((alarm) => alarm.toJson()).toList();
//   //
//   //         await prefs.setStringList(
//   //             'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//   //         // Trigger notification (potentially using a separate channel)
//   //         _showNotification(alarm);
//   //         break; // Exit loop after triggering the first alarm
//   //       }
//   //       print("distance:"+distance.toString());
//   //       print("location radius:"+alarm.locationRadius.toString());
//   //       print("location:"+location.toString());
//   //     }
//   //   }
//   // });
//   //await initializeService();
//   location.Location ls = new location.Location();
//   if(await Permission.notification.request().isGranted && await Permission.location.request().isGranted && await ls.serviceEnabled()){
//     await initializeService();
//   }
//   runApp(const MyApp());
// }
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   /// OPTIONAL, using custom notification channel id
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   if (Platform.isAndroid) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('ic_notification'),
//       ),
//     );
//   }
//
//   // await flutterLocalNotificationsPlugin
//   //     .resolvePlatformSpecificImplementation<
//   //     AndroidFlutterLocalNotificationsPlugin>()
//   //     ?.createNotificationChannel(channel);
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//
//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ), iosConfiguration: IosConfiguration(
//     // auto start service
//     autoStart: true,
//
//     // this will be executed when app is in foreground in separated isolate
//     onForeground: onStart,
//   ),
//   );
// }
// @pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings('ic_notification'),
//     ),
//   );
//
//   final LocationSettings locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100);
//
//   Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//           (Position? position) async {
//         List<AlarmDetails> alarms = [];
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.reload();
//         List<String>? alarmsJson = prefs.getStringList('alarms');
//         print(alarmsJson?.join(","));
//         if (alarmsJson != null) {
//           alarms.addAll(
//               alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//                   .toList());
//           for (var alarm in alarms) {
//             print("location radius:" + alarm.locationRadius.toString());
//             print("alarmname:" + alarm.alarmName);
//             if (!alarm.isEnabled) {
//               continue;
//             }
//             double distance = calculateDistance(
//               LatLng(position!.latitude, position.longitude),
//               LatLng(alarm.lat, alarm.lng),
//             );
//             print("distance:" + distance.toString());
//             if (distance <= alarm.locationRadius) {
//               var index = alarms.indexOf(alarm);
//               alarms[index].isEnabled = false;
//               List<Map<String, dynamic>> alarmsJson =
//               alarms.map((alarm) => alarm.toJson()).toList();
//               await prefs.setStringList(
//                   'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//               // Trigger notification with sound regardless of service state
//               final savedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
//               print(savedRingtone);
//               flutterLocalNotificationsPlugin.show(
//                 notificationId,
//                 alarm.alarmName,
//                 'Reached your place',
//                 NotificationDetails(
//                   android: AndroidNotificationDetails(
//                     Uuid().v4(),
//                     'MY FOREGROUND SERVICE',
//                     icon: 'ic_notification',
//                     sound: RawResourceAndroidNotificationSound(savedRingtone.replaceAll(".mp3", "")),
//                     priority: Priority.high,
//                     actions: [
//                       // Dismiss action
//                       AndroidNotificationAction(
//                         Uuid().v4(),
//                         'Dismiss',
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//               break; // Exit loop after triggering the first alarm
//             }
//           }
//         }
//       });
// }
//
// double degreesToRadians(double degrees) {
//   return degrees * math.pi / 180;
// }
// double calculateDistance(LatLng point1, LatLng point2) {
//   const double earthRadius = 6371000; // meters
//   double lat1 = degreesToRadians(point1.latitude);
//   double lat2 = degreesToRadians(point2.latitude);
//   double lon1 = degreesToRadians(point1.longitude);
//   double lon2 = degreesToRadians(point2.longitude);
//   double dLat = lat2 - lat1;
//   double dLon = lon2 - lon1;
//
//   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//       math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
//   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//   double distance = earthRadius * c;
//
//   return distance;
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4345b4)),
//         textTheme: GoogleFonts.robotoFlexTextTheme(),
//       ),
//       debugShowCheckedModeBanner: false,
//       home:Splashscreen(),
//     );
//   }
//
// }
//
//
//
// class Splashscreen extends StatefulWidget {
//   @override
//   _SplashscreenState createState() => _SplashscreenState();
// }
//
// class _SplashscreenState extends State<Splashscreen> {
//   // Simulate some initialization process (replace it with your actual initialization logic)
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       _checkUserStatus();
//     });
//   }
//   Future<void> _checkUserStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool hasSetSettings = prefs.getBool('hasSetSettings') ?? false; // Default to false if not set
//     print("hasSetSettings value: $hasSetSettings");
//     if (hasSetSettings) {
//       // User has set settings before, navigate to MyAlarmsPage
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => MyAlarmsPage()),
//       );
//     } else {
//       // User is setting settings for the first time, navigate to Settings page
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => Settings()),
//       );
//     }
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//     );
//   }
// }
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_mode/utils/constants.dart';
import 'package:untitiled/main.dart';
import 'package:untitiled/settingsexample.dart';
import 'package:uuid/uuid.dart';
import 'Apiutils.dart';
import 'Homescreens/homescreen.dart';
import 'package:geolocator/geolocator.dart';
import 'Homescreens/save_alarm_page.dart';
import 'Homescreens/settings.dart';
import 'Map screen page.dart';
import 'Track.dart';
import 'about page.dart';
import 'package:alarmplayer/alarmplayer.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'main.dart';
import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

const notificationChannelId = 'my_foreground';
const notificationId = 888;
const String channelId = 'your_channel_id';
const String channelName = 'Your Channel Name';
late AudioHandler _audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );

  // const AndroidInitializationSettings initializationSettingsAndroid =
  // AndroidInitializationSettings('ic_notification');
  // const InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );
  //
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveNotificationResponse:
  //       (NotificationResponse notificationResponse) async {
  //     switch (notificationResponse.notificationResponseType) {
  //       case NotificationResponseType.selectedNotificationAction:
  //         if (notificationResponse.actionId == "dismiss") {
  //           await flutterLocalNotificationsPlugin.cancelAll();
  //         }
  //         break;
  //       default:
  //     }
  //   },
  // );
  // BackgroundLocation.setAndroidNotification(
  //   title: "GPS Alarm",
  //   message: "Reached your place",
  //   icon: "@mipmap/ic_launcher",
  // );
  // BackgroundLocation.setAndroidConfiguration(1000);
  // BackgroundLocation.stopLocationService(); //To ensure that previously started services have been stopped, if desired
  // BackgroundLocation.startLocationService(distanceFilter : 10,forceAndroidLocationManager: true);
  // BackgroundLocation.getLocationUpdates((location) async {
  //   List<AlarmDetails> alarms = [];
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? alarmsJson = prefs.getStringList('alarms');
  //   if (alarmsJson != null) {
  //     alarms.addAll(
  //         alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
  //             .toList());
  //     for (var alarm in alarms) {
  //       if (!alarm.isEnabled) {
  //         continue;
  //       }
  //       double distance = calculateDistance(
  //         LatLng(location.latitude!, location.longitude!),
  //         LatLng(alarm.lat, alarm.lng),
  //       );
  //
  //       if (distance <= alarm.locationRadius) {
  //         var index=alarms.indexOf(alarm);
  //         alarms[index].isEnabled=false;
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //         List<Map<String, dynamic>> alarmsJson =
  //         alarms.map((alarm) => alarm.toJson()).toList();
  //
  //         await prefs.setStringList(
  //             'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
  //         // Trigger notification (potentially using a separate channel)
  //         _showNotification(alarm);
  //         break; // Exit loop after triggering the first alarm
  //       }
  //       print("distance:"+distance.toString());
  //       print("location radius:"+alarm.locationRadius.toString());
  //       print("location:"+location.toString());
  //     }
  //   }
  // });
  //await initializeService();
  location.Location ls = new location.Location();
  if (await Permission.notification.request().isGranted &&
      await Permission.location.request().isGranted &&
      await ls.serviceEnabled()) {
    await initializeService();
  }
  // _audioHandler = await AudioService.init(
  //   builder: () => MyAudioHandler(),
  //   config: AudioServiceConfig(
  //     androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
  //     androidNotificationChannelName: 'Music playback',
  //   ),
  // );
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      initialNotificationTitle: 'Running in Background',
      initialNotificationContent: 'This is required to trigger alarm',
      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
    ),
  );
}

class MyStream {
  StreamController<int> _controller = StreamController<int>();

  Stream<int> get stream => _controller.stream;

  void start() {
    // Start emitting values
    for (int i = 0; i < 10; i++) {
      _controller.add(i);
      Future.delayed(Duration(milliseconds: 500), () => _controller.add(i));
    }
  }

  void cancel() {
    _controller.close(); // Close the stream controller to stop emitting values
  }
}
// void onDidReceiveLocalNotification(
//     int id, String? title, String? body, String? payload) async {
//   if (payload == 'dismiss_alarm') {
//     Alarmplayer alarmplayer = Alarmplayer();
//     alarmplayer.StopAlarm(); // Stop the alarm on dismiss
//   }
//   // ... other notification display logic (optional)
// }
bool _shouldHandleNotifications = true;
dismissNotification(int? notificationId) async {
  await flutterLocalNotificationsPlugin.cancel(notificationId!);
}
String extractActionTypeFromPayload(String? payload) {
  String? actionType;  // Make the variable nullable

  // Extract action type from payload
  if (payload != null) {
    if (payload.contains('dismiss')) {
      actionType = 'dismiss';
      Alarmplayer alarmplayer = Alarmplayer();
      alarmplayer.StopAlarm();
      print("dismiss1");
    } else {
      // Handle other cases (extract other action types)
    }
  }
  if (actionType == null) {
    _shouldHandleNotifications = false;
    Alarmplayer alarmplayer = Alarmplayer();
    alarmplayer.StopAlarm();
    Vibration.cancel();
    print("dismiss2");
    print("cancel notification");
    // Handle the case where no action type is found
    return 'unknown';  // Return a default value
    // throw Exception('No action type found in payload');  // Throw an exception
  }
  return actionType;
}

void onDidReceiveNotificationResponse(NotificationResponse  notificationResponse) async {
  if (!_shouldHandleNotifications) {
    return; // Don't process the notification response
  }
  // handle action
  final String? payload = notificationResponse.payload;
  if (payload != null) {
    debugPrint('notification payload: $payload');
    // Extract relevant data from payload (e.g., action type)
    final actionType = extractActionTypeFromPayload(payload);
    // Handle dismissal based on action type (pseudocode)
    if (actionType == 'dismiss') {
      Alarmplayer alarmplayer = Alarmplayer();
      alarmplayer.StopAlarm();
      // Dismiss notification using a platform-specific method (explained later)
      dismissNotification(notificationResponse.id);
    } else {
      // Handle other notification actions (e.g., navigate to SecondScreen)
      // await Navigator.push(
      //
      //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
      // );
    }
  }
}

Future<bool> containsOption(String option) async {
  final prefs = await SharedPreferences.getInstance();
  final selectedOptions = prefs.getStringList('selectedOptions') ?? [];
  print("selectedoptions:$selectedOptions");
  return selectedOptions.contains(option);

}
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('ic_bg_service_small'),
  );

  // Define notification response callback with swipe handling

  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings (
      android: AndroidInitializationSettings('ic_bg_service_small'),
    ),
    // onDidReceiveNotificationResponse:
    //     (NotificationResponse notificationResponse) async {
    //   Alarmplayer alarmplayer = Alarmplayer();
    //   alarmplayer.StopAlarm();
    //   print("Tap means stop the alarm");
    //   // ...
    // },
    onDidReceiveBackgroundNotificationResponse:onDidReceiveNotificationResponse,
  );

  Future<void> playAlarm() async {
    // Get saved ringtone preference
    final prefs = await SharedPreferences.getInstance();
    final savedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
    final ringtonePath = 'assets/$savedRingtone'; // Assuming assets folder structure

    // Create Alarmplayer instance
    final alarmplayer = Alarmplayer();

    // Play alarm with saved ringtone path
    try {
      await alarmplayer.Alarm(
        url: ringtonePath,
        volume: 1.0, // Adjust volume as needed
        looping: false,
        // Set looping behavior (optional)
      );
      print("Alarm started playing!");
    } catch (error) {
      print("Error playing alarm: $error");
    } finally {
      // Optional: Clean up resources (consider if needed)
      // await alarmplayer.stop(); // Stop the alarm if necessary
    }

  }
  var notificationId1 = DateTime.now().millisecondsSinceEpoch;
  // final payload = notificationId1.toString();
  // final prefs = await SharedPreferences.getInstance();
  // final selectedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
  // final selectedOptions = prefs.getStringList('selectedOptions') ?? [];
  // print("Selectedoptions:$selectedOptions");
  // Use the loaded values as needed


  // Future<void> playAlarmSound(String filePath) async {
  //   AudioCache audioCache = AudioCache();
  //   await audioCache.load(filePath);

  // late  final AudioPlayer _audioPlayer = AudioPlayer();
  // Future<void> _playRingtone(String ringtone) async {
  //   // Ensure assets/alarm_ringtones/ is the correct path
  //   final ringtonePath = '$ringtone';
  //   try {
  //     await _audioPlayer.play(AssetSource(ringtonePath));
  //     // await _audioPlayer.setSource(AssetSource(ringtonePath));
  //     // await _audioPlayer.resume(); // Start playing the ringtone
  //   } catch (e) {
  //     if (e is PlatformException) {
  //       print('Audio playback error: ${e.message}'); // Log the entire error message
  //     } else {
  //       print('Unexpected error: $e');
  //     }
  //   }
  // }

  // for just_audio

  // MediaItem item = MediaItem(
  //   id: 'assets/audio/alarm1.mp3', // Replace with your audio asset path
  //   album: 'Album name',
  //   title: 'Track title',
  //   artist: 'Artist name',
  //   duration: const Duration(milliseconds: 123456),
  //   artUri: Uri.parse('assets/audio/alarm1.mp3'), // Replace if art is separate
  // );
  // void _audioPlayerTaskEntrypoint(dynamic data) async {
  //   await player.play();
  //   player.playerStateStream.listen((playerState) {
  //     if (playerState.processingState == ProcessingState.completed) {
  //       // Handle completion (e.g., loop, stop, next track)
  //     }
  //   });
  // }
  //
  // Future<void> _startPlaying() async {
  //   await AudioService.start( // Start the background audio service
  //     backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
  //   );
  //
  //   if (item != null) { // If you have a MediaItem, use its ID
  //     await player.setAudioSource(AudioSource.uri(Uri.parse(item.id)));
  //   } else { // Otherwise, use the direct path
  //     await player.setAudioSource(AudioSource.uri(Uri.parse('your_audio_path.mp3'))); // Replace with your path
  //   }
  //   await player.play(); // Start playback
  // }
  //
  //
  //
  final containsAlarms = await containsOption('alarms');
  final containsVibrate = await containsOption('vibrate');
  final containsAlarmsInSilentMode = await containsOption('alarms in silent mode');

  final LocationSettings locationSettings =
  LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);
  late StreamSubscription subscription;
  subscription =
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? position) async {
        List<AlarmDetails> alarms = [];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.reload();
        List<String>? alarmsJson = prefs.getStringList('alarms');
        print(alarmsJson?.join(","));
        if (alarmsJson != null) {
          alarms.addAll(alarmsJson
              .map((json) => AlarmDetails.fromJson(jsonDecode(json)))
              .where((element) => element.isEnabled)
              .toList());
          for (var alarm in alarms) {
            print("location radius:" + alarm.locationRadius.toString());
            print("alarmname:" + alarm.alarmName);
            if (!alarm.isEnabled) {
              continue;
            }
            double distance = calculateDistance(
              LatLng(position!.latitude, position.longitude),
              LatLng(alarm.lat, alarm.lng),
            );
            print("distance:" + distance.toString());
            if (distance <= alarm.locationRadius) {
              var index = alarms.indexOf(alarm);
              alarms[index].isEnabled = false;
              List<Map<String, dynamic>> alarmsJson =
              alarms.map((alarm) => alarm.toJson()).toList();
              await prefs.setStringList(
                  'alarms',
                  alarmsJson.map((json) => jsonEncode(json)).toList());
              final savedRingtone = prefs.getString('selectedRingtone') ??
                  "alarm6.mp3";
              flutterLocalNotificationsPlugin.show(
                notificationId,
                alarm.alarmName,
                'Reached destination radius',
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    Uuid().v4(),
                    'MY FOREGROUND SERVICE',
                    icon: 'ic_bg_service_small',
                    priority: Priority.high,
                    importance: Importance.max,
                    sound: RawResourceAndroidNotificationSound(
                        savedRingtone.replaceAll(".mp3", "")),
                    playSound: await containsOption('alarms') && !(await containsOption('alarms in silent mode')),
                    enableVibration: false,
                    additionalFlags: Int32List.fromList(<int>[4]),
                    ticker: 'ticker',
                    actions: [
                      // Dismiss action
                      AndroidNotificationAction(
                        Uuid().v4(),
                        'Dismiss',
                      ),

                      // Snooze action
                    ],
                    styleInformation: DefaultStyleInformation(true, true),
                  ),
                ),
              );

              if (await containsOption('alarms in silent mode')) {
                final prefs = await SharedPreferences.getInstance();
                final savedRingtone = prefs.getString('selectedRingtone') ??
                    "alarm6.mp3";
                // final isVibrateEnabled = prefs.getBool(kSharedPrefVibrate!) ?? false;
                // Trigger notification with sound regardless of service state
                playAlarm();
                print(savedRingtone);
                // flutterLocalNotificationsPlugin.show(
                //   notificationId,
                //   alarm.alarmName,
                //   'Reached destination radius',
                //   NotificationDetails(
                //     android: AndroidNotificationDetails(
                //       Uuid().v4(),
                //       'MY FOREGROUND SERVICE',
                //       icon: 'ic_bg_service_small',
                //       sound: RawResourceAndroidNotificationSound(
                //           savedRingtone.replaceAll(".mp3", "")),
                //       priority: Priority.high,
                //       importance: Importance.max,
                //       additionalFlags: Int32List.fromList(<int>[4]),
                //       vibrationPattern: Int64List.fromList(<int>[
                //         0, // Start immediately
                //         1000, // Vibrate for 1 second
                //         500, // Pause for 0.5 seconds
                //         1000, // Vibrate for 1 second
                //       ]),
                //       ticker: 'ticker',
                //       actions: [
                //         // Dismiss action
                //         AndroidNotificationAction(
                //           Uuid().v4(),
                //           'Dismiss',
                //         ),
                //         // Stop action
                //         // AndroidNotificationAction(
                //         //   'stop_action',
                //         //   'Stop',
                //         // ),
                //
                //         // Snooze action
                //       ],
                //       styleInformation: DefaultStyleInformation(true, true),
                //     ),
                //   ),
                // );
              }
              // else if (await containsOption('alarms')) {
              //   print("alarms value");
              //   final prefs = await SharedPreferences.getInstance();
              //   final savedRingtone = prefs.getString('selectedRingtone') ??
              //       "alarm6.mp3";
              //   // Trigger notification with sound regardless of service state
              //   print(savedRingtone);
              //
              //   // RingerModeStatus ringerStatus = await SoundMode.ringerModeStatus;
              //   // print("Ringer status: $ringerStatus");
              //
              //   // if (ringerStatus == RingerModeStatus.silent) {
              //   //   try {
              //   //     await SoundMode.setSoundMode(RingerModeStatus.normal);
              //   //     print('Sound mode set to normal');
              //   //   } on PlatformException {
              //   //     print('Please enable permissions required');
              //   //   }
              //   // } else {
              //   //   print('Device is not in silent mode');
              //   // }
              //   // Play the alarm sound
              //   // await playAlarmSound("locally saved the sound:"+savedRingtone);
              //   flutterLocalNotificationsPlugin.show(
              //     notificationId,
              //     alarm.alarmName,
              //     'Reached destination radius',
              //     NotificationDetails(
              //       android: AndroidNotificationDetails(
              //         Uuid().v4(),
              //         'MY FOREGROUND SERVICE',
              //         icon: 'ic_bg_service_small',
              //         sound: RawResourceAndroidNotificationSound(
              //             savedRingtone.replaceAll(".mp3", "")),
              //         priority: Priority.max,
              //         importance: Importance.max,
              //         additionalFlags: Int32List.fromList(<int>[4]),
              //         enableVibration: false,
              //         fullScreenIntent: true,
              //         playSound: true,
              //
              //         // vibrationPattern: Int64List.fromList(<int>[
              //         //   0, // Start immediately
              //         //   1000, // Vibrate for 1 second
              //         //   500, // Pause for 0.5 seconds
              //         //   1000, // Vibrate for 1 second
              //         // ]),
              //         ticker: 'ticker',
              //         actions: [
              //           // Dismiss action
              //           AndroidNotificationAction(
              //             Uuid().v4(),
              //             'Dismiss',
              //           ),
              //
              //         ],
              //         styleInformation: DefaultStyleInformation(true, true),
              //       ),
              //     ),
              //   );
              // }
              if (await containsOption('vibrate')) {
                // flutterLocalNotificationsPlugin.show(
                //   notificationId,
                //   alarm.alarmName,
                //   'Reached destination radius',
                //   NotificationDetails(
                //     android: AndroidNotificationDetails(
                //       Uuid().v4(),
                //       'MY FOREGROUND SERVICE',
                //       icon: 'ic_bg_service_small',
                //       priority: Priority.high,
                //       importance: Importance.max,
                //       playSound: false,
                //       enableVibration: true,
                //       additionalFlags: Int32List.fromList(<int>[4]),
                //       vibrationPattern: Int64List.fromList(<int>[
                //         0, // Start immediately
                //         10000, // Vibrate for 1 second
                //         5000, // Pause for 0.5 seconds
                //         10000, // Vibrate for 1 second
                //       ]),
                //       ticker: 'ticker',
                //       actions: [
                //         // Dismiss action
                //         AndroidNotificationAction(
                //           Uuid().v4(),
                //           'Dismiss',
                //         ),
                //         // Stop action
                //         // AndroidNotificationAction(
                //         //   'stop_action',
                //         //   'Stop',
                //         // ),
                //
                //         // Snooze action
                //       ],
                //       styleInformation: DefaultStyleInformation(true, true),
                //     ),
                //   ),
                // );
                Vibration.vibrate(
                  pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
                  intensities: [
                    0,
                    128,
                    0,
                    255,
                    0,
                    64,
                    0,
                    255,
                    0,
                    255,
                    0,
                    255,
                    0,
                    255
                  ],
                );
              }
              // else if (selectedOptions.contains('alarms') ||
              //     selectedOptions.contains('vibrate')) {
              //   final prefs = await SharedPreferences.getInstance();
              //   final savedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
              //   flutterLocalNotificationsPlugin.show(
              //     notificationId,
              //     alarm.alarmName,
              //     'Reached destination radius',
              //     NotificationDetails(
              //       android: AndroidNotificationDetails(
              //         Uuid().v4(),
              //         'MY FOREGROUND SERVICE',
              //         icon: 'ic_bg_service_small',
              //         priority: Priority.high,
              //         importance: Importance.max,
              //         playSound: true,
              //         sound: RawResourceAndroidNotificationSound(
              //             savedRingtone.replaceAll(".mp3", "")),
              //         enableVibration: true,
              //         ticker: 'ticker',
              //         actions: [
              //           // Dismiss action
              //           AndroidNotificationAction(
              //             Uuid().v4(),
              //             'Dismiss',
              //           ),
              //           // Stop action
              //           // AndroidNotificationAction(
              //           //   'stop_action',
              //           //   'Stop',
              //           // ),
              //
              //           // Snooze action
              //         ],
              //         styleInformation: DefaultStyleInformation(true, true),
              //       ),
              //     ),
              //   );
              //  await  Future.delayed(const Duration(milliseconds: 250), () {
              //     Vibration.vibrate(
              //       pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
              //       intensities: [
              //         0,
              //         128,
              //         0,
              //         255,
              //         0,
              //         64,
              //         0,
              //         255,
              //         0,
              //         255,
              //         0,
              //         255,
              //         0,
              //         255
              //       ],
              //     );
              //   });
              //   playAlarm();
              // }
//    if (
//           prefs.containsKey('alarms in silent mode')) {
//             final prefs = await SharedPreferences.getInstance();
//             final savedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
// // final isVibrateEnabled = prefs.getBool(kSharedPrefVibrate!) ?? false;
// // Trigger notification with sound regardless of service state
//             playAlarm();
//             print(savedRingtone);
//             flutterLocalNotificationsPlugin.show(
//               notificationId,
//               alarm.alarmName,
//               'Reached destination radius',
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   Uuid().v4(),
//                   'MY FOREGROUND SERVICE',
//                   icon: 'ic_bg_service_small',
// // sound: RawResourceAndroidNotificationSound(
// // savedRingtone.replaceAll(".mp3", "")),
//                   priority: Priority.high,
//                   importance: Importance.max,
//                   additionalFlags: Int32List.fromList(<int>[4]),
//                   vibrationPattern:Int64List.fromList(<int>[
//                     0, // Start immediately
//                     1000, // Vibrate for 1 second
//                     500, // Pause for 0.5 seconds
//                     1000, // Vibrate for 1 second
//                   ]),
//                   ticker: 'ticker',
//                   actions: [
// // Dismiss action
//                     AndroidNotificationAction(
//                       Uuid().v4(),
//                       'Dismiss',
//                     ),
// // Stop action
// // AndroidNotificationAction(
// //   'stop_action',
// //   'Stop',
// // ),
//
// // Snooze action
//                   ],
//                   styleInformation: DefaultStyleInformation(true, true),
//                 ),
//               ),
//             );
//           }
//           else if(prefs.containsKey('alarms')){
//             final prefs = await SharedPreferences.getInstance();
//             final savedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
// // Trigger notification with sound regardless of service state
//             print(savedRingtone);
//
//             flutterLocalNotificationsPlugin.show(
//               notificationId,
//               alarm.alarmName,
//               'Reached destination radius',
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   Uuid().v4(),
//                   'MY FOREGROUND SERVICE',
//                   icon: 'ic_bg_service_small',
//                   sound: RawResourceAndroidNotificationSound(
//                       savedRingtone.replaceAll(".mp3", "")),
//                   priority: Priority.max,
//                   importance: Importance.max,
//                   additionalFlags: Int32List.fromList(<int>[4]),
//                   enableVibration: false,
//                   fullScreenIntent: true,
//                   playSound: true,
//
// // vibrationPattern: Int64List.fromList(<int>[
// //   0, // Start immediately
// //   1000, // Vibrate for 1 second
// //   500, // Pause for 0.5 seconds
// //   1000, // Vibrate for 1 second
// // ]),
//                   ticker: 'ticker',
//                   actions: [
// // Dismiss action
//                     AndroidNotificationAction(
//                       Uuid().v4(),
//                       'Dismiss',
//                     ),
//
//                   ],
//                   styleInformation: DefaultStyleInformation(true, true),
//                 ),
//               ),
//             );
//
//           }
//
// // else if (prefs.containsKey('vibrate')) {
// //   await playVibration();
// // }
//           if (prefs.containsKey('vibrate' )){
//             flutterLocalNotificationsPlugin.show(
//               notificationId,
//               alarm.alarmName,
//               'Reached destination radius',
//               NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   Uuid().v4(),
//                   'MY FOREGROUND SERVICE',
//                   icon: 'ic_bg_service_small',
//                   priority: Priority.high,
//                   importance: Importance.max,
//                   playSound: false,
//                   enableVibration: true,
//                   additionalFlags: Int32List.fromList(<int>[4]),
//                   vibrationPattern: Int64List.fromList(<int>[
//                     0, // Start immediately
//                     10000, // Vibrate for 1 second
//                     5000, // Pause for 0.5 seconds
//                     10000, // Vibrate for 1 second
//                   ]),
//                   ticker: 'ticker',
//                   actions: [
// // Dismiss action
//                     AndroidNotificationAction(
//                       Uuid().v4(),
//                       'Dismiss',
//                     ),
// // Stop action
// // AndroidNotificationAction(
// //   'stop_action',
// //   'Stop',
// // ),
//
// // Snooze action
//                   ],
//                   styleInformation: DefaultStyleInformation(true, true),
//                 ),
//               ),
//             );
//             Vibration.vibrate(
//               pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
//               intensities: [0, 128, 0, 255, 0, 64, 0, 255 , 0 ,255 , 0 ,255 , 0, 255],
//             );
//           }
//           else {
//             print('No valid alarm option selected');
//           }
//         }
              print('preparing to stop service');
              break; // Exit loop after triggering the first alarm
            }
          }
          alarms = alarms.where((element) => element.isEnabled).toList();
          if (alarms.isEmpty) {
            subscription.cancel();
            service.invoke('stopped');
            service.stopSelf();
          }
        }
      }
      );

  service.on('stopService').listen((event) {
    print('stopping service');
    service.invoke('stopped');
    service.stopSelf();
    subscription.cancel();
  });
}

Future<void> stopService() async {
  // 1. Cancel location updates:// Cancels the location stream

  // 2. Stop foreground service (if running):
  if (defaultTargetPlatform == TargetPlatform.android) {
    const methodChannel = MethodChannel('com.yourdomain.yourapp/service');
    try {
      await methodChannel.invokeMethod('stopForegroundService');
    } on PlatformException catch (e) {
      // Handle platform exceptions (optional)
      print("Error stopping service: $e");
    }
  }

  // 3. (Optional) Clear notifications:
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancelAll();

  // 4. (Optional) Persist alarm data if needed:
  // ... Save alarms to SharedPreferences or other storage ...

  // 5. (Optional) Unregister any other listeners or resources

  print('Service stopped.');
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
      home: Splashscreen(),
      routes: {
        // Define your routes (optional)
        '/home': (context) => MyAlarmsPage(),
        '/secondpage': (context) => MyHomePage(),
        '/thirdpage': (context) => Settings(),
        'fouthpage': (context) => About(),
      },
    );
  }
}

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  // Simulate some initialization process (replace it with your actual initialization logic)
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSetSettings =
        prefs.getBool('hasSetSettings') ?? false; // Default to false if not set
    print("hasSetSettings value: $hasSetSettings");
    if (hasSetSettings) {
      // User has set settings before, navigate to MyAlarmsPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyAlarmsPage()),
      );
    } else {
      // User is setting settings for the first time, navigate to Settings page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Settings()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
