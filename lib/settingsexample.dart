// import 'dart:async';
// import 'dart:convert';
// import 'dart:math' as math;
// import 'package:alarmplayer/alarmplayer.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:untitiled/Homescreens/settings.dart';
// import 'package:untitiled/Track.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:lottie/lottie.dart';
// import '../Apiutils.dart';
// import '../Map screen page.dart';
// import '../about page.dart';
// import '../main.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
//
// class MyAlarmsPage extends StatefulWidget {
//   const MyAlarmsPage({
//     super.key,
//   });
//
//   @override
//   _MyAlarmsPageState createState() => _MyAlarmsPageState();
// }
//
// class _MyAlarmsPageState extends State<MyAlarmsPage> {
//   LatLng? currentLocation;
//   double radius = 0;
//   bool isFavorite = false;
//   List<AlarmDetails> alarms = [];
//   bool _imperial = false;
//   StreamSubscription? bgServiceListener;
//
//   double calculateDistance(LatLng point1, LatLng point2) {
//     const double earthRadius = 6371000; // meters
//     double lat1 = degreesToRadians(point1.latitude);
//     double lat2 = degreesToRadians(point2.latitude);
//     double lon1 = degreesToRadians(point1.longitude);
//     double lon2 = degreesToRadians(point2.longitude);
//     double dLat = lat2 - lat1;
//     double dLon = lon2 - lon1;
//
//     double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(lat1) *
//             math.cos(lat2) *
//             math.sin(dLon / 2) *
//             math.sin(dLon / 2);
//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//     double distance = earthRadius * c;
//
//     return _imperial ? (distance / 1609) : (distance / 1000);
//   }
//
//   @override
//   void dispose() {
//     bgServiceListener?.cancel();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedUnit();
//     loadData();
//
//     bgServiceListener =
//         FlutterBackgroundService().on('stopped').listen((event) {
//           if (mounted) {
//             print('mounted');
//             loadData();
//           } else {
//             print('not mounted');
//           }
//         });
//   }
//
//   Future<void> _loadSelectedUnit() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? selectedUnit = prefs.getString('selectedUnit');
//     double meterdefault = prefs.getDouble('meterRadius') ?? 2000;
//     double milesdefault = prefs.getDouble('milesRadius') ?? 1.04;
//     print("metersdefault:" + meterdefault.toString());
//     print("milesdefault:" + milesdefault.toString());
//     print("selectedUnit:" + selectedUnit!);
//     setState(() {
//       _imperial = (selectedUnit == 'Imperial system (mi/ft)');
//     });
//   }
//
//   Future<void> sendEmail(BuildContext context) async {
//     final email = Email(
//       body: 'GPSAlarm',
//       subject: 'feedback',
//       recipients: ['brindhakarthi02@gmail.com'],
//     );
//     try {
//       await FlutterEmailSender.send(email);
//       // Your email sending code using mailer or flutter_email_sender
//     } on PlatformException catch (e) {
//       if (e.code == 'not_available') {
//         print('No email client found!');
//         // Show a user-friendly message explaining the issue
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 'No email client found on this device. Please configure a default email app.'),
//           ),
//         );
//       } else {
//         // Handle other potential errors
//         print('Error sending email: ${e.message}');
//       }
//     }
//   }
//
//   void updateFavoriteStatus(int index, bool isFavorite) {
//     setState(() {
//       alarms[index].isFavourite = isFavorite;
//       saveData(); // Save the updated list of alarms
//     });
//   }
//
//   Future<void> loadData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.reload();
//     List<String>? alarmsJson = prefs.getStringList('alarms');
//     if (alarmsJson != null) {
//       setState(() {
//         alarms = alarmsJson
//             .map((json) => AlarmDetails.fromJson(jsonDecode(json)))
//             .toList();
//       });
//     }
//     double? storedLatitude = prefs.getDouble('current_latitude');
//     double? storedLongitude = prefs.getDouble('current_longitude');
//     setState(() {
//       if (storedLatitude != null && storedLongitude != null) {
//         currentLocation = LatLng(storedLatitude, storedLongitude);
//         print('original location: ($storedLatitude, $storedLongitude)');
//         // Marker? tap = _markers.length > 1 ? _markers.last : null;
//       }
//     });
//   }
//
//   Future<void> saveData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     List<Map<String, dynamic>> alarmsJson =
//     alarms.map((alarm) => alarm.toJson()).toList();
//
//     prefs.setStringList(
//         'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
//
//     //prefs.reload();
//   }
//
//   int screenIndex = 0;
//
//   Future<void> _launchInBrowser(Uri url) async {
//     if (!await launchUrl(
//       url,
//       mode: LaunchMode.externalApplication,
//     )) {
//       throw Exception('Could not launch $url');
//     }
//   }
//
//   void handleScreenChanged(int index) {
//     switch (index) {
//       case 0:
//         Navigator.of(context).pop();
//         break;
//       case 1:
//         Navigator.of(context).pop();
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => MyHomePage()));
//         break;
//       case 2:
//         Navigator.of(context).pop();
//         // Navigator.pushNamed(context, '/thirdpage');
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => Settings())); //Navigate to screen3
//         break;
//       case 3:
//         Navigator.of(context).pop();
//         final RenderBox box = context.findRenderObject() as RenderBox;
//         Rect dummyRect = Rect.fromCenter(
//             center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
//         Share.share(
//           'Check out my awesome app! Download it from the app store:',
//           subject: 'Share this amazing app!',
//           sharePositionOrigin: dummyRect,
//         );
//         break;
//       case 4:
//         Navigator.of(context).pop();
//
//         _launchInBrowser(toLaunch);
//         break;
//       case 5:
//         Navigator.of(context).pop();
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => About()));
//         break;
//     }
//   }
//
//   final Uri toLaunch =
//   Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return WillPopScope(
//       onWillPop: () async {
//         final shouldExit = await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Exit App'),
//             content: Text('Are you sure you want to exit?'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 // Close the dialog, don't exit
//                 child: Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 // Close the dialog, exit the app
//                 child: Text('Exit'),
//               ),
//             ],
//           ),
//         );
//         return shouldExit ?? false; // Default to not exiting the app
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           // backgroundColor: Color(0xffFFEF9A9A),
//           title: Text("GPS Alarm"),
//         ),
//         drawer: NavigationDrawer(
//           onDestinationSelected: (int index) {
//             handleScreenChanged(
//                 index); // Assuming you have a handleScreenChanged function
//           },
//           selectedIndex: screenIndex,
//           children: <Widget>[
//             SizedBox(
//               height: height / 23.625,
//             ),
//             NavigationDrawerDestination(
//               icon: Icon(Icons.alarm_on_outlined), // Adjust size as needed
//               label: Text('Saved Alarms'),
//               // Set selected based on screenIndex
//             ),
//             NavigationDrawerDestination(
//               icon: Icon(Icons.alarm),
//               label: Text('Set a Alarm'),
//               // Set selected based on screenIndex
//             ),
//             NavigationDrawerDestination(
//               icon: Icon(Icons.settings_outlined),
//               label: Text('Settings'),
//               // Set selected based on screenIndex
//             ),
//             Divider(),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
//               child: Text(
//                 'Communicate', // Assuming this is the header
//                 style: Theme.of(context).textTheme.titleSmall,
//               ),
//             ),
//             NavigationDrawerDestination(
//               icon: Icon(Icons.share_outlined),
//               label: Text('Share'),
//
//               // Set selected based on screenIndex
//             ),
//             NavigationDrawerDestination(
//               icon: Icon(Icons.rate_review_outlined),
//               label: Text('Rate/Review'),
//               // Set selected based on screenIndex
//             ),
//             Divider(),
//             Padding(
//               padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
//               child: Text(
//                 'App', // Assuming this is the header
//                 style: Theme.of(context).textTheme.titleSmall,
//               ),
//             ),
//             NavigationDrawerDestination(
//               icon: Icon(Icons.error_outline_outlined),
//               label: Text('About'),
//               // Set selected based on screenIndex
//             ),
//           ],
//         ),
//         body: alarms.isEmpty
//             ? Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Alarmplayer alarmplayer = Alarmplayer();
//                     alarmplayer.StopAlarm();
//                   },
//                   child: Lottie.asset(
//                     'assets/newlocationalarm.json',
//                     // Your empty list Lottie animation
//                     width: 300, // Adjust as needed
//                     height: 300, // Adjust as needed
//                   ),
//                 ),
//                 Text("No Alarms",
//                     style: Theme.of(context).textTheme.titleLarge),
//                 Text("Create a new alarm",
//                     style: Theme.of(context).textTheme.bodyMedium),
//               ],
//             ),
//           ),
//         )
//             : Padding(
//           padding: EdgeInsets.only(
//               left: width / 45, right: width / 45, bottom: 48),
//           child: ListView.separated(
//             itemCount: alarms.length,
//             separatorBuilder: (context, index) {
//               return SizedBox(
//                 height: height / 94.5,
//               );
//             },
//             itemBuilder: (context, index) {
//               return Card.filled(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "${alarms[index].alarmName}",
//                               style:
//                               Theme.of(context).textTheme.titleMedium,
//                               overflow:
//                               TextOverflow.ellipsis, // Add this line
//                             ),
//                           ),
//                           Switch(
//                             // This bool value toggles the switch.
//                             value: alarms[index].isEnabled,
//                             onChanged: (value) async {
//                               setState(() {
//                                 alarms[index].isEnabled = value;
//                               });
//                               await saveData();
//                               final service = FlutterBackgroundService();
//                               if (value) {
//                                 if (!(await service.isRunning())) {
//                                   print('starting service from toggle');
//                                   await service.startService();
//                                 }
//                               } else {
//                                 print('checking for stop');
//                                 print(alarms.toString());
//                                 if (alarms
//                                     .where((element) =>
//                                 element.isEnabled)
//                                     .isEmpty &&
//                                     await service.isRunning()) {
//                                   print('preparing to stop');
//                                   service.invoke('stopService');
//                                 }
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                       Text(
//                         "${alarms[index].notes}",
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.location_on,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .primary,
//                                 ),
//                                 Text(
//                                   currentLocation != null
//                                       ? (calculateDistance(
//                                       LatLng(
//                                           currentLocation!
//                                               .latitude,
//                                           currentLocation!
//                                               .longitude),
//                                       LatLng(
//                                           alarms[index].lat,
//                                           alarms[index]
//                                               .lng))) // Divide by 1000 to convert meters to kilometers
//                                       .toStringAsFixed(
//                                       1) // Adjust the precision as needed
//                                       : "3 km",
//                                   // Default value if currentLocation is null
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium,
//                                 ),
//                                 Text(
//                                   _imperial ? "miles" : "Km",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // IconButton(
//                           //    onPressed: () {  final alarmToDelete = alarms[
//                           //    index]; // Store the alarm for later
//                           //
//                           //    // Show confirmation Snackbar
//                           //    ScaffoldMessenger.of(context).showSnackBar(
//                           //      SnackBar(
//                           //        content: Text(
//                           //            'Are you sure you want to delete "${alarmToDelete.alarmName}"?'),
//                           //        action: SnackBarAction(
//                           //          label: 'Delete',
//                           //          onPressed: () {
//                           //            setState(() {
//                           //              alarms.removeAt(index);
//                           //            });
//                           //            saveData();
//                           //          },
//                           //        ),
//                           //      ),
//                           //    );
//                           //    }, icon: Icon(Icons.delete),color: Theme.of(context).colorScheme.error,
//                           //     ),
//                           IconButton(
//                             onPressed: () {
//                               final alarmToDelete = alarms[
//                               index]; // Store the alarm for later
//
//                               // Show confirmation dialog
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     title: Text('Delete Alarm'),
//                                     content: Text(
//                                         'Are you sure you want to delete "${alarmToDelete.alarmName}"?'),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.of(context)
//                                               .pop(); // Close the dialog
//                                         },
//                                         child: Text('Cancel'),
//                                       ),
//                                       TextButton(
//                                         onPressed: () async {
//                                           setState(() {
//                                             alarms.removeAt(index);
//                                           });
//                                           saveData();
//                                           final service =
//                                           FlutterBackgroundService();
//                                           if (alarms
//                                               .where((element) =>
//                                           element.isEnabled)
//                                               .isEmpty &&
//                                               await service.isRunning()) {
//                                             print('preparing to stop');
//                                             service.invoke('stopService');
//                                           }
//                                           Navigator.of(context)
//                                               .pop(); // Close the dialog
//                                         },
//                                         child: Text('Delete'),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                             icon: Icon(Icons.delete),
//                             color: Theme.of(context).colorScheme.error,
//                           ),
//
//                           IconButton(
//                             onPressed: () {
//                               Navigator.of(context)
//                                   .push(MaterialPageRoute(
//                                   builder: (context) => Track(
//                                     alarm: alarms[index],
//                                   )));
//                             },
//                             icon: Icon(Icons.edit),
//                             color:
//                             Theme.of(context).colorScheme.secondary,
//                           ),
//
//                           // Switch(
//                           //   value: alarms[index].isEnabled,
//                           //   onChanged: (value) {
//                           //     setState(() {
//                           //       alarms[index].isEnabled = value;
//                           //       saveData();
//                           //     });
//                           //   },
//                           // ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(CupertinoIcons.plus),
//           onPressed: () {
//             Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (context) => MyHomePage()));
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class MeterCalculatorWidget extends StatefulWidget {
//   final Function(double) callback;
//
//   const MeterCalculatorWidget({
//     Key? key,
//     required this.callback,
//   }) : super(key: key);
//
//   @override
//   _MeterCalculatorWidgetState createState() => _MeterCalculatorWidgetState();
// }
//
// class _MeterCalculatorWidgetState extends State<MeterCalculatorWidget> {
//   double _radius = 200;
//   bool _imperial = false;
//   double meterRadius = 100; // Initial value for meter radius
//   double milesRadius = 0.10;
//
//   @override
//   void initState() {
//     _loadSelectedUnit();
//
//     // _loadRadiusData();
//     super.initState();
//   }
//
//   Future<void> _loadRadiusData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       meterRadius = prefs.getDouble('meterRadius') ?? 0.0;
//       milesRadius = prefs.getDouble('milesRadius') ?? 0.0;
//     });
//   }
//
//   Future<void> _loadSelectedUnit() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? selectedUnit = prefs.getString('selectedUnit');
//     double meterdefault = prefs.getDouble('meterRadius') ?? 2000;
//     double milesdefault = prefs.getDouble('milesRadius') ?? 1.04;
//     print("metersdefault:" + meterdefault.toString());
//     print("milesdefault:" + milesdefault.toString());
//     setState(() {
//       _imperial = (selectedUnit == 'Imperial system (mi/ft)');
//       _radius = _imperial ? milesdefault : meterdefault;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'Radius',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: width / 2.5714),
//               child: Text((_radius / (_imperial ? 1 : 1000))
//                   .toStringAsFixed(_imperial ? 2 : 2) +
//                   ' ${_imperial ? 'miles' : 'Kilometers'}'),
//               //Text(_radius.toStringAsFixed(_imperial ? 2:0)+' ${_imperial ? 'miles' : 'meters'}'),
//             ),
//           ],
//         ),
//         Container(
//           width: width / 1.16129,
//           child: Slider(
//             // Adjust max value according to your requirement
//             value: _radius,
//             divisions: 100,
//             min: _imperial ? milesRadius : meterRadius,
//             max: _imperial ? 2.00 : 3000,
//             onChanged: (value) {
//               widget.callback(_imperial ? (value * 1609.34) : value);
//               print("kmvalue:" + value.toString());
//               print("metercalculatedvalue:" + value.toString());
//               setState(() {
//                 _radius = double.parse(value.toStringAsFixed(2));
//                 print("Radius:" + _radius.toString());
//               });
//               // widget.callback(_imperial ? (value * 1609.34):value);
//               //  print("callback:"+widget.callback.toString());
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }











/*import 'package:audioplayers/audioplayers.dart'; // Add this line
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitiled/Homescreens/save_alarm_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Map screen page.dart';
import '../about page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMetricSystem = true;
  double radius = 0;
  double meterRadius = 0.1; // Initial value for meter radius
  double milesRadius = 0.1;
  GoogleMapController? mapController;
  LocationData? _currentLocation;
  bool _isCameraMoving = false;
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;


  updateradiusvalue(value) {
    setState(() {
      radius = value;
    });
  }

  List<String> ringtones = [];
  bool listFileExists = true;
  String? _selectedUnit; // Variable to store the selected unit
  // Dropdown options
  List<String> _units = ['Metric system (m/km)', 'Imperial system (mi/ft)'];
  String? selectedRingtone;

  String? kSharedPrefVibrate = 'vibrateEnabled';
  String? kSharedPrefBoth = 'useBoth';
  Map<String, String> _optionMap = {
    'Alarms': 'alarms',
    'Vibrate': 'vibrate',
    'Alarms in Silent Mode': 'alarms in silent mode'
  };
  Set<String> _selectedOptions = Set<String>();

  DropdownButton<String> _buildRingtoneDropdown() {
    return DropdownButton<String>(
      value: selectedRingtone,
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      items: ringtones
          .map((ringtone) => DropdownMenuItem<String>(
        value: ringtone,
        child: Text(ringtone.split('/').last),
      ))
          .toList(),
      onChanged: (String? value) async {
        if (value != null) {
          setState(() {
            selectedRingtone = value;
            // Save selected ringtone
          });
          _saveSettings(selectedRingtone!);
          // _saveSelectedRingtone(value);
          _playRingtone(selectedRingtone!);
          // await flutterLocalNotificationsPlugin
          //     .resolvePlatformSpecificImplementation<
          //     AndroidFlutterLocalNotificationsPlugin>()
          //     ?.deleteNotificationChannel("my_foreground");
        }
      },
      hint: Text("Select Ringtone",
          style: Theme.of(context).textTheme.bodyMedium),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
    );
  }

  String kSharedPrefOption = 'selected_option';

  Future<void> _loadRadiusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load meter radius (convert from kilometers if stored)
      meterRadius = prefs.getDouble('meterRadius')?.toDouble() ?? 100;
      meterRadius /= 1000; // Convert kilometers to meters if previously stored

      // Load miles radius
      milesRadius = prefs.getDouble('milesRadius') ?? 0.10;

      // Load unit system preference (default to metric)
      _isMetricSystem = prefs.getBool('unitSystem') ?? true;
    });
  }

  Future<void> _loadRingtones() async {
    try {
      if (listFileExists) {
        // Check if list.txt exists (optional)
        ringtones = await rootBundle.loadString('assets/list.txt').then(
              (data) => data.split(','),
        );
      } else {
        // Handle the case where list.txt is missing (optional)
        // You could list filenames directly or provide a default message
      }
    } on FlutterError catch (e) {
      // Handle error if list.txt is missing or inaccessible
      print("Error loading ringtones: $e");
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
    });
  }

  Future<void> _saveRadiusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('meterRadius', meterRadius * 1000); // Store in meters
    await prefs.setDouble('milesRadius', milesRadius);

    // Optionally save unit system preference
    await prefs.setBool(
        'unitSystem', _isMetricSystem); // Save current preference
  }

  Future<void> _saveSelectedRingtone(String ringtone) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('selectedRingtone', ringtone);
      print('Selected ringtone saved: $ringtone');
    } catch (e) {
      print('Error saving selected ringtone: $e');
    }
  }

  void handleScreenChanged(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyAlarmsPage()),
              (Route<dynamic> route) =>
          false, // This condition will remove all routes
        );
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => MyAlarmsPage()));
        // Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case 1:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()));
        break;
      case 2:
        Navigator.of(context).pop();
        // MaterialPageRoute(builder: (context) => Settings()));
        break;
      case 3:
        final RenderBox box = context.findRenderObject() as RenderBox;
        Rect dummyRect = Rect.fromCenter(
            center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
        Share.share(
          'Check out my awesome app! Download it from the app store:',
          subject: 'Share this amazing app!',
          sharePositionOrigin: dummyRect,
        );
        break;
      case 4:
        _launchInBrowser(toLaunch);
        break;
      case 5:
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => About()));
        break;
    }
  }

  Future<void> _playRingtone(String ringtone) async {
    // Ensure assets/alarm_ringtones/ is the correct path
    final ringtonePath = '$ringtone';
    try {
      await _audioPlayer.play(AssetSource(ringtonePath));
      // await _audioPlayer.setSource(AssetSource(ringtonePath));
      // await _audioPlayer.resume(); // Start playing the ringtone
    } catch (e) {
      if (e is PlatformException) {
        print(
            'Audio playback error: ${e.message}'); // Log the entire error message
      } else {
        print('Unexpected error: $e');
      }
    }
  }

  Future<void> _saveAllSettings() async {
    await _saveRadiusData();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSetSettings', true);
  }

  void _handleSettingsSet() async {
    _audioPlayer.stop();
    await _saveAllSettings();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyAlarmsPage()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop(); // Stop the audio player when the widget is disposed
  }

  String selectedOptionKey = 'selectedOption';
  String selectedRingtoneKey = 'selectedRingtone';
  String isSwitchedKey = 'isSwitched';

  // Function to store switch value
  void initState() {
    super.initState();
    _loadSelectedUnit();
    _loadRingtones();
    _loadRadiusData();
    _loadSettings();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    _updateMarkerAndCamera();
  }

  Future<void> _getCurrentLocation() async {
    _currentLocation = await location.getLocation();
    _updateMarkerAndCamera();
    _showBottomSheetWithMap();
  }

  void _updateMarkerAndCamera() {
    if (_currentLocation != null) {
      final position = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
      mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 15)));
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: position,
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );
      });
    }
  }



  Future<void> _saveSettings(String ringtone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRingtone', ringtone);
    await prefs.setStringList('selectedOptions', _selectedOptions.toList());
    print(_selectedOptions);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final selectedOptions =
          prefs.getStringList('selectedOptions') ?? <String>[];
      _selectedOptions = selectedOptions.toSet();
    });
  }

  void _saveSelectedUnit(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedUnit', newValue);
    setState(() {
      _selectedUnit = newValue;
    });
  }

  Future _loadSelectedUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedUnit = prefs.getString('selectedUnit');
      _imperial = (_selectedUnit == 'Imperial system (mi/ft)');
      radius = _imperial ? 1.24 : 2000;
    });
  }


  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  int screenIndex = 2;
  final Uri toLaunch =
  Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSwitched = false;
  SharedPreferences? prefs;


  @override
  bool _imperial = false;
  void _setMapType(MapType mapType) {
    setState(() {
      _currentMapType = mapType;
    });
  }

  void _showBottomSheetWithMap() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 800,
          child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    zoom: 15,
                    target: _currentLocation != null
                        ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
                        : LatLng(0, 0),
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                      zoom: 15,
                    )));
                  },
                ),
                Positioned(
                  top: 16,left: 16,
                  child: IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.cancel,size: 36,),
                  ),
                ),
              ]
          ),
        );
      },
    );
  }



  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(
        onDestinationSelected: (int index) {
          handleScreenChanged(
              index); // Assuming you have a handleScreenChanged function
        },
        selectedIndex: screenIndex,
        children: <Widget>[
          SizedBox(
            height: height / 23.625,
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.alarm_on_outlined), // Adjust size as needed
            label: Text('Saved Alarms'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.alarm),
            label: Text('Set a Alarm'),

          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            label: Text('Settings'),

          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Communicate', // Assuming this is the header
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.share_outlined),
            label: Text('Share'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.rate_review_outlined),
            label: Text('Rate/Review'),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'App', // Assuming this is the header
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.error_outline_outlined),
            label: Text('About'),
            // Set selected based on screenIndex
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu,
              size: 25,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          "Settings",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height / 37.8,
              ),
              Text(
                'Units',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButton<String>(
                value: _selectedUnit,
                onChanged: (newValue) {
                  setState(() {
                    _selectedUnit = newValue;
                  });
                  _loadSelectedUnit();
                  _saveSelectedUnit(newValue!);
                  _isMetricSystem = newValue == 'Metric system (m/km)';
                },
                hint: Text('Metric system (m/km)'),
                style: Theme.of(context).textTheme.bodyMedium,
                underline: Container(
                  height: height / 378,
                  color: Colors.transparent,
                ),
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                items: _units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
              ),
              Divider(),
              SizedBox(
                height: height / 37.8,
              ),
              Text(
                'Options',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Column(
                children: [
                  ..._optionMap.keys.map((option) {
                    if (option == 'Alarms in Silent Mode') {
                      // Show "Alarms in Silent Mode" only if "Alarms" is selected
                      return Visibility(
                        visible:
                        _selectedOptions.contains(_optionMap['Alarms']),
                        child: CheckboxListTile(
                          title: Text(option),
                          value: _selectedOptions.contains(_optionMap[option]),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                _selectedOptions.add(_optionMap[option]!);
                              } else {
                                _selectedOptions.remove(_optionMap[option]);
                              }
                              print(_selectedOptions);
                              _saveSettings(selectedRingtone!);
                            });
                          },
                        ),
                      );
                    } else {
                      return CheckboxListTile(
                        title: Text(option),
                        value: _selectedOptions.contains(_optionMap[option]),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              _selectedOptions.add(_optionMap[option]!);
                            } else {
                              _selectedOptions.remove(_optionMap[option]);
                              if (option == 'Alarms') {
                                _selectedOptions.remove(
                                    _optionMap['Alarms in Silent Mode']);
                              }
                            }
                            print(_selectedOptions);
                            _saveSettings(selectedRingtone!);
                          });
                        },
                      );
                    }
                  }).toList(),
                  Visibility(
                    visible: _selectedOptions.contains(_optionMap['Alarms']),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 37.8,
                          ),
                          Text(
                            'Alarm',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          _buildRingtoneDropdown(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: height / 37.8,
              ),
              Text(
                'Radius',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: height / 75.6,
              ),
              Container(
                child: Column(
                  children: [
                    // Visibility widget for the Meter slider
                    Visibility(
                      visible: _isMetricSystem,
                      // Show only if metric system is selected
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Radius in Meter',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(
                                width: width / 2.1176470,
                              ),
                              Text(
                                '${(meterRadius).toStringAsFixed(_imperial ? 2 : 2)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text("km"),
                            ],
                          ),
                          Slider(
                            divisions: 10,
                            min: 0.1,
                            max: 3,
                            // Adjust max value according to your requirement
                            value: meterRadius,
                            onChanged: (double value) {
                              setState(() {
                                meterRadius =
                                    double.parse(value.toStringAsFixed(2));
                              });
                              _saveRadiusData();
                            },
                          ),
                        ],
                      ),
                    ),
                    // Visibility widget for the Miles slider
                    Visibility(
                      visible: !_isMetricSystem,
                      // Show only if imperial system is selected
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Radius in Miles',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                width: width / 2.4,
                              ),
                              Text(
                                '${milesRadius.toStringAsFixed(_imperial ? 2 : 2)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text("miles"),
                            ],
                          ),
                          Slider(
                            divisions: 10,
                            min: 0.10,
                            max: 2,
                            // Adjust max value according to your requirement
                            value: milesRadius,
                            onChanged: (double value) {
                              setState(() {
                                milesRadius =
                                    double.parse(value.toStringAsFixed(2));
                              });
                              _saveRadiusData();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "The Minimum value must exceed 0.10",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(
                height: height / 75.6,
              ),
              Divider(),
              SizedBox(
                height: height / 75.6,
              ),
              Text(
                'To View a Current Location',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: height / 75.6,
              ),
              FilledButton(
                onPressed: () {
                  _getCurrentLocation;
                  _showBottomSheetWithMap();
                },
                child: Text("Current Location"),
              ),
              SizedBox(
                height: height / 75.6,
              ),
              Padding(
                padding: EdgeInsets.only(top: height / 15.12, left: width / 3),
                child: FilledButton(
                  onPressed: () {
                    //_savesettings(selectedRingtone!);
                    _handleSettingsSet();
                  },
                  child: Text("Set"),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Method to retrieve the package name of the sound settings app

// Future<void> _pickRingtone() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.audio,
//     allowCompression: true,
//   );
//
//   if (result != null) {
//     String? filePath = result.files.single.path;
//     if (filePath != null) {
//       // Use the selected ringtone file path
//       print('Selected ringtone: $filePath');
//       // You can save the file path or use it directly in your app
//     }
//   } else {
//     // User canceled the picker
//   }
// }
} */



/*import 'package:audioplayers/audioplayers.dart'; // Add this line
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitiled/Homescreens/save_alarm_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Map screen page.dart';
import '../about page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMetricSystem = true;
  double radius = 0;
  double meterRadius = 0.1; // Initial value for meter radius
  double milesRadius = 0.1;
  GoogleMapController? mapController;
  LocationData? _currentLocation;
  bool _isCameraMoving = false;
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;


  updateradiusvalue(value) {
    setState(() {
      radius = value;
    });
  }

  List<String> ringtones = [];
  bool listFileExists = true;
  String? _selectedUnit; // Variable to store the selected unit
  // Dropdown options
  List<String> _units = ['Metric system (m/km)', 'Imperial system (mi/ft)'];
  String? selectedRingtone;

  String? kSharedPrefVibrate = 'vibrateEnabled';
  String? kSharedPrefBoth = 'useBoth';
  Map<String, String> _optionMap = {
    'Alarms': 'alarms',
    'Vibrate': 'vibrate',
    'Alarms in Silent Mode': 'alarms in silent mode'
  };
  Set<String> _selectedOptions = Set<String>();

  DropdownButton<String> _buildRingtoneDropdown() {
    return DropdownButton<String>(
      value: selectedRingtone,
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      items: ringtones
          .map((ringtone) => DropdownMenuItem<String>(
        value: ringtone,
        child: Text(ringtone.split('/').last),
      ))
          .toList(),
      onChanged: (String? value) async {
        if (value != null) {
          setState(() {
            selectedRingtone = value;
            // Save selected ringtone
          });
          _saveSettings(selectedRingtone!);
          // _saveSelectedRingtone(value);
          _playRingtone(selectedRingtone!);
          // await flutterLocalNotificationsPlugin
          //     .resolvePlatformSpecificImplementation<
          //     AndroidFlutterLocalNotificationsPlugin>()
          //     ?.deleteNotificationChannel("my_foreground");
        }
      },
      hint: Text("Select Ringtone",
          style: Theme.of(context).textTheme.bodyMedium),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
    );
  }

  String kSharedPrefOption = 'selected_option';


  Future<void> _loadRadiusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load meter radius (convert from kilometers if stored)
      meterRadius = prefs.getDouble('meterRadius')?.toDouble() ?? 100;
      meterRadius /= 1000; // Convert kilometers to meters if previously stored

      // Load miles radius
      milesRadius = prefs.getDouble('milesRadius') ?? 0.10;

      // Load unit system preference (default to metric)
      _isMetricSystem = prefs.getBool('unitSystem') ?? true;
    });
  }



  Future<void> _loadRingtones() async {
    try {
      if (listFileExists) {
        // Check if list.txt exists (optional)
        ringtones = await rootBundle.loadString('assets/list.txt').then(
              (data) => data.split(','),
        );
      } else {
        // Handle the case where list.txt is missing (optional)
        // You could list filenames directly or provide a default message
      }
    } on FlutterError catch (e) {
      // Handle error if list.txt is missing or inaccessible
      print("Error loading ringtones: $e");
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
    });
  }

  Future<void> _saveRadiusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('meterRadius', meterRadius * 1000); // Store in meters
    await prefs.setDouble('milesRadius', milesRadius);

    // Optionally save unit system preference
    await prefs.setBool(
        'unitSystem', _isMetricSystem); // Save current preference
  }

  Future<void> _saveSelectedRingtone(String ringtone) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('selectedRingtone', ringtone);
      print('Selected ringtone saved: $ringtone');
    } catch (e) {
      print('Error saving selected ringtone: $e');
    }
  }

  void handleScreenChanged(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyAlarmsPage()),
              (Route<dynamic> route) =>
          false, // This condition will remove all routes
        );
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => MyAlarmsPage()));
        // Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case 1:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()));
        break;
      case 2:
        Navigator.of(context).pop();
        // MaterialPageRoute(builder: (context) => Settings()));
        break;
      case 3:
        final RenderBox box = context.findRenderObject() as RenderBox;
        Rect dummyRect = Rect.fromCenter(
            center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
        Share.share(
          'Check out my awesome app! Download it from the app store:',
          subject: 'Share this amazing app!',
          sharePositionOrigin: dummyRect,
        );
        break;
      case 4:
        _launchInBrowser(toLaunch);
        break;
      case 5:
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => About()));
        break;
    }
  }

  Future<void> _playRingtone(String ringtone) async {
    // Ensure assets/alarm_ringtones/ is the correct path
    final ringtonePath = '$ringtone';
    try {
      await _audioPlayer.play(AssetSource(ringtonePath));
      // await _audioPlayer.setSource(AssetSource(ringtonePath));
      // await _audioPlayer.resume(); // Start playing the ringtone
    } catch (e) {
      if (e is PlatformException) {
        print(
            'Audio playback error: ${e.message}'); // Log the entire error message
      } else {
        print('Unexpected error: $e');
      }
    }
  }

  Future<void> _saveAllSettings() async {
    await _saveRadiusData();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSetSettings', true);
  }

  void _handleSettingsSet() async {
    _audioPlayer.stop();
    await _saveAllSettings();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyAlarmsPage()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop(); // Stop the audio player when the widget is disposed
  }

  String selectedOptionKey = 'selectedOption';
  String selectedRingtoneKey = 'selectedRingtone';
  String isSwitchedKey = 'isSwitched';

  // Function to store switch value
  void initState() {
    super.initState();
    _selectedOptions.add(_optionMap['Alarms']!);
    _loadSelectedUnit();
    _loadRingtones();
    _loadRadiusData();
    _loadSettings();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    _updateMarkerAndCamera();
  }

  Future<void> _getCurrentLocation() async {
    _currentLocation = await location.getLocation();
    _updateMarkerAndCamera();
    _showBottomSheetWithMap();
  }

  void _updateMarkerAndCamera() {
    if (_currentLocation != null) {
      final position = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
      mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 15)));
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: position,
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );
      });
    }
  }
  Future<void> _saveSettings(String ringtone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRingtone', ringtone);
    await prefs.setStringList('selectedOptions', _selectedOptions.toList());
    print(_selectedOptions);
  }
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final selectedOptions =
          prefs.getStringList('selectedOptions') ?? <String>[];
      _selectedOptions = selectedOptions.toSet();
    });
  }

  void _saveSelectedUnit(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedUnit', newValue);
    setState(() {
      _selectedUnit = newValue;
    });

  }

  Future _loadSelectedUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedUnit = prefs.getString('selectedUnit');
      _imperial = (_selectedUnit == 'Imperial system (mi/ft)');
      radius = _imperial ? 1.24 : 2000;
    });
  }


  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  int screenIndex = 2;
  final Uri toLaunch =
  Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSwitched = false;
  SharedPreferences? prefs;


  @override
  bool _imperial = false;
  void _setMapType(MapType mapType) {
    setState(() {
      _currentMapType = mapType;
    });
  }

  void _showBottomSheetWithMap() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 800,
          child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    zoom: 15,
                    target: _currentLocation != null
                        ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
                        : LatLng(0, 0),
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                      zoom: 15,
                    )));
                  },
                ),
                Positioned(
                  top: 16,left: 16,
                  child: IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.cancel,size: 36,),
                  ),
                ),
              ]
          ),
        );
      },
    );
  }



  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(
        onDestinationSelected: (int index) {
          handleScreenChanged(
              index); // Assuming you have a handleScreenChanged function
        },
        selectedIndex: screenIndex,
        children: <Widget>[
          SizedBox(
            height: height / 23.625,
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.alarm_on_outlined), // Adjust size as needed
            label: Text('Saved Alarms'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.alarm),
            label: Text('Set a Alarm'),

          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            label: Text('Settings'),

          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Communicate', // Assuming this is the header
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.share_outlined),
            label: Text('Share'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.rate_review_outlined),
            label: Text('Rate/Review'),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'App', // Assuming this is the header
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.error_outline_outlined),
            label: Text('About'),
            // Set selected based on screenIndex
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu,
              size: 25,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          "Settings",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height / 37.8,
              ),
              Text(
                'Units',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButton<String>(
                value: _selectedUnit,
                onChanged: (newValue) {
                  setState(() {
                    _selectedUnit = newValue;
                  });
                  _loadSelectedUnit();
                  _saveSelectedUnit(newValue!);
                  _isMetricSystem = newValue == 'Metric system (m/km)';
                },
                hint: Text('Metric system (m/km)'),
                style: Theme.of(context).textTheme.bodyMedium,
                underline: Container(
                  height: height / 378,
                  color: Colors.transparent,
                ),
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                items: _units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
              ),
              Divider(),
              SizedBox(
                height: height / 37.8,
              ),
              Text(
                'Options',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Column(
                children: [
                  ..._optionMap.keys.map((option) {
                    if (option == 'Alarms in Silent Mode') {
                      // Show "Alarms in Silent Mode" only if "Alarms" is selected
                      return Visibility(
                        visible:
                        _selectedOptions.contains(_optionMap['Alarms']),
                        child: CheckboxListTile(
                          title: Text(option),
                          value: _selectedOptions.contains(_optionMap[option]),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                _selectedOptions.add(_optionMap[option]!);
                              } else {
                                _selectedOptions.remove(_optionMap[option]);
                              }
                              print(_selectedOptions);
                              _saveSettings(selectedRingtone!);
                            });
                          },
                        ),
                      );
                    } else {
                      return CheckboxListTile(
                        title: Text(option),
                        value: _selectedOptions.contains(_optionMap[option]),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              _selectedOptions.add(_optionMap[option]!);
                            } else {
                              _selectedOptions.remove(_optionMap[option]);
                              if (option == 'Alarms') {
                                _selectedOptions.remove(
                                    _optionMap['Alarms in Silent Mode']);
                              }
                            }
                            print(_selectedOptions);
                            _saveSettings(selectedRingtone!);
                          });
                        },
                      );
                    }
                  }).toList(),
                  Visibility(
                    visible: _selectedOptions.contains(_optionMap['Alarms']),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 37.8,
                          ),
                          Text(
                            'Alarm',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          _buildRingtoneDropdown(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: height / 37.8,
              ),
              Text(
                'Radius',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: height / 75.6,
              ),
              Container(
                child: Column(
                  children: [
                    // Visibility widget for the Meter slider
                    Visibility(
                      visible: _isMetricSystem,
                      // Show only if metric system is selected
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Radius in Meter',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(
                                width: width / 2.1176470,
                              ),
                              Text(
                                '${(meterRadius).toStringAsFixed(_imperial ? 2 : 2)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text("km"),
                            ],
                          ),
                          Slider(
                            divisions: 10,
                            min: 0.1,
                            max: 3,
                            // Adjust max value according to your requirement
                            value: meterRadius,
                            onChanged: (double value) {
                              setState(() {
                                meterRadius =
                                    double.parse(value.toStringAsFixed(2));
                              });
                              _saveRadiusData();
                            },
                          ),
                        ],
                      ),
                    ),
                    // Visibility widget for the Miles slider
                    Visibility(
                      visible: !_isMetricSystem,
                      // Show only if imperial system is selected
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Radius in Miles',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(
                                width: width / 2.4,
                              ),
                              Text(
                                '${milesRadius.toStringAsFixed(_imperial ? 2 : 2)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text("miles"),
                            ],
                          ),
                          Slider(
                            divisions: 10,
                            min: 0.10,
                            max: 2,
                            // Adjust max value according to your requirement
                            value: milesRadius,
                            onChanged: (double value) {
                              setState(() {
                                milesRadius =
                                    double.parse(value.toStringAsFixed(2));
                              });
                              _saveRadiusData();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "The Minimum value must exceed 0.10",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(
                height: height / 75.6,
              ),
              Divider(),
              SizedBox(
                height: height / 75.6,
              ),
              Text(
                'To View a Current Location',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: height / 75.6,
              ),
              FilledButton(
                onPressed: () {
                  _getCurrentLocation;
                  _showBottomSheetWithMap();
                },
                child: Text("Current Location"),
              ),
              SizedBox(
                height: height / 75.6,
              ),
              Padding(
                padding: EdgeInsets.only(top: height / 15.12, left: width / 3),
                child: FilledButton(
                  onPressed: () {
                    //_savesettings(selectedRingtone!);
                    _handleSettingsSet();
                  },
                  child: Text("Set"),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Method to retrieve the package name of the sound settings app

// Future<void> _pickRingtone() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.audio,
//     allowCompression: true,
//   );
//
//   if (result != null) {
//     String? filePath = result.files.single.path;
//     if (filePath != null) {
//       // Use the selected ringtone file path
//       print('Selected ringtone: $filePath');
//       // You can save the file path or use it directly in your app
//     }
//   } else {
//     // User canceled the picker
//   }
// }
}
*/
