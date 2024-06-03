import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

Future<void> onStart(ServiceInstance service) async {
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('ic_bg_service_small'),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
  );

  Future<void> playAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
    final ringtonePath = 'assets/$savedRingtone';

    final alarmplayer = Alarmplayer();

    try {
      await alarmplayer.Alarm(
        url: ringtonePath,
        volume: 1.0,
        looping: false,
      );
      print("Alarm started playing!");
    } catch (error) {
      print("Error playing alarm: $error");
    }
  }

  final containsAlarms = await containsOption('alarms');
  final containsVibrate = await containsOption('vibrate');
  final containsAlarmsInSilentMode = await containsOption('alarms in silent mode');

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  StreamSubscription<Position>? subscription;
  subscription = Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position? position) async {
    if (position != null) {
      List<AlarmDetails> alarms = [];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.reload();
      List<String>? alarmsJson = prefs.getStringList('alarms');
      if (alarmsJson != null) {
        alarms.addAll(alarmsJson
            .map((json) => AlarmDetails.fromJson(jsonDecode(json)))
            .where((element) => element.isEnabled)
            .toList());

        for (var alarm in alarms) {
          if (!alarm.isEnabled) {
            continue;
          }

          double distance = calculateDistance(
            LatLng(position.latitude, position.longitude),
            LatLng(alarm.lat, alarm.lng),
          );

          print("Distance to target: $distance km");

          if (distance <= alarm.locationRadius) {
            // Alarm actions here
            var index = alarms.indexOf(alarm);
            alarms[index].isEnabled = false;
            List<Map<String, dynamic>> alarmsJson =
            alarms.map((alarm) => alarm.toJson()).toList();
            await prefs.setStringList(
                'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());

            if (await containsOption('alarms in silent mode')) {
              playAlarm();
            } else if (await containsOption('vibrate')) {
              Vibration.vibrate(
                pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
                intensities: [0, 128, 0, 255, 0, 64, 0, 255, 0, 255, 0, 255, 0, 255],
              );
            }

            print('Preparing to stop service');
            break;
          }

          // Adjust location update frequency based on remaining distance
          if (distance <= 150) {
            subscription?.pause();
            Future.delayed(Duration(minutes: 5), () {
              subscription?.resume();
            });
          } else if (distance <= 100) {
            subscription?.pause();
            Future.delayed(Duration(minutes: 10), () {
              subscription?.resume();
            });
          }
        }
      }
    }
  });

  service.on('stopService').listen((event) {
    print('Stopping service');
    service.invoke('stopped');
    service.stopSelf();
    subscription?.cancel();
  });
}

double calculateDistance(LatLng start, LatLng end) {
  final Distance distance = Distance();
  return distance.as(LengthUnit.Kilometer, start, end);
}

Future<bool> containsOption(String option) async {
  final prefs = await SharedPreferences.getInstance();
  final selectedOptions = prefs.getStringList('selectedOptions') ?? [];
  return selectedOptions.contains(option);
}

class AlarmDetails {
  final String alarmName;
  final double lat;
  final double lng;
  final double locationRadius;
  final bool isEnabled;

  AlarmDetails({
    required this.alarmName,
    required this.lat,
    required this.lng,
    required this.locationRadius,
    required this.isEnabled,
  });

  factory AlarmDetails.fromJson(Map<String, dynamic> json) {
    return AlarmDetails(
      alarmName: json['alarmName'],
      lat: json['lat'],
      lng: json['lng'],
      locationRadius: json['locationRadius'],
      isEnabled: json['isEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alarmName': alarmName,
      'lat': lat,
      'lng': lng,
      'locationRadius': locationRadius,
      'isEnabled': isEnabled,
    };
  }
}
