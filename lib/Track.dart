import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitiled/Map%20screen%20page.dart';
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
import 'Homescreens/save_alarm_page.dart';
import 'Homescreens/settings.dart';
import 'Track.dart';
import 'Track.dart';
import 'about page.dart';
import 'main.dart';

int id = 0;
const int notificationId = 123;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class Track extends StatefulWidget {
  final AlarmDetails? alarm;
  final String?selectedRingtone;
  //final String selectedRingtone;
  const Track({super.key, this.alarm, this.selectedRingtone,  });

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  double radius=0;
  updateradiusvalue(value){
    print("updatevalue:"+value.toString());
    setState(() {
      radius=value;
      print("updatevalue:"+value.toString());
    });
  }

  double targetZoomLevel = 15.0;

  bool isMapInitialized = false;
  GoogleMapController? mapController;
  bool _imperial = false;
  late String ringtonePath;
  late String selectedRingtone;
  void _saveSelectedRingtone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRingtone', selectedRingtone!);
  }
  Future<void> _loadSelectedRingtone() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRingtone = prefs.getString('selectedRingtone')??"alarm6.mp3";
    if (savedRingtone != null) {
      setState(() {
        selectedRingtone = savedRingtone;
      });
    }
  }

  bool isAnimated=false;
  bool _notificationsEnabled = false;
  TextEditingController controller = TextEditingController();

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
    _loadSelectedRingtone();
    _saveSelectedRingtone();
    loadData();
    markLocation();
    setState(() {
      radius=widget.alarm!.locationRadius;
    });


       // Initialize the notification plugin
    }
  double degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }
  //Calculate distance between two LatLng points
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
  bool _handletap = false;

  // double calculateDistanceInKm(LatLng point1, LatLng point2) {
  //   const double earthRadius = 6371000; // meters
  //
  //   double lat1 = degreesToRadians(point1.latitude);
  //   double lat2 = degreesToRadians(point2.latitude);
  //   double lon1 = degreesToRadians(point1.longitude);
  //   double lon2 = degreesToRadians(point2.longitude);
  //
  //   double dLat = lat2 - lat1;
  //   double dLon = lon2 - lon1;
  //
  //   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
  //       math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
  //   num c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  //   double distanceInMeters = earthRadius * c;
  //
  //   // Convert meters to kilometers and return the result
  //   return distanceInMeters / 1000;
  // }

  void checkAlarm() {
    // Check if current location is within any alarm radius
    if (currentLocation != null) {
      log("checking alarm");
      for (var alarm in alarms) {
        if(alarm.isEnabled==false){
          continue;
        }
        double distance = calculateDistance(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          LatLng(alarm.lat, alarm.lng),
        );
        log('$distance-${alarm.locationRadius}');

        if (distance <= alarm.locationRadius) {
          log('triggering');
          // Alarm is triggered

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
  LatLng? _target = null;
  Future markLocation() async {
   // double radius = radius;
    Marker? current;
    ByteData byteData = await rootBundle.load('assets/locationmark10.png');
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
        AlarmDetails alarmDetails = alarms.firstWhere((element) => element.id == widget.alarm!.id);

        // Add marker for alarm
        _markers.add(Marker(

          markerId: MarkerId( alarmDetails.id), // Use the same ID for the marker
          icon: customIcon,
          position: LatLng(alarmDetails.lat, alarmDetails.lng),
          draggable: true,

       // Enable marker dragging
          onDragEnd: (newPosition) async {

            setState(() {
              AlarmDetails old = alarms.firstWhere((element) => element.id == widget.alarm!.id);
              old.lat = newPosition.latitude;
              old.lng = newPosition.longitude;
              alarms.removeWhere((element) => element.id == widget.alarm!.id);
              alarms.add(old);
            });
            List<Placemark> placemarks = await placemarkFromCoordinates(newPosition.latitude, newPosition.longitude);

            // Extract the location name from the placemark
            String locationName = placemarks.isEmpty ? 'Default' : [
              placemarks[0].name,
              placemarks[0].subLocality,
              placemarks[0].locality,
            ].toList()
                .where((element) => element != null && element != '')
                .join(', ');

            // Update the alarm name controller with the location name (optional)
            alramnamecontroller.text = locationName;

            SharedPreferences prefs = await SharedPreferences.getInstance();
            List<Map<String, dynamic>> alarmsJson =
            alarms.map((alarm) => alarm.toJson()).toList();
            await prefs.setStringList(
                'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());

             await loadData();
            await markLocation();
            _showCustomBottomSheet(
                context,);
          },
        ));
        print("locationradius:" +widget.alarm!.locationRadius.toString());
        // Add circle for alarm
        _circles.add(Circle(
          circleId: CircleId(alarmDetails.id), // Use the same ID for the circle
          center: LatLng(alarmDetails.lat, alarmDetails.lng),
          radius: alarmDetails.locationRadius, // Set your desired radius in meters
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
  void saveAlarm(BuildContext context) async {
    // if (alramnamecontroller.text.isEmpty ||
    //
    //     radius == null) {
    //   Navigator.of(context).pop();
    //   // Show a Snackbar prompting the user to fill in the required fields
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please fill in all the required fields.'),
    //
    //     ),
    //   );
    //   return; // Exit the function without saving the data
    // }
    print("locationradius:" +radius.toString(),);

    setState(() {

      AlarmDetails newAlarm = AlarmDetails(
        alarmName: alramnamecontroller.text,
        notes: notescontroller.text,
        locationRadius:  radius,
        isAlarmOn: true, isFavourite: false, lat: _target!.latitude, lng: _target!.longitude, id:Uuid().v4(), isEnabled: true,
      );
      alarms.add(newAlarm);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> alarmsJson =
    alarms.map((alarm) => alarm.toJson()).toList();
    await prefs.setStringList(
        'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());

    loadData();
    Navigator.of(context).pop();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyAlarmsPage(


        ),
      ),
    );
  }
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String alarmName = alramnamecontroller.text;
    String notes = notescontroller.text;
    double radius = widget.alarm!.locationRadius;; // Assuming you have a way to get the radius
    // Save data to SharedPreferences
    await prefs.setString('alarmName', alarmName);
    await prefs.setDouble('radius', radius);
    await prefs.setString('notes', notes);
    List<String>? alarmsJson = prefs.getStringList('alarms');
    print("alarms");
    print(alarmsJson);
    setState(() {
      if (alarmsJson != null) {
        alarms = alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json))).toList();
      } else {
        alarms = [];
      }
    });
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
  final _formKey = GlobalKey<FormState>();
  bool _isNotificationShown=false;
  TextEditingController notescontroller = TextEditingController();
  // Initialize the TextEditingController with the default value
  TextEditingController alramnamecontroller = TextEditingController(text: "Welcome");
  //   Future<void> _showNotification(AlarmDetails alarm) async {
//    // Exit if notification already shown
//     if (_isNotificationShown) return; // Exit if notification already shown
//
//     // ... rest of your notification code ...
//
//     _isNotificationShown = true;
//     _loadSelectedRingtone();
// print("Ringtone:" +selectedRingtone.replaceAll(".mp3", ""));
//      AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails('your channel id', 'your channel name',
//         channelDescription: 'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         actions: [
//           AndroidNotificationAction(
//             "23",
//             'Dismiss',
//           ),
//         ],
//         sound: RawResourceAndroidNotificationSound(selectedRingtone.replaceAll(".mp3", "")),
//
//         ticker: 'ticker');
//    // String ringtonePath = 'assets/$selectedRingtone'; // Construct the path
//
//     // AndroidNotificationDetails androidNotificationDetails =
//     // AndroidNotificationDetails(
//     //     'your channel id', 'your channel name',
//     //     channelDescription: 'your channel description',
//     //     importance: Importance.max,
//     //     priority: Priority.high,
//     //     actions: [
//     //       AndroidNotificationAction("23", 'Dismiss',),
//     //     ],
//     //     sound: RawResourceAndroidNotificationSound(selectedRingtone), // Use the constructed path
//     //     ticker: 'ticker');
//         NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//         await flutterLocalNotificationsPlugin.show(
//         id++, alarm.alarmName, "Reached your place", notificationDetails,
//         payload: 'item x');
//      // Exit if notification already shown
//
//   }
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
    LatLng? _current =  LatLng(
        13.067439, 80.237617);
    _target = LatLng(widget.alarm!.lat, widget.alarm!.lng);
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

      // if (mapController != null) {
      //
      //   mapController!.animateCamera(CameraUpdate.newLatLng(
      //     LatLng(newLocation.latitude!, newLocation.longitude!),
      //   ));
      // }
      if (mapController != null && !isAnimated ) {
        isAnimated = true;
        // Calculate bounds containing both markers
        LatLngBounds bounds = LatLngBounds      (
          southwest: _calculateMarkerBounds(_current, _target).southwest,
          northeast: _calculateMarkerBounds(_current, _target).northeast,
        );
        // Animate camera to fit both markers with some padding
        double padding = 0.05; // Adjust padding as needed
        CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
          padLatLngBounds(bounds,0.60),padding
        );
        await mapController!.animateCamera(cameraUpdate);
      }
      print("alarm ring");
      checkAlarm();
    });
    log("location 2");
  }
  void _showCustomBottomSheet(BuildContext context)async {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    // if (!_handletap) {
    //
    //   // Show a snackbar if a destination is not selected
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please select a destination on the map.'),
    //     ),
    //   );
    //   return;
    // }
    loadData();
    alramnamecontroller.text;
    notescontroller.text = widget.alarm!.notes;
  //  notescontroller.clear();
    List<AlarmDetails> alarms = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? alarmsJson = prefs.getStringList('alarms');
    if (alarmsJson != null) {
      alarms = alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json))).toList();
    } else {
      alarms = [];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        String counterText;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 390,
            width: double.infinity,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Call the saveAlarm function
                      },
                      child: Text("Cancel"),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left:width/3),
                      child: FilledButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          int index = alarms.indexWhere((alarm) =>
                          alarm.id == widget.alarm!.id);
                          if (index == -1) {
                            // Alarm not found, handle error (optional)
                            return;
                          }
                          // Get values from UI elements
                          String newAlarmName = alramnamecontroller.text;
                          String newNotes = notescontroller.text;
                          double newRadius = radius;
                          // Update the alarm details
                          alarms[index].alarmName = newAlarmName;
                          alarms[index].notes = newNotes;
                          alarms[index].locationRadius = newRadius;

                          // Save the updated list of alarms as JSON strings
                          List<Map<String, dynamic>> alarmsJson =
                          alarms.map((alarm) => alarm.toJson()).toList();
                          await prefs.setStringList(
                              'alarms',
                              alarmsJson.map((json) => jsonEncode(json))
                                  .toList());

                          // Optionally, clear UI elements or navigate to MyAlarmsPage
                          alramnamecontroller.text = '';
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Success"),
                                  content: Text(
                                      "Location changed successfully."),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyAlarmsPage()),
                                        );
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              }
                          );

                          // // You can optionally navigate to MyAlarmsPage here
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (context) => MyAlarmsPage()),
                          // );



                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                          // List<Map<String, dynamic>> alarmsJson =
                          // alarms.map((alarm) => alarm.toJson()).toList();
                          // await prefs.setStringList(
                          //     'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
                          // await loadData();
                         //  String alarmName = alramnamecontroller.text;
                         //  String notes = notescontroller.text;
                         //
                         //
                         //  // Create a new AlarmDetails object
                         //  AlarmDetails newAlarm = AlarmDetails(
                         //    alarmName: alarmName,
                         //    notes: notes, id: '', locationRadius: , isEnabled: , isFavourite: , lat: , lng: ,
                         //
                         //    // Add other fields for your AlarmDetails class if needed
                         //  );
                         //
                         //  // Add the new alarm to the existing alarms list
                         //  alarms.add(newAlarm);
                         //
                         //  // Save the updated list of alarms as JSON strings
                         //  List<String> alarmsToSave = alarms.map((alarm) => alarm.toJson()).toList();
                         //  await prefs.setStringList('alarms', alarmsToSave);
                         //
                         //  // Get values from UI elements
                         // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyAlarmsPage()));
                         // // Call the saveAlarm function
                         //  saveAlarm( context);
                         //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyAlarmsPage()));
                        },
                        child: Text("Save"),
                      ),
                    ),
                  ],
                ),

                // Integrate the MeterCalculatorWidget
                MeterCalculatorWidget(
                  callback: updateradiusvalue,
                  //radius: widget.alarm?.locationRadius,
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text("Alarm Name:", style: Theme.of(context).textTheme.titleMedium,),
                //
                //     Container(
                //       height:height/ 15.12,
                //       width: width/1.2,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(color: Colors.black12),
                //
                //       ),child: Padding(
                //       padding:  EdgeInsets.only(left: width/36),
                //       child: TextField(
                //         controller: alramnamecontroller,
                //
                //         style: Theme.of(context).textTheme.bodyMedium,
                //         decoration: InputDecoration(
                //           hintText: "Alarm name",
                //           border: InputBorder.none,
                //           enabledBorder: InputBorder.none,
                //         ),
                //       ),
                //     ),
                //     ),
                //
                //
                //     Text("Notes:",style: Theme.of(context).textTheme.titleMedium,),
                //
                //     Container(
                //       height: height/10.8,
                //       width:width/1.2,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(color: Colors.black12),
                //
                //       ),child: Padding(
                //       padding:  EdgeInsets.only(left: width/36),
                //       child: TextField(
                //         controller: notescontroller,
                //         style: Theme.of(context).textTheme.bodyMedium,
                //         decoration: InputDecoration(
                //           hintText: "Notes",
                //           border: InputBorder.none,
                //           enabledBorder: InputBorder.none,
                //         ),
                //       ),
                //     ),
                //     ),
                //
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start horizontally
                    children: [
                      Text(
                        "Alarm Name:",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        //height: 70,
                         width: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0,right: 16),
                          child: TextField(
                            textAlign: TextAlign.start,
                           // keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            controller: alramnamecontroller,
                            // Set the desired number of lines for multi-line input
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: "Alarmname",
                              border: InputBorder.none, // Remove borders if desired (optional)
                              enabledBorder: InputBorder.none, // Remove borders if desired (optional)
                              // Show current character count and limit
                            ),
                            maxLength: 50,
                            onChanged: (value) => counterText= '${alramnamecontroller.text.length}/50',// Set the maximum allowed characters
                          ),
                        ),
                      ),
                      //Text("Alarmname cannot exceed 50 words",style: Theme.of(context).textTheme.bodySmall,),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Notes:",style: Theme.of(context).textTheme.titleMedium,),
                      Container(
                        //height: 70,
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0,right: 16),
                          child: TextField(
                            textAlign: TextAlign.start,
                            // keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            controller: notescontroller,
                            // Set the desired number of lines for multi-line input
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: "Notes",
                              border: InputBorder.none, // Remove borders if desired (optional)
                              enabledBorder: InputBorder.none, // Remove borders if desired (optional)
                              // Show current character count and limit
                            ),
                            maxLength: 150,
                            onChanged: (value) => counterText= '${notescontroller.text.length}/150',// Set the maximum allowed characters
                          ),
                        ),
                      ),
                      //Text("Notes cannot exceed 150 words",style: Theme.of(context).textTheme.bodySmall,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // void _showCustomBottomSheet(BuildContext context, int index)async {
  //   double height=MediaQuery.of(context).size.height;
  //   double width=MediaQuery.of(context).size.width;
  //   TextEditingController alramnamecontroller =
  //   TextEditingController(text: alarms[index].alarmName);
  //   TextEditingController notescontroller =
  //   TextEditingController(text: alarms[index].notes);
  //
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         child: Container(
  //
  //           height: height/2.29090,
  //           width: double.infinity,
  //
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //
  //                   OutlinedButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop(); // Call the saveAlarm function
  //                     },
  //                     child: Text("Cancel"),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 120.0),
  //                     child: FilledButton(
  //                       onPressed: () async {
  //                         setState(() {
  //                           alarms[index].alarmName = alramnamecontroller.text;
  //                           alarms[index].notes = notescontroller.text;
  //                           alarms[index].locationRadius = radius;
  //                         });
  //
  //                         saveData();
  //                         loadData();
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Text("Save"),
  //                     ),
  //                   ),
  //
  //
  //                 ],
  //               ),
  //
  //               // Integrate the MeterCalculatorWidget
  //               MeterCalculatorWidget(
  //                 callback: updateradiusvalue,
  //
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text("Alarm Name:", style: Theme.of(context).textTheme.titleMedium,),
  //
  //                   Container(
  //                     height:height/ 15.12,
  //                     width: width/1.2,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(10),
  //                       border: Border.all(color: Colors.black12),
  //
  //                     ),child: Padding(
  //                     padding:  EdgeInsets.only(left: width/36),
  //                     child: TextField(
  //                       controller: alramnamecontroller,
  //
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                       decoration: InputDecoration(
  //                         hintText: "Alarm name",
  //                         border: InputBorder.none,
  //                         enabledBorder: InputBorder.none,
  //                       ),
  //                     ),
  //                   ),
  //                   ),
  //
  //
  //                   Text("Notes:",style: Theme.of(context).textTheme.titleMedium,),
  //
  //                   Container(
  //                     height: height/10.8,
  //                     width:width/1.2,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(10),
  //                       border: Border.all(color: Colors.black12),
  //
  //                     ),child: Padding(
  //                     padding:  EdgeInsets.only(left: width/36),
  //                     child: TextField(
  //                       controller: notescontroller,
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                       decoration: InputDecoration(
  //                         hintText: "Notes",
  //                         border: InputBorder.none,
  //                         enabledBorder: InputBorder.none,
  //                       ),
  //                     ),
  //                   ),
  //                   ),
  //
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  LatLngBounds padLatLngBounds(LatLngBounds bounds, double padding) {
    double southWestLat = bounds.southwest.latitude - padding;
    double southWestLng = bounds.southwest.longitude - padding;
    double northEastLat = bounds.northeast.latitude + padding;
    double northEastLng = bounds.northeast.longitude + padding;

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }
  LatLngBounds _calculateMarkerBounds(LatLng? marker1, LatLng? marker2) {
    double southWestLat = double.infinity, southWestLng = double.infinity;
    double northEastLat = double.negativeInfinity, northEastLng = double.negativeInfinity;

    if (marker1 != null) {
      southWestLat = math.min(southWestLat, marker1.latitude);
      southWestLng = math.min(southWestLng, marker1.longitude);
      northEastLat = math.max(northEastLat, marker1.latitude);
      northEastLng = math.max(northEastLng, marker1.longitude);
    }

    if (marker2 != null) {
      southWestLat = math.min(southWestLat, marker2.latitude);
      southWestLng = math.min(southWestLng, marker2.longitude);
      northEastLat = math.max(northEastLat, marker2.latitude);
      northEastLng = math.max(northEastLng, marker2.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }
  void _startLocationUpdates() {
    // Listen for location cha
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
  final Uri toLaunch =
  Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
  Future<void> _goToCurrentLocation() async {
    if (currentLocation == null) {
      // Request location permission if needed
      await _requestLocationPermission();
      // await _startLocationUpdates();
      return; // Wait for location to be updated
    }

    if (mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          3000.0, // Adjust zoom level as needed
        ),
      );
    }
  }
  // void handleScreenChanged(int index) {
  //   Navigator.of(context).pop();
  //   switch (index) {
  //     case 0: // Alarm List
  //       Navigator.of(context).pop();
  //       // Replace with your AlarmListPage widget
  //       break;
  //     case 1: // Alarm List
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => MyHomePage()));
  //       // Replace with your AlarmListPage widget
  //       break;
  //     case 2:
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => Settings())); // Replace with your SavedAlarmsPage widget
  //       break;
  //     case 3:
  //       final RenderBox box = context.findRenderObject() as RenderBox;
  //       Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
  //       Share.share(
  //         'Check out my awesome app: ! Download it from the app store: ',
  //         subject: 'Share this amazing app!',
  //         sharePositionOrigin: dummyRect,
  //       );
  //       break;
  //     case 4:
  //       _launchInBrowser(toLaunch);
  //       break;
  //     case 5:
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => About()));
  //
  //       break;
  //
  //   }
  //   setState(() {
  //     screenIndex = index; // Update selected index
  //   });
  // }
  int screenIndex=0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(

      //key: _scaffoldKey,
      // drawer: NavigationDrawer(
      //   onDestinationSelected: (int index) {
      //     handleScreenChanged(index); // Assuming you have a handleScreenChanged function
      //   },
      //   selectedIndex: screenIndex,
      //   children: <Widget>[
      //     SizedBox(
      //       //height: 32,
      //       height:height/23.625,
      //     ),
      //     NavigationDrawerDestination(
      //
      //       icon: Icon(Icons.alarm_on_outlined), // Adjust size as needed
      //       label: Text('Saved Alarms'),
      //       // Set selected based on screenIndex
      //     ),
      //     NavigationDrawerDestination(
      //       icon: Icon(Icons.alarm),
      //       label: Text('Set a Alarm'),
      //       // Set selected based on screenIndex
      //     ),
      //     NavigationDrawerDestination(
      //       icon: Icon(Icons.settings_outlined),
      //       label: Text('Settings'),
      //       // Set selected based on screenIndex
      //     ),
      //     Divider(),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
      //       child: Text(
      //         'Communicate', // Assuming this is the header
      //         style: Theme.of(context).textTheme.titleSmall,
      //       ),
      //     ),
      //     NavigationDrawerDestination(
      //       icon: Icon(Icons.share_outlined),
      //       label: Text('Share'),
      //
      //       // Set selected based on screenIndex
      //     ),
      //     NavigationDrawerDestination(
      //       icon: Icon(Icons.rate_review_outlined),
      //       label: Text('Rate/Review'),
      //       // Set selected based on screenIndex
      //     ),
      //     Divider(),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
      //       child: Text(
      //         'App', // Assuming this is the header
      //         style: Theme.of(context).textTheme.titleSmall,
      //       ),
      //     ),
      //     NavigationDrawerDestination(
      //       icon: Icon(Icons.error_outline_outlined),
      //       label: Text('About'),
      //       // Set selected based on screenIndex
      //     ),
      //   ],
      // ),
body:  Stack(
  children: [
    GoogleMap(
    circles: _circles,
    zoomGesturesEnabled: true,
    mapType: MapType.normal,
    myLocationButtonEnabled: false,
    zoomControlsEnabled: false,
    initialCameraPosition: CameraPosition(
      zoom: 15,
      target: _defaultLocation,
    ),
    // onMapCreated: (GoogleMapController controller) {
    //   mapController = controller;
    // },
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        isMapInitialized = true;
        if (isMapInitialized) {
          // Determine the current zoom level
          double _defaultLocation = mapController!.getZoomLevel() as double;

          // Calculate the difference between current and target zoom levels
          double zoomLevelDifference = _defaultLocation - (_target!.latitude+_target!.longitude);

          // Adjust the zoom level of the map to match the target level
          mapController?.animateCamera(
            CameraUpdate.zoomBy(zoomLevelDifference),
          );
        }
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
    // Padding(
    //   padding:  EdgeInsets.only(top: height/7.56,left:25),
    //   child: Container(
    //     height:70,
    //     width:300,
    //     decoration: BoxDecoration(
    //       color: Colors.white70,
    //       border: Border.all(
    //         color: Colors.black,
    //       ),
    //       borderRadius: BorderRadius.circular(10),
    //     ), child: Center(child: Text("To reposition a marker, tap on it\nand then drag it to the new location.",
    //     textAlign:TextAlign.center,style: Theme.of(context).textTheme.titleMedium,)),),
    // ),
    Positioned(
      right: 24,bottom: 120,
      // padding:  EdgeInsets.only(top:height/1.68,left: 280),
      child:IconButton.filledTonal(
        onPressed: _goToCurrentLocation,
        icon: Icon(Icons.my_location),
        // child: Icon(Icons.my_location),
      ),
    ),
    Positioned(
      bottom: 72,right: 24,
      // padding: const EdgeInsets.only(left: 280.0,top: 500),
      child: IconButton.filledTonal(
        onPressed: () {
          mapController?.animateCamera(
            CameraUpdate.zoomIn(),
          );
        },
       icon: Icon(Icons.add),
      ),
    ),
    Positioned(
      bottom: 24,right: 24,

      // padding: const EdgeInsets.only(left: 280.0,top: 600),
      child: IconButton.filledTonal(
        onPressed: () {
          mapController?.animateCamera(
            CameraUpdate.zoomOut(),
          );
        },
        icon: Icon(Icons.remove),
      ),
    ),
    Positioned(
        top: 50,left: 15,
        child: IconButton(
          onPressed: () { Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back),)),
  ],
  ),
    );
  }
}

