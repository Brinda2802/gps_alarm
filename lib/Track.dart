import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Apiutils.dart';
import 'Track.dart';
import 'Track.dart';

int id = 0;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class Track extends StatefulWidget {
  final AlarmDetails? alarm;

  const Track({super.key, this.alarm});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {


  bool _notificationsEnabled = false;

  TextEditingController controller = TextEditingController();
  GoogleMapController? mapController;
  location.LocationData? currentLocation;
  location.Location _locationService = location.Location();
  bool _isCameraMoving = true;
  final LatLng _defaultLocation = const LatLng(
      13.067439, 80.237617); // Default location

  TextEditingController searchController = TextEditingController();
  List<AlarmDetails> alarms = [];
  Set<Marker> _markers={};
  Set<Circle> _circles={};
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();

    _isAndroidPermissionGranted();
    _requestPermissions();


    loadData();
    markLocation();
    // Initialize the notification plugin

  }
  double degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  // Calculate distance between two LatLng points
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
  void checkAlarm() {
    // Check if current location is within any alarm radius
    if (currentLocation != null) {
      log("checking alarm");
      for (var alarm in alarms) {
        double distance = calculateDistance(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          LatLng(alarm.lat, alarm.lng),
        );
        log('$distance-${alarm.locationRadius}');

        if (distance <= alarm.locationRadius) {
          log('triggering');
          // Alarm is triggered
          _showNotification(alarm);
          break; // Exit loop after triggering the first alarm
        }
      }
    }
  }
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // Future markLocation() async {
  //   Marker? current;
  //   ByteData byteData = await rootBundle.load('assets/locationimage.png');
  //   Uint8List imageData = byteData.buffer.asUint8List();
  //
  //   // Create a BitmapDescriptor from the image data
  //   BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(imageData);
  //
  //   setState(() {
  //     if (_markers.isNotEmpty) {
  //       current = _markers.first;
  //     }
  //
  //     _markers.clear();
  //     _circles.clear();
  //     if (current != null) {
  //       _markers.add(current!);
  //     }
  //
  //
  //     print(alarms.toString());
  //     if (widget.alarm!=null){
  //       _markers.add(Marker(
  //         markerId: MarkerId(const Uuid().v4()),
  //         icon: customIcon,
  //         position: LatLng(widget.alarm!.lat, widget.alarm!.lng),
  //       ));
  //
  //       _circles.add(Circle(
  //
  //         onTap: (){
  //
  //         },
  //         circleId: CircleId(const Uuid().v4()),
  //         center: LatLng(widget.alarm!.lat, widget.alarm!.lng),
  //         radius: widget.alarm!.locationRadius, // Set your desired radius in meters
  //         fillColor: Colors.blue.withOpacity(0.3),
  //         strokeColor: Colors.blue,
  //         strokeWidth: 2,
  //       ));
  //     }
  //     else{
  //       _markers.addAll(
  //         alarms.map((AlarmDetails alarm) => Marker(
  //           markerId: MarkerId(const Uuid().v4()),
  //           icon: customIcon,
  //           position: LatLng(alarm.lat, alarm.lng),
  //         )),
  //       );
  //       _circles.addAll(
  //         alarms.map((AlarmDetails alarm) => Circle(
  //           circleId: CircleId(const Uuid().v4()),
  //           center: LatLng(alarm.lat, alarm.lng),
  //           radius:  alarm!.locationRadius, // Set your desired radius in meters
  //           fillColor: Colors.blue.withOpacity(0.3),
  //           strokeColor: Colors.blue,
  //           strokeWidth: 2,
  //         ),
  //       ));
  //     }
  //   });
  // }
  Future markLocation() async {
    Marker? current;
    ByteData byteData = await rootBundle.load('assets/locationimage.png');
    Uint8List imageData = byteData.buffer.asUint8List();

    // Create a BitmapDescriptor from the image data
    BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(imageData);

    setState(() {
      if (_markers.isNotEmpty) {
        current = _markers.first;
      }

      _markers.clear();
      _circles.clear();
      if (current != null) {
        _markers.add(current!);
      }

      if (widget.alarm != null) {
        // Add marker for alarm
        _markers.add(Marker(
          markerId: MarkerId( widget.alarm!.id), // Use the same ID for the marker
          icon: customIcon,
          position: LatLng(widget.alarm!.lat, widget.alarm!.lng),
          draggable: true, // Enable marker dragging
          onDragEnd: (newPosition) async {
            setState(() {
              AlarmDetails old = alarms.firstWhere((element) => element.id == widget.alarm!.id);
              old.lat = newPosition.latitude;
              old.lng = newPosition.longitude;
              alarms.removeWhere((element) => element.id == widget.alarm!.id);
              alarms.add(old);
            });

            SharedPreferences prefs = await SharedPreferences.getInstance();
            List<Map<String, dynamic>> alarmsJson =
            alarms.map((alarm) => alarm.toJson()).toList();
            await prefs.setStringList(
                'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
            await loadData();
            await markLocation();
          },
        ));

        // Add circle for alarm
        _circles.add(Circle(
          circleId: CircleId(widget.alarm!.id), // Use the same ID for the circle
          center: LatLng(widget.alarm!.lat, widget.alarm!.lng),
          radius: widget.alarm!.locationRadius, // Set your desired radius in meters
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ));
      } else {
        // Add markers and circles for all alarms
        _markers.addAll(
          alarms.map((AlarmDetails alarm) => Marker(
            markerId: MarkerId(alarm.id), // Use unique IDs for markers
            icon: customIcon,
            position: LatLng(alarm.lat, alarm.lng),
            draggable: true, // Enable marker dragging
            onDragEnd: (newPosition) async {
              setState(() {
                AlarmDetails old = alarms.firstWhere((element) => element.id == alarm.id);
                old.lat = newPosition.latitude;
                old.lng = newPosition.longitude;
                alarms.removeWhere((element) => element.id == alarm.id);
                alarms.add(old);
              });

              SharedPreferences prefs = await SharedPreferences.getInstance();
              List<Map<String, dynamic>> alarmsJson =
              alarms.map((alarm) => alarm.toJson()).toList();
              await prefs.setStringList(
                  'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
              await loadData();
              await markLocation();
            },
          )),
        );
        _circles.addAll(
          alarms.map((AlarmDetails alarm) => Circle(
            circleId: CircleId(alarm.id), // Use unique IDs for circles
            center: LatLng(alarm.lat, alarm.lng),
            radius: alarm.locationRadius, // Set your desired radius in meters
            fillColor: Colors.blue.withOpacity(0.3),
            strokeColor: Colors.blue,
            strokeWidth: 2,
          )),
        );
      }
    });
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? alarmsJson = prefs.getStringList('alarms');
    print("alarms");
    print(alarmsJson);

    if (alarmsJson != null) {
      alarms = alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json))).toList();
    } else {
      alarms = [];
    }

    setState(() {});
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }
  bool _isNotificationShown=false;

  Future<void> _showNotification(AlarmDetails alarm) async {
   // Exit if notification already shown
    if (_isNotificationShown) return; // Exit if notification already shown

    // ... rest of your notification code ...

    _isNotificationShown = true;

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


  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    location.PermissionStatus permissionStatus = await _locationService
        .hasPermission();
    if (permissionStatus == location.PermissionStatus.denied) {
      permissionStatus = await _locationService.requestPermission();
      if (permissionStatus != location.PermissionStatus.granted) {
        return;
      }
      _startLocationUpdates();
    }
    LatLng? _current = const LatLng(
        13.067439, 80.237617);
    LatLng? _target = null;
    log("location 1");
    _locationService.onLocationChanged.listen((
        location.LocationData newLocation) async {
      log("location changed");
      if (_isCameraMoving) return;

      setState(() {
        if (newLocation.latitude != null && newLocation.longitude != null) {
          _current = LatLng(newLocation.latitude!, newLocation.longitude!);
        }
        currentLocation = newLocation;

        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId("_currentLocation"),
          icon: BitmapDescriptor.defaultMarker,
          position: currentLocation != null
              ? LatLng(
              currentLocation!.latitude!, currentLocation!.longitude!)
              : _defaultLocation,
        ));
      });

      await markLocation();

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(
          LatLng(newLocation.latitude!, newLocation.longitude!),
        ));
      }
