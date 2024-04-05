import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;

import 'package:background_location/background_location.dart';
import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Apiutils.dart';
import 'Homescreens/homescreen.dart';
import 'package:geolocator/geolocator.dart';
import 'Homescreens/save_alarm_page.dart';
import 'Track.dart';

const notificationChannelId = 'my_foreground';
const notificationId = 888;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  if(await Permission.notification.request().isGranted && await Permission.location.request().isGranted && await ls.serviceEnabled()){
    await initializeService();
  }
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
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
      notificationChannelId: notificationChannelId,
      foregroundServiceNotificationId: notificationId,
    ), iosConfiguration: IosConfiguration(
    // auto start service
    autoStart: true,

    // this will be executed when app is in foreground in separated isolate
    onForeground: onStart,
  ),
  );
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  // DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    // timeLimit: Duration(seconds:10 )
    );
    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) async {
                List<AlarmDetails> alarms = [];
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String>? alarmsJson = prefs.getStringList('alarms');
                if (alarmsJson != null) {
                  alarms.addAll(
                      alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
                          .toList());
                  for (var alarm in alarms) {
                    print("location radius:"+alarm.locationRadius.toString());
                    if (!alarm.isEnabled) {
                      continue;
                    }
                    double distance = calculateDistance(
                      LatLng(position!.latitude, position.longitude),
                      LatLng(alarm.lat, alarm.lng),
                    );
                    print("distance:"+distance.toString());

                    if (distance <= alarm.locationRadius) {
                      var index=alarms.indexOf(alarm);
                      alarms[index].isEnabled=false;
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      List<Map<String, dynamic>> alarmsJson =
                      alarms.map((alarm) => alarm.toJson()).toList();
                      await prefs.setStringList(
                          'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());

                      // Trigger notification (potentially using a separate channel)
                      if (service is AndroidServiceInstance) {
                        if (await service.isForegroundService()) {
                          final prefs = await SharedPreferences.getInstance();
                          final savedRingtone = prefs.getString('selectedRingtone')??"alarm6.mp3";
                          flutterLocalNotificationsPlugin.show(
                            notificationId,
                            alarm.alarmName,
                            'Reached your place',
                            NotificationDetails(
                              android: AndroidNotificationDetails(
                                notificationChannelId,
                                'MY FOREGROUND SERVICE',
                                icon: 'ic_notification',
                                ongoing: true,
                                sound: RawResourceAndroidNotificationSound(savedRingtone.replaceAll(".mp3", "")),
                                priority: Priority.low,
                              ),

                            ),
                          );
                        }
                      }
                      break; // Exit loop after triggering the first alarm
                    }
                  }
                }
              });
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
  //         if (service is AndroidServiceInstance) {
  //           if (await service.isForegroundService()) {
  //             flutterLocalNotificationsPlugin.show(
  //               notificationId,
  //               'COOL SERVICE',
  //               'Reached ${alarm.alarmName}',
  //               const NotificationDetails(
  //                 android: AndroidNotificationDetails(
  //                   notificationChannelId,
  //                   'MY FOREGROUND SERVICE',
  //                   icon: 'ic_notification',
  //                   ongoing: true,
  //                 ),
  //
  //               ),
  //             );
  //           }
  //         }
  //         break; // Exit loop after triggering the first alarm
  //       }
  //       print("distance:"+distance.toString());
  //       print("location radius:"+alarm.locationRadius.toString());
  //       print("location:"+location.toString());
  //     }
  //   }
  // });

  // ls.enableBackgroundMode(enable: true);
  // ls.onLocationChanged.listen((LocationData currentLocation) async {
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
  //         LatLng(currentLocation.latitude!, currentLocation.longitude!),
  //         LatLng(alarm.lat, alarm.lng),
  //       );
  //
  //       if (distance <= alarm.locationRadius) {
  //         var index = alarms.indexOf(alarm);
  //         alarms[index].isEnabled = false;
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //         List<Map<String, dynamic>> alarmsJson =
  //         alarms.map((alarm) => alarm.toJson()).toList();
  //
  //         await prefs.setStringList(
  //             'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
  //
  //         // Trigger notification (potentially using a separate channel)
  //         if (service is AndroidServiceInstance) {
  //           if (await service.isForegroundService()) {
  //             _showNotification(alarm);
  //             flutterLocalNotificationsPlugin.show(
  //               notificationId,
  //               'COOL SERVICE',
  //               'Reached ${alarm.alarmName}',
  //               const NotificationDetails(
  //                 android: AndroidNotificationDetails(
  //                   notificationChannelId,
  //                   'MY FOREGROUND SERVICE',
  //                   icon: 'ic_notification',
  //                   ongoing: true,
  //                 ),
  //
  //               ),
  //             );
  //           }
  //         }
  //         break; // Exit loop after triggering the first alarm
  //       }
  //       print("distance:" + distance.toString());
  //       print("location radius:" + alarm.locationRadius.toString());
  //     }
  //   }
  // });
}