class MeterCalculatorWidget extends StatefulWidget {
  final Function(double) callback;
  final double? radius;

  const MeterCalculatorWidget({
    Key? key,
    required this.callback,
    this.radius,
  }) : super(key: key);

  @override
  _MeterCalculatorWidgetState createState() => _MeterCalculatorWidgetState();
}
class _MeterCalculatorWidgetState extends State<MeterCalculatorWidget> {
  double _radius = 200;
  bool _imperial = false;
  double meterRadius = 100; // Initial value for meter radius
  double milesRadius = 0.10;
  @override
  void initState() {
    _loadSelectedUnit();
    // _loadRadiusData();
    super.initState();
  }
  Future<void> _loadRadiusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      meterRadius = prefs.getDouble('meterRadius') ?? 0.0;
      milesRadius = prefs.getDouble('milesRadius') ?? 0.0;
    });
  }
  Future<void> _loadSelectedUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedUnit = prefs.getString('selectedUnit');
    double meterdefault = prefs.getDouble('meterRadius') ?? 2000;
    double milesdefault = prefs.getDouble('milesRadius') ?? 1.04;
    print("metersdefault:" + meterdefault.toString());
    print("milesdefault:" + milesdefault.toString());
    setState(() {
      _imperial = (selectedUnit == 'Imperial system (mi/ft)');
      _radius = widget.radius ?? (_imperial ? milesdefault : meterdefault);
    });
  }
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Radius',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Padding(
              padding:  EdgeInsets.only(left:width/2.5714),
              child:
              Text(
                  (_radius / (_imperial ? 1 : 1000)).toStringAsFixed(_imperial ? 2: 2) +
                      ' ${_imperial ? 'miles' : 'Kilometers'}'
              ),
              //Text(_radius.toStringAsFixed(_imperial ? 2:0)+' ${_imperial ? 'miles' : 'meters'}'),
            ),
          ],
        ),
        Container(
          width:width/1.16129,
          child: Slider (
            // Adjust max value according to your requirement
            value: _radius,
            divisions: 100,
            min: _imperial ? milesRadius: meterRadius,
            max: _imperial ? 2.00 : 3000,
            onChanged: (value) {
              widget.callback(_imperial? (value * 1609.34):value);
              print("kmvalue:"+value.toString());
              print("metercalculatedvalue:"+value.toString());
              setState(() {
                _radius = double.parse(value.toStringAsFixed(2));
                print("Radius:"+_radius.toString());
              });
              // widget.callback(_imperial ? (value * 1609.34):value);
              //  print("callback:"+widget.callback.toString());
            },
          ),
        ),
      ],
    );
  }
}

