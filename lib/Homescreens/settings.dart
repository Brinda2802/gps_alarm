// import 'package:audioplayers/audioplayers.dart'; // Add this line
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:untitiled/Homescreens/save_alarm_page.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../Map screen page.dart';
// import '../about page.dart';
//
//
//
// class Settings extends StatefulWidget {
//   const Settings({super.key});
//
//   @override
//   State<Settings> createState() => _SettingsState();
// }
//
// class _SettingsState extends State<Settings> {
//   late  final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isMetricSystem = true;
//   double radius=0;
//   double meterRadius = 100; // Initial value for meter radius
//   double milesRadius = 0.31;
//   updateradiusvalue(value){
//     setState(() {
//       radius=value;
//     });
//   }
//
//
//   List<String> ringtones = [
//
//   ];
//   bool listFileExists = true;
//
//   String? _selectedUnit; // Variable to store the selected unit
//
//   // Dropdown options
//   List<String> _units = ['Metric system (m/km)', 'Imperial system (mi/ft)'];
//   String? selectedRingtone ;
//   // DropdownButton<String> _buildRingtoneDropdown() {
//   //   return
//   //     DropdownButton<String>(
//   //     value: selectedRingtone,
//   //     icon: const Icon(Icons.arrow_drop_down),
//   //     isExpanded: true, // Expand to fill available space
//   //     items: ringtones.map((ringtone) => DropdownMenuItem<String>(
//   //       value: ringtone,
//   //       child: Text(ringtone.split('/').last), // Display only filename
//   //     )).toList(),
//   //     onChanged: (String? value) async {
//   //       if (value != null) { // Handle null selection gracefully
//   //         setState(() {
//   //           selectedRingtone = value;
//   //           _saveSelectedRingtone(value);
//   //         }
//   //         );
//   //
//   //         _saveSelectedRingtone(value); // Persist selection
//   //         _playRingtone(selectedRingtone!); // Play or set notification sound
//   //
//   //         await flutterLocalNotificationsPlugin
//   //             .resolvePlatformSpecificImplementation<
//   //             AndroidFlutterLocalNotificationsPlugin>()
//   //             ?.deleteNotificationChannel("my_foreground");
//   //       }
//   //     },
//   //     hint:  Text('Select Ringtone',style:Theme.of(context).textTheme.bodyMedium,), // Use const for immutability
//   //
//   //     underline: Container(
//   //       height: 2,
//   //       color: Colors.transparent,
//   //     ),
//   //   );
//   // }
//   DropdownButton<String> _buildRingtoneDropdown() {
//     return DropdownButton<String>(
//       value: selectedRingtone,
//       icon: const Icon(Icons.arrow_drop_down),
//       isExpanded: true,
//
//       items: ringtones.map((ringtone) => DropdownMenuItem<String>(
//         value: ringtone,
//         child: Text(ringtone.split('/').last),
//       )).toList(),
//       onChanged: (String? value) async {
//         if (value != null) {
//           setState(() {
//             selectedRingtone = value;
//              // Save selected ringtone
//           });
//           _saveSelectedRingtone(value);
//           _playRingtone(selectedRingtone!);
//
//           // await flutterLocalNotificationsPlugin
//           //     .resolvePlatformSpecificImplementation<
//           //     AndroidFlutterLocalNotificationsPlugin>()
//           //     ?.deleteNotificationChannel("my_foreground");
//         }
//       },
//       hint: Text( "Select Ringtone", style: Theme.of(context).textTheme.bodyMedium),
//       underline: Container(
//         height: 2,
//         color: Colors.transparent,
//       ),
//     );
//   }
//
//
//   Future<void> _loadRingtones() async {
//     try {
//       if (listFileExists) {  // Check if list.txt exists (optional)
//         ringtones = await rootBundle.loadString('assets/list.txt').then(
//               (data) => data.split(','),
//         );
//       } else {
//         // Handle the case where list.txt is missing (optional)
//         // You could list filenames directly or provide a default message
//       }
//     } on FlutterError catch (e) {
//       // Handle error if list.txt is missing or inaccessible
//       print("Error loading ringtones: $e");
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       selectedRingtone=prefs.getString('selectedRingtone') ?? "alarm6.mp3";
//     });
//   }
//   // Future<void> _saveSelectedRingtone(String ringtone) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   prefs.reload();
//   //   await prefs.setString('selectedRingtone', ringtone);
//   //   print(ringtone);
//   // }
//
//   // void _saveSelectedRingtone(String value) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   await prefs.setString('selectedRingtone', selectedRingtone!);
//   // }
//   // Future<void> _playRingtone(String ringtone) async {
//   //   // Replace 'assets/ringtones/' with your actual path if different
//   //   final ringtonePath = 'ringtone/$ringtone';
//   //   print("$ringtone");
//   //   try {
//   //     await _audioPlayer.setSource(AssetSource(ringtonePath));
//   //     print("$ringtone");
//   //     print("is successfull ");
//   //   } catch (e) {
//   //     if (e is PlatformException) {
//   //       print('Audio playback error: ${e.message}'); // Log the entire error message
//   //     } else {
//   //       print('Unexpected error: $e');
//   //     }
//   //   }
//   //
//   // }
//   Future<void> _saveSelectedRingtone(String ringtone) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('selectedRingtone', ringtone);
//       print('Selected ringtone saved: $ringtone');
//     } catch (e) {
//       print('Error saving selected ringtone: $e');
//     }
//   }
//
//   Future<void> _playRingtone(String ringtone) async {
//     // Ensure assets/alarm_ringtones/ is the correct path
//     final ringtonePath = '$ringtone';
//     try {
//       await _audioPlayer.play(AssetSource(ringtonePath));
//       // await _audioPlayer.setSource(AssetSource(ringtonePath));
//       // await _audioPlayer.resume(); // Start playing the ringtone
//     } catch (e) {
//       if (e is PlatformException) {
//         print('Audio playback error: ${e.message}'); // Log the entire error message
//       } else {
//         print('Unexpected error: $e');
//       }
//     }
//   }
//   Future<void> _saveAllSettings() async {
//     await _selectedUnit;
//     await _saveSelectedRingtone(selectedRingtone!);
//     await _saveRadiusData();
//
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('hasSetSettings', true);
//   }
//   void _handleSettingsSet() async {
//     if (_areAllFieldsFilled()) {
//       // Navigate to MyAlarmsPage only if all fields are filled
//       // and hasSetSettings is true
//       await _saveAllSettings();
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => MyAlarmsPage()),
//       );
//     } else {
//       // Show popup if any fields are empty
//       showRequiredFieldsPopup();
//     }
//   }
//   void showRequiredFieldsPopup() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Required Fields"),
//           content: Text("Please fill in all the required fields."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the popup
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   bool _areAllFieldsFilled() {
//     return _selectedUnit != null &&
//         selectedRingtone != null &&
//         meterRadius != null &&
//         milesRadius != null;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _audioPlayer.stop(); // Stop the audio player when the widget is disposed
//   }
//   void initState()  {
//     super.initState();
//     _loadSelectedUnit();
//     _loadRingtones();
//     // _buildRingtoneDropdown();
//     _loadRadiusData();
//     _handleSettingsSet();
//   }
//
//   void _saveSelectedUnit(String newValue) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('selectedUnit', newValue);
//     setState(() {
//       _selectedUnit = newValue;
//     });
//   }
//   Future _loadSelectedUnit() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       _selectedUnit = prefs.getString('selectedUnit');
//       _imperial=(_selectedUnit == 'Imperial system (mi/ft)');
//       radius=_imperial?1.24:2000;
//     });
//   }
//   Future<void> _loadRadiusData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       meterRadius = prefs.getDouble('meterRadius') ?? 0.0;
//       milesRadius = prefs.getDouble('milesRadius') ?? 0.0;
//     });
//   }
//   Future<void> _saveRadiusData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('meterRadius', meterRadius);
//     await prefs.setDouble('milesRadius', milesRadius);
//
//   }
//   Future<void> _launchInBrowser(Uri url) async {
//     if (!await launchUrl(
//       url,
//       mode: LaunchMode.externalApplication,
//     )) {
//       throw Exception('Could not launch $url');
//     }
//   }
//   Future<void>? _launched;
//   int screenIndex=2;
//   final Uri toLaunch =
//   Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
//   void handleScreenChanged(int index) {
//     switch (index) {
//       case 0: // Alarm List
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => MyAlarmsPage()));
//         // Replace with your AlarmListPage widget
//         break;
//       case 1: // Alarm List
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => MyHomePage()));
//
//         // Replace with your AlarmListPage widget
//         break;
//
//       case 2: // Saved Alarms
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => Settings())); // Replace with your SavedAlarmsPage widget
//         break;
//       case 3:
//         final RenderBox box = context.findRenderObject() as RenderBox;
//         Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
//         Share.share(
//           'Check out my awesome app: ! Download it from the app store: ',
//           subject: 'Share this amazing app!',
//           sharePositionOrigin: dummyRect,
//         );
//         break;
//       case 4:
//
//         _launchInBrowser(toLaunch);
//
//
//         break;
//       case 5:
//
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => About()));
//
//         break;
//
//     }
//   }
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   bool _imperial=false;
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: NavigationDrawer(
//         onDestinationSelected: (int index) {
//           handleScreenChanged(index); // Assuming you have a handleScreenChanged function
//         },
//         selectedIndex: screenIndex,
//         children: <Widget>[
//           SizedBox(
//             height: 32,
//           ),
//           NavigationDrawerDestination(
//
//             icon: Icon(Icons.alarm_on_outlined), // Adjust size as needed
//             label: Text('Saved Alarms'),
//             // Set selected based on screenIndex
//           ),
//           NavigationDrawerDestination(
//             icon: Icon(Icons.alarm),
//             label: Text('Set a Alarm'),
//             // Set selected based on screenIndex
//           ),
//           NavigationDrawerDestination(
//             icon: Icon(Icons.settings_outlined),
//             label: Text('Settings'),
//             // Set selected based on screenIndex
//           ),
//           Divider(),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
//             child: Text(
//               'Communicate', // Assuming this is the header
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           NavigationDrawerDestination(
//             icon: Icon(Icons.share_outlined),
//             label: Text('Share'),
//
//             // Set selected based on screenIndex
//           ),
//           NavigationDrawerDestination(
//             icon: Icon(Icons.rate_review_outlined),
//             label: Text('Rate/Review'),
//             // Set selected based on screenIndex
//           ),
//           Divider(),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
//             child: Text(
//               'App', // Assuming this is the header
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//           ),
//           NavigationDrawerDestination(
//             icon: Icon(Icons.error_outline_outlined),
//             label: Text('About'),
//             // Set selected based on screenIndex
//           ),
//         ],
//       ),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: InkWell(
//             onTap: (){
//               _scaffoldKey.currentState?.openDrawer();
//             },
//             child: Icon(Icons.menu,size: 25,color: Colors.black,)),
//         centerTitle: true,
//         title: Text(
//           textAlign: TextAlign.center,
//           "Settings",
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Text('Units',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             DropdownButton<String>(
//               value: _selectedUnit,
//               onChanged: (newValue) {
//                 setState(() {
//                   _selectedUnit = newValue; // Update the selected unit
//                   _isMetricSystem = newValue == 'Metric system (m/km)'; // Update the metric system flag
//                   _saveSelectedUnit(newValue!); // Save the selected unit
//                 });
//               },
//               hint: Text('Select Unit'),
//               style: Theme.of(context).textTheme.bodyMedium,
//               underline: Container(
//                 height: 2,
//                 color: Colors.transparent,
//               ),
//               icon: Icon(Icons.arrow_drop_down),
//               isExpanded: true,
//               items: _units.map((unit) {
//                 return DropdownMenuItem<String>(
//                   value: unit,
//                   child: Text(unit),
//                 );
//               }).toList(),
//             ),
//             Divider(),
//             SizedBox(
//               height: 20,
//             ),
//             Text('Alarm',
//               style:Theme.of(context).textTheme.titleLarge, ),
//             Container(
//               child: _buildRingtoneDropdown(),
//             ),
//             Divider(),
//             SizedBox(
//               height: 20,
//             ),
//             Text('Radius',style: Theme.of(context).textTheme.titleLarge, ),
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               child: Column(
//
//                 children: [
//                   // Visibility widget for the Meter slider
//                   Visibility(
//                     visible: _isMetricSystem, // Show only if metric system is selected
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Radius in Meter', style: Theme.of(context).textTheme.bodyMedium,),
//                         Slider(
//                           min: 0,
//                           max: 10000, // Adjust max value according to your requirement
//                           value: meterRadius,
//                           onChanged: (double value) {
//                             setState(() {
//                               meterRadius = double.parse(value.toStringAsFixed(2));
//                             });
//                             _saveRadiusData();
//                           },
//                         ),
//                         Text('Meters Radius: ${meterRadius.toStringAsFixed(_imperial ? 2:0)}', style: Theme.of(context).textTheme.bodyMedium,),
//                         // Text('Meter Radius: ${meterRadius.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
//                       ],
//                     ),
//                   ),
//                   // Visibility widget for the Miles slider
//                   Visibility(
//                     visible: !_isMetricSystem, // Show only if imperial system is selected
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Radius in Miles', style: TextStyle(fontSize: 16)),
//                         Slider(
//                           min: 0,
//                           max: 10, // Adjust max value according to your requirement
//                           value: milesRadius,
//                           onChanged: (double value) {
//                             setState(() {
//                               milesRadius = double.parse(value.toStringAsFixed(2));
//
//                             });
//                             _saveRadiusData();
//                           },
//                         ),
//                         // Text(milesRadius.toStringAsFixed(_imperial ? 2:0)+' ${_imperial ? 'miles' : 'meters'}'),
//                         Text('Miles Radius: ${milesRadius.toStringAsFixed(_imperial ? 2:0)}', style: TextStyle(fontSize: 16)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 50.0,left: 120),
//               child: FilledButton(
//                 onPressed: () {
//                   _handleSettingsSet();
//     },  child: Text("Set"),
//                 // Call the saveAlarm functio
//                 ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
//   // Method to retrieve the package name of the sound settings app
//
//   // Future<void> _pickRingtone() async {
//   //   FilePickerResult? result = await FilePicker.platform.pickFiles(
//   //     type: FileType.audio,
//   //     allowCompression: true,
//   //   );
//   //
//   //   if (result != null) {
//   //     String? filePath = result.files.single.path;
//   //     if (filePath != null) {
//   //       // Use the selected ringtone file path
//   //       print('Selected ringtone: $filePath');
//   //       // You can save the file path or use it directly in your app
//   //     }
//   //   } else {
//   //     // User canceled the picker
//   //   }
//   // }
//
//
//
//
// }

import 'package:audioplayers/audioplayers.dart'; // Add this line
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMetricSystem = true;
  double radius=0;
  double meterRadius = 100; // Initial value for meter radius
  double milesRadius = 0.31;
  updateradiusvalue(value){
    setState(() {
      radius=value;
    });
  }
  List<String> ringtones = [

  ];
  bool listFileExists = true;

  String? _selectedUnit; // Variable to store the selected unit

  // Dropdown options
  List<String> _units = ['Metric system (m/km)', 'Imperial system (mi/ft)'];
  String? selectedRingtone ;
  // DropdownButton<String> _buildRingtoneDropdown() {
  //   return
  //     DropdownButton<String>(
  //     value: selectedRingtone,
  //     icon: const Icon(Icons.arrow_drop_down),
  //     isExpanded: true, // Expand to fill available space
  //     items: ringtones.map((ringtone) => DropdownMenuItem<String>(
  //       value: ringtone,
  //       child: Text(ringtone.split('/').last), // Display only filename
  //     )).toList(),
  //     onChanged: (String? value) async {
  //       if (value != null) { // Handle null selection gracefully
  //         setState(() {
  //           selectedRingtone = value;
  //           _saveSelectedRingtone(value);
  //         }
  //         );
  //
  //         _saveSelectedRingtone(value); // Persist selection
  //         _playRingtone(selectedRingtone!); // Play or set notification sound
  //
  //         await flutterLocalNotificationsPlugin
  //             .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //             ?.deleteNotificationChannel("my_foreground");
  //       }
  //     },
  //     hint:  Text('Select Ringtone',style:Theme.of(context).textTheme.bodyMedium,), // Use const for immutability
  //
  //     underline: Container(
  //       height: 2,
  //       color: Colors.transparent,
  //     ),
  //   );
  // }
  DropdownButton<String> _buildRingtoneDropdown() {
    return DropdownButton<String>(
      value: selectedRingtone,
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,

      items: ringtones.map((ringtone) => DropdownMenuItem<String>(
        value: ringtone,
        child: Text(ringtone.split('/').last),
      )).toList(),
      onChanged: (String? value) async {
        if (value != null) {
          setState(() {
            selectedRingtone = value;
            // Save selected ringtone
          });
          _saveSelectedRingtone(value);
          _playRingtone(selectedRingtone!);

          // await flutterLocalNotificationsPlugin
          //     .resolvePlatformSpecificImplementation<
          //     AndroidFlutterLocalNotificationsPlugin>()
          //     ?.deleteNotificationChannel("my_foreground");
        }
      },
      hint: Text( "Select Ringtone", style: Theme.of(context).textTheme.bodyMedium),
      underline: Container(
        height: 2,
        color: Colors.transparent,
      ),
    );
  }


  Future<void> _loadRingtones() async {
    try {
      if (listFileExists) {  // Check if list.txt exists (optional)
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
      selectedRingtone=prefs.getString('selectedRingtone') ?? "alarm6.mp3";
    });
  }
  // Future<void> _saveSelectedRingtone(String ringtone) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.reload();
  //   await prefs.setString('selectedRingtone', ringtone);
  //   print(ringtone);
  // }

  // void _saveSelectedRingtone(String value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('selectedRingtone', selectedRingtone!);
  // }
  // Future<void> _playRingtone(String ringtone) async {
  //   // Replace 'assets/ringtones/' with your actual path if different
  //   final ringtonePath = 'ringtone/$ringtone';
  //   print("$ringtone");
  //   try {
  //     await _audioPlayer.setSource(AssetSource(ringtonePath));
  //     print("$ringtone");
  //     print("is successfull ");
  //   } catch (e) {
  //     if (e is PlatformException) {
  //       print('Audio playback error: ${e.message}'); // Log the entire error message
  //     } else {
  //       print('Unexpected error: $e');
  //     }
  //   }
  //
  // }
  Future<void> _saveSelectedRingtone(String ringtone) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedRingtone', ringtone);
      print('Selected ringtone saved: $ringtone');
    } catch (e) {
      print('Error saving selected ringtone: $e');
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
        print('Audio playback error: ${e.message}'); // Log the entire error message
      } else {
        print('Unexpected error: $e');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop(); // Stop the audio player when the widget is disposed
  }
  void initState()  {
    super.initState();
    _loadSelectedUnit();
    _loadRingtones();
    // _buildRingtoneDropdown();
    _loadRadiusData();
    // Set the release mode to keep the source after playback has completed.
    // Start the player as soon as the app is displayed.
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await _audioPlayer.setSource(AssetSource( "ringtone/$ringtones"));
    //   await _audioPlayer.resume();
    // });
    // Load selected unit when the widget initializes


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
      _imperial=(_selectedUnit == 'Imperial system (mi/ft)');
      radius=_imperial?1.24:2000;
    });
  }
  Future<void> _loadRadiusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      meterRadius = prefs.getDouble('meterRadius') ?? 0.0;
      milesRadius = prefs.getDouble('milesRadius') ?? 0.0;
    });
  }
  Future<void> _saveRadiusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('meterRadius', meterRadius);
    await prefs.setDouble('milesRadius', milesRadius);

  }
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  Future<void>? _launched;
  int screenIndex=2;
  final Uri toLaunch =
  Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
  void handleScreenChanged(int index) {
    switch (index) {
      case 0: // Alarm List
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyAlarmsPage()));
        // Replace with your AlarmListPage widget
        break;
      case 1: // Alarm List
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyHomePage()));

        // Replace with your AlarmListPage widget
        break;

      case 2: // Saved Alarms
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Settings())); // Replace with your SavedAlarmsPage widget
        break;
      case 3:
        final RenderBox box = context.findRenderObject() as RenderBox;
        Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
        Share.share(
          'Check out my awesome app: ! Download it from the app store: ',
          subject: 'Share this amazing app!',
          sharePositionOrigin: dummyRect,
        );
        break;
      case 4:

        _launchInBrowser(toLaunch);


        break;
      case 5:

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => About()));

        break;

    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  bool _imperial=false;
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(
        onDestinationSelected: (int index) {
          handleScreenChanged(index); // Assuming you have a handleScreenChanged function
        },
        selectedIndex: screenIndex,
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          NavigationDrawerDestination(

            icon: Icon(Icons.alarm_on_outlined), // Adjust size as needed
            label: Text('Saved Alarms'),
            // Set selected based on screenIndex
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.alarm),
            label: Text('Set a Alarm'),
            // Set selected based on screenIndex
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            label: Text('Settings'),
            // Set selected based on screenIndex
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

            // Set selected based on screenIndex
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.rate_review_outlined),
            label: Text('Rate/Review'),
            // Set selected based on screenIndex
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
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
            onTap: (){
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(Icons.menu,size: 25,color: Colors.black,)),
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          "Settings",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text('Units',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            DropdownButton<String>(
              value: _selectedUnit,
              onChanged: (newValue) {
                setState(() {
                  _selectedUnit = newValue; // Update the selected unit
                  _isMetricSystem = newValue == 'Metric system (m/km)'; // Update the metric system flag
                  _saveSelectedUnit(newValue!); // Save the selected unit
                });
              },
              hint: Text('Select Unit'),
              style: Theme.of(context).textTheme.bodyMedium,
              underline: Container(
                height: 2,
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
              height: 20,
            ),
            Text('Alarm',
              style:Theme.of(context).textTheme.titleLarge, ),
            Container(
              child: _buildRingtoneDropdown(),
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Text('Radius',style: Theme.of(context).textTheme.titleLarge, ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(

                children: [
                  // Visibility widget for the Meter slider
                  Visibility(
                    visible: _isMetricSystem, // Show only if metric system is selected
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Radius in Meter', style: Theme.of(context).textTheme.bodyMedium,),
                        Slider(
                          min: 0,
                          max: 10000, // Adjust max value according to your requirement
                          value: meterRadius,
                          onChanged: (double value) {
                            setState(() {
                              meterRadius = double.parse(value.toStringAsFixed(2));
                            });
                            _saveRadiusData();
                          },
                        ),
                        Text('Meters Radius: ${meterRadius.toStringAsFixed(_imperial ? 2:0)}', style: Theme.of(context).textTheme.bodyMedium,),
                        // Text('Meter Radius: ${meterRadius.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  // Visibility widget for the Miles slider
                  Visibility(
                    visible: !_isMetricSystem, // Show only if imperial system is selected
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Radius in Miles', style: TextStyle(fontSize: 16)),
                        Slider(
                          min: 0,
                          max: 10, // Adjust max value according to your requirement
                          value: milesRadius,
                          onChanged: (double value) {
                            setState(() {
                              milesRadius = double.parse(value.toStringAsFixed(2));

                            });
                            _saveRadiusData();
                          },
                        ),
                        // Text(milesRadius.toStringAsFixed(_imperial ? 2:0)+' ${_imperial ? 'miles' : 'meters'}'),
                        Text('Miles Radius: ${milesRadius.toStringAsFixed(_imperial ? 2:0)}', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
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