// Future<void> initializeService() async {
//   BackgroundLocation.setAndroidNotification(
//     title: "GPS Alarm",
//     message: "Reached your place",
//     icon: "@mipmap/ic_launcher",
//   );
//   BackgroundLocation.setAndroidConfiguration(1000);
//   BackgroundLocation.stopLocationService(); //To ensure that previously started services have been stopped, if desired
//   BackgroundLocation.startLocationService(distanceFilter : 10,forceAndroidLocationManager: true);
//   BackgroundLocation.getLocationUpdates((location) async {
//     List<AlarmDetails> alarms = [];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? alarmsJson = prefs.getStringList('alarms');
//     if (alarmsJson != null) {
//       alarms.addAll(
//           alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//               .toList());
//       for (var alarm in alarms) {
//         if (!alarm.isEnabled) {
//           continue;
//         }
//         double distance = calculateDistance(
//           LatLng(location.latitude!, location.longitude!),
//           LatLng(alarm.lat, alarm.lng),
//         );
//
//         if (distance <= alarm.locationRadius) {
//           var index=alarms.indexOf(alarm);
//           alarms[index].isEnabled=false;
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//
//           List<Map<String, dynamic>> alarmsJson =
//           alarms.map((alarm) => alarm.toJson()).toList();
//
//           await prefs.setStringList(
//               'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//           // Trigger notification (potentially using a separate channel)
//           _showNotification(alarm);
//           break; // Exit loop after triggering the first alarm
//         }
//         print("distance:"+distance.toString());
//         print("location radius:"+alarm.locationRadius.toString());
//         print("location:"+location.toString());
//       }
//     }
//   });
//
//   // final service = FlutterBackgroundService();
//   // await service.configure(
//   //   androidConfiguration: AndroidConfiguration(
//   //     // this will be executed when app is in foreground or background in separated isolate
//   //     onStart: onStart,
//   //     // auto start service
//   //     autoStart: true,
//   //     isForegroundMode: true,
//   //
//   //     notificationChannelId: 'my_foreground',
//   //     initialNotificationTitle: 'AWESOME SERVICE',
//   //     initialNotificationContent: 'Initializing',
//   //     foregroundServiceNotificationId: 888,
//   //   ),
//   //   iosConfiguration: IosConfiguration(autoStart: false),
//   // );
//
// }
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   BackgroundLocation.getLocationUpdates((location) async {
//     List<AlarmDetails> alarms = [];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? alarmsJson = prefs.getStringList('alarms');
//     if (alarmsJson != null) {
//       alarms.addAll(
//           alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//               .toList());
//       for (var alarm in alarms) {
//         if (!alarm.isEnabled) {
//           continue;
//         }
//         double distance = calculateDistance(
//           LatLng(location.latitude!, location.longitude!),
//           LatLng(alarm.lat, alarm.lng),
//         );
//
//         if (distance <= alarm.locationRadius) {
//           var index=alarms.indexOf(alarm);
//           alarms[index].isEnabled=false;
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//
//           List<Map<String, dynamic>> alarmsJson =
//           alarms.map((alarm) => alarm.toJson()).toList();
//
//           await prefs.setStringList(
//               'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//           // Trigger notification (potentially using a separate channel)
//           _showNotification(alarm);
//           break; // Exit loop after triggering the first alarm
//         }
//         print("distance:"+distance.toString());
//         print("location radius:"+alarm.locationRadius.toString());
//         print("location:"+location.toString());
//       }
//     }
//   });
// }
Future<void> _showNotification(AlarmDetails alarm) async {
  late String selectedRingtone;
  final prefs = await SharedPreferences.getInstance();
  final savedRingtone = prefs.getString('selectedRingtone')??"alarm6.mp3";


  print("Ringtone:" +savedRingtone.replaceAll(".mp3", ""));
  AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          "23",
          'Dismiss',
        ),
      ],
      sound: RawResourceAndroidNotificationSound(savedRingtone.replaceAll(".mp3", "")),

      ticker: 'ticker');
  // String ringtonePath = 'assets/$selectedRingtone'; // Construct the path

  // AndroidNotificationDetails androidNotificationDetails =
  // AndroidNotificationDetails(
  //     'your channel id', 'your channel name',
  //     channelDescription: 'your channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     actions: [
  //       AndroidNotificationAction("23", 'Dismiss',),
  //     ],
  //     sound: RawResourceAndroidNotificationSound(selectedRingtone), // Use the constructed path
  //     ticker: 'ticker');
  NotificationDetails notificationDetails =
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