print("alarm ring");
      checkAlarm();
    });
    log("location 2");
  }
  void _startLocationUpdates() {
    // Listen for location changes
    _locationService.onLocationChanged.listen((location.LocationData newLocation) async {
      // Handle location updates
      // Update UI, trigger actions, etc.
    });
  }
  Future<void> initializeNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings(
        'ic_notification'); //TODO: Replace 'icon' with your notification icon resource name

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

body:  Stack(
  children: [

  GoogleMap(
    circles: _circles,
    zoomGesturesEnabled: true,
    mapType: MapType.normal,
    myLocationButtonEnabled: false,
    zoomControlsEnabled: false,
    initialCameraPosition: CameraPosition(
      zoom: 20,
      target: _defaultLocation,
    ),
    onMapCreated: (GoogleMapController controller) {
      mapController = controller;
    },
    markers: _markers,


    onCameraMoveStarted: () {
      setState(() {
        _isCameraMoving = true;
      });
    },
    onCameraIdle: () {
      setState(() {
        _isCameraMoving = false;
      });
    },

  ),
    Padding(
      padding: const EdgeInsets.only(left: 280.0,top: 500),
      child: FloatingActionButton(
        onPressed: () {
          mapController?.animateCamera(
            CameraUpdate.zoomIn(),
          );
        },
        child: Icon(Icons.add),
      ),
    ),

    Padding(
      padding: const EdgeInsets.only(left: 280.0,top: 600),
      child: FloatingActionButton(
        onPressed: () {
          mapController?.animateCamera(
            CameraUpdate.zoomOut(),
          );
        },
        child: Icon(Icons.remove),
      ),
    ),

  ],
),




    );


  }



}
