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
//                   _selectedUnit = newValue;
//                    // Update the selected unit
//                   // Update the metric system flag
//                   _saveSelectedUnit(newValue!); // Save the selected unit
//                 });
//
//                 _isMetricSystem = newValue == 'Metric system (m/km)';
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
//                 children: [
//                   // Visibility widget for the Meter slider
//                   Visibility(
//                     visible: _isMetricSystem, // Show only if metric system is selected
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text('Radius in Kilometer', style: Theme.of(context).textTheme.bodyMedium,),
//                             SizedBox(
//                               width: 150,
//                             ),
//                             Text(' ${(meterRadius/1000).toStringAsFixed(_imperial ? 0:0)}', style: Theme.of(context).textTheme.bodyMedium,),
//                             Text("Km"),
//                           ],
//                         ),
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
//
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
//                        Row(
//                          children: [
//                            Text('Radius in Miles', style: TextStyle(fontSize: 16)),
//                            SizedBox(
//                              width: 150,
//                            ),
//                            Text('${milesRadius.toStringAsFixed(_imperial ? 0:0)}', style: Theme.of(context).textTheme.bodyMedium,),
//                            Text("miles"),
//                          ],
//                        ),
//
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
//                         //Text('Miles Radius: ${milesRadius.toStringAsFixed(_imperial ? 2:0)}', style: TextStyle(fontSize: 16)),
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
//               padding:  EdgeInsets.only(top: 50.0,left: 120),
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


// import 'package:audioplayers/audioplayers.dart'; // Add this line
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
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
//             // Save selected ringtone
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
//     // Set the release mode to keep the source after playback has completed.
//     // Start the player as soon as the app is displayed.
//     // WidgetsBinding.instance.addPostFrameCallback((_) async {
//     //   await _audioPlayer.setSource(AssetSource( "ringtone/$ringtones"));
//     //   await _audioPlayer.resume();
//     // });
//     // Load selected unit when the widget initializes
//
//
//   }
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
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
// // Method to retrieve the package name of the sound settings app
//
// // Future<void> _pickRingtone() async {
// //   FilePickerResult? result = await FilePicker.platform.pickFiles(
// //     type: FileType.audio,
// //     allowCompression: true,
// //   );
// //
// //   if (result != null) {
// //     String? filePath = result.files.single.path;
// //     if (filePath != null) {
// //       // Use the selected ringtone file path
// //       print('Selected ringtone: $filePath');
// //       // You can save the file path or use it directly in your app
// //     }
// //   } else {
// //     // User canceled the picker
// //   }
// // }
//
//
//
//
// }




import 'dart:io';

import 'package:audioplayers/audioplayers.dart'; // Add this line
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  double meterRadius = 0.1; // Initial value for meter radius
  double milesRadius = 0.1;
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
  String? kSharedPrefVibrate = 'vibrateEnabled';
  String? kSharedPrefBoth = 'useBoth';
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
          _savesettings(selectedRingtone!);
          // _saveSelectedRingtone(value);
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
  // Future<void> _saveSettings(String ringtone) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('selectedRingtone', ringtone);
  //     print('Selected ringtone saved: $ringtone');
  //     await prefs.setString('selectedRingtone', selectedRingtone!); // Existing ringtone storage
  //     await prefs.setBool(kSharedPrefVibrate!, isSwitched); // Store vibrate state
  //     await prefs.setString(kSharedPrefBoth!, _selectedOption == 'Both' ? 'Both' : ''); // Store "Both" state (empty string for non-Both)
  //     print('Settings saved successfully!');
  //     print("selectedringtone:" + selectedRingtone!);
  //     print("vibrateoption" + kSharedPrefVibrate!);
  //     print("bothvalue:" + kSharedPrefBoth!);
  //
  //   } catch (e) {
  //     print('Error saving settings: $e');
  //   }
  // }
  String kSharedPrefOption = 'selected_option';
  // void _saveSettings(String ringtone) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (_selectedOption == 'Both') {
  //     _playRingtone(ringtone);
  //     // Save both ringtone and vibration settings
  //     await prefs.setString('selectedOption', _selectedOption);
  //     await prefs.setBool(kSharedPrefVibrate!, true);
  //     await prefs.setString(kSharedPrefBoth!, 'Both');
  //     await prefs.setString('selectedRingtone', ringtone); // Save the selected ringtone
  //   } else {
  //     // Save ringtone based on selection, vibration based on switch
  //     await prefs.setString('selectedOption', _selectedOption);
  //     await prefs.setBool(kSharedPrefVibrate!, isSwitched);
  //     await prefs.remove(kSharedPrefBoth!); // Remove the 'Both' flag if not selected
  //     await prefs.setString('selectedRingtone', ringtone); // Save the selected ringtone
  //   }
  //
  //   // Play the selected ringtone
  //   }
  // Future<void> _loadSettings() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     setState(() {
  //       selectedRingtone = prefs.getString('selectedRingtone') ?? "";
  //       isSwitched = prefs.getBool(kSharedPrefVibrate!) ?? false;
  //       // Check for "Both" state based on the stored value
  //       _selectedOption = prefs.getString(kSharedPrefBoth!) == 'Both' ? 'Both' : _selectedOption; // Maintain existing selection if not "Both"
  //     });
  //   } catch (e) {
  //     print('Error loading settings: $e');
  //   }
  // }
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
  Future<void> _saveRadiusData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('meterRadius', meterRadius * 1000); // Store in meters
    await prefs.setDouble('milesRadius', milesRadius);

    // Optionally save unit system preference
    await prefs.setBool('unitSystem', _isMetricSystem); // Save current preference
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
  void handleScreenChanged(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyAlarmsPage()),
              (Route<dynamic> route) => false, // This condition will remove all routes
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
        Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
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
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => About()));
        break;
    }
  }

  // void handleScreenChanged(int index) {
  //   switch (index) {
  //     case 0:
  //       Navigator.of(context).pop();
  //       // No pop needed for screen1 as it's likely the first screen
  //       // Navigator.pushAndRemoveUntil(context, '/screen1');
  //       // Navigate to screen1
  //       // Navigator.popUntil(context, ModalRoute.withName('/screen1'));
  //
  //       break;
  //     case 1:
  //       Navigator.of(context).pop();
  //       // No pop needed for screen2 as it's likely the first screen
  //       //Navigator.pushNamed(context, '/screen2');
  //       //  Navigator.popUntil(context, ModalRoute.withName('/screen1')); //Navigate to screen2
  //       break;
  //     case 2:
  //       Navigator.of(context).pop();
  //      // Navigator.pushNamed(context, '/screen3'); // Navigate to screen3
  //      //  Navigator.popUntil(context, ModalRoute.withName('/screen2'));
  //       break;
  //     case 3:
  //       Navigator.of(context).pop();
  //       // Share functionality, no navigation
  //       final RenderBox box = context.findRenderObject() as RenderBox;
  //       Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
  //       Share.share(
  //         'Check out my awesome app! Download it from the app store:',
  //         subject: 'Share this amazing app!',
  //         sharePositionOrigin: dummyRect,
  //       );
  //       // Navigator.popUntil(context, ModalRoute.withName('/screen3'));
  //       break;
  //     case 4:
  //       Navigator.of(context).pop();
  //       // Launch URL, no navigation
  //       _launchInBrowser(toLaunch);
  //       // Navigator.popUntil(context, ModalRoute.withName('/screen4'));
  //       break;
  //     case 5:
  //       Navigator.of(context).pop();
  //       // Navigator.pushNamed(context, '/screen5'); // Navigate to screen4
  //       break;
  //   }
  // }
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
  Future<void> _saveAllSettings() async {
    // await _selectedUnit;
    // await _saveSelectedRingtone(selectedRingtone!);
    await _saveRadiusData();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSetSettings', true);
  }
  void _handleSettingsSet() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSetSettings = prefs.getBool('hasSetSettings') ?? false; // Check if settings have been set
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
  void initState()  {
    super.initState();
    _loadSettings();
    _loadSelectedUnit();
    _loadRingtones();
    //_loadSettings();
    _loadRadiusData();
    _LoadSettings();
    // _saveBothSettings();
    // _handleSettingsSet();
  }
  Future<void> _savesettings(String ringtone) async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRingtone', ringtone);
    await prefs.setString('selected_alarm_option', _selectedOption!) ;
    print('Saved alarm option: $_selectedOption');
    print('Selected ringtone saved: $ringtone');
  }
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedRingtone = prefs.getString('selectedRingtone');
    final selectedOption = prefs.getString('selected_alarm_option');

    // Use the loaded values as needed
    print('Loaded alarm option: $selectedOption');
    print('Selected ringtone loaded: $selectedRingtone');
  }
  Future<void> _Savesettings(String selectedOption) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_alarm_option', selectedOption);
    print('Saved alarm option: $selectedOption');
  }
  Future<void> _LoadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedOption = prefs.getString('selected_alarm_option') ?? 'Alarms'; // Default value if not found
    setState(() {
      _selectedOption = selectedOption;
    });
    print('Loaded alarm option: $_selectedOption');
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
  // Future<void> _loadRadiusData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     meterRadius = (prefs.getDouble('meterRadius') ?? 100) / 1000;
  //     milesRadius = prefs.getDouble('milesRadius') ?? 0.10;
  //     print("meterradius:"+meterRadius.toString());
  //     print("milesradius:"+milesRadius.toString());
  //   });
  // }
  // Future<void> _saveRadiusData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setDouble('meterRadius', meterRadius*1000);
  //   await prefs.setDouble('milesRadius', milesRadius);
  //
  // }
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  // Future<void> _loadOptions() async {
  //   try {
  //     // Load ringtones
  //     if (listFileExists) {
  //       ringtones = await rootBundle.loadString('assets/list.txt').then(
  //             (data) => data.split(','),
  //       );
  //     } else {
  //       // Handle the case where list.txt is missing (optional)
  //     }
  //
  //     // Load selected ringtone
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     setState(() {
  //       selectedRingtone = prefs.getString('selectedRingtone') ?? "alarm6.mp3";
  //       _selectedOption = prefs.getString('selectedOption') ?? 'Alarms';
  //       isSwitched = prefs.getBool('isSwitched') ?? false;
  //       print("selectedRingtone" +selectedRingtone!);
  //       print("selectedoption" +_selectedOption!);
  //     });
  //   } on FlutterError catch (e) {
  //     // Handle error if list.txt is missing or inaccessible
  //     print("Error loading options: $e");
  //   }
  // }


  // Future<void> _loadRadiusData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     // Load meter radius (convert from kilometers if stored)
  //     meterRadius = prefs.getDouble('meterRadius')?.toDouble() ?? 100;
  //     meterRadius /= 1000; // Convert kilometers to meters if previously stored
  //
  //     // Load miles radius
  //     milesRadius = prefs.getDouble('milesRadius') ?? 0.10;
  //
  //     // Load unit system preference (default to metric)
  //     _isMetricSystem = prefs.getBool('unitSystem') ?? true;
  //   });
  // }
  Future<void>? _launched;
  int screenIndex=2;
  final Uri toLaunch =
  Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
  // void handleScreenChanged(int index) {
  //   switch (index) {
  //     case 0: // Alarm List
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => MyAlarmsPage()));
  //       // Replace with your AlarmListPage widget
  //       break;
  //     case 1: // Alarm List
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => MyHomePage()));
  //
  //       // Replace with your AlarmListPage widget
  //       break;
  //
  //     case 2:
  //
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
  //
  //       _launchInBrowser(toLaunch);
  //
  //
  //       break;
  //     case 5:
  //
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => About()));
  //
  //       break;
  //
  //   }
  // }
  // void handleScreenChanged(int index) {
  //   switch (index) {
  //     case 0: // Alarm List
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => MyAlarmsPage()));
  //       break;
  //     case 1: // Alarm List
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => MyHomePage()));
  //       break;
  //     case 2:
  //       Navigator.of(context).push(
  //           MaterialPageRoute(builder: (context) => Settings()));
  //       break;
  //     case 3:
  //       final RenderBox box = context.findRenderObject() as RenderBox;
  //       Rect dummyRect = Rect.fromCenter(center: box.localToGlobal(Offset.zero), width: 1.0, height: 1.0);
  //       Share.share(
  //         'Check out my awesome app! Download it from the app store:',
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
  //       break;
  //   }
  // }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSwitched = false;
  String? _options;
  String?_selectedOption;
  // void handleAlarmOpen() {
  //   setState(() {
  //     isSwitched = false; // Turn off vibration switch visually
  //     _saveSettings(selectedRingtone!); // Update settings based on selection
  //   });
  // }
  @override
  bool _imperial=false;
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(
        onDestinationSelected: (int index) {
          handleScreenChanged(index); // Assuming you have a handleScreenChanged function
        },
        selectedIndex: screenIndex,
        children: <Widget>[
          SizedBox(
            height:height/23.625,
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
            padding:  EdgeInsets.fromLTRB(28, 16, 16, 10),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:height/37.8,
              ),
              Text('Units',
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
                  height: height/378,
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
              /* DropdownButton<String> _buildRingtoneDropdown() {
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
          }*/
              Divider(),
              SizedBox(
                height:height/37.8,
              ),
              Text('Options',
                style:Theme.of(context).textTheme.titleLarge,),
              // DropdownButton<String>(
              //   value: dropdownValue,
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       dropdownValue = newValue!;
              //     });
              //   },
              //   items: <String>['Alarms', 'Vibrate', 'Alarms and Vibrate']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // ),
              // DropdownButton<String>(
              //   value: _selectedOption,
              //   onChanged: (String? newValue) {
              //     // handleAlarmOpen();
              //     setState(() {
              //       _selectedOption = newValue!;
              //       _savesettings(selectedRingtone!);
              //       // Save the selected option
              //     });
              //     _savesettings(selectedRingtone!);
              //     _Savesettings(newValue!);
              //
              //
              //   },
              //   hint: Text("Alarms"),
              //   style: Theme.of(context).textTheme.bodyMedium,
              //   underline: Container(
              //     height: height / 37.8,
              //     color: Colors.transparent,
              //   ),
              //   icon: Icon(Icons.arrow_drop_down),
              //   isExpanded: true,
              //   items: ['Alarms', 'Vibrate','both'].map((option) {
              //     return DropdownMenuItem<String>(
              //       value: option,
              //       child: Text(option),
              //     );
              //   }).toList(),
              // ),
              RadioListTile<String>(
                title: Text('Alarms'),
                value: 'alarms',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                    _savesettings(selectedRingtone!);
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Vibrate'),
                value: 'vibrate',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                    _savesettings(selectedRingtone!);
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Both'),
                value: 'both',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                    _savesettings(selectedRingtone!);
                  });
                },
              ),
              Divider(),

              Visibility(
                visible: _selectedOption == 'alarms'  ||  _selectedOption == 'both' ,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height:height/37.8,
                      ),
                      Text('Alarm', style: Theme.of(context).textTheme.titleLarge,),
                      _buildRingtoneDropdown(),
                      Divider(),
                    ],
                  ),
                ),
              ),

              // Visibility for Vibrate settings
              //               Visibility(
              //                 visible: _selectedOption == 'Vibrate' || _selectedOption == 'both',
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text('Vibrate', style: Theme.of(context).textTheme.titleLarge,),
              //                     // Switch(
              //                     //   value: isSwitched,
              //                     //   onChanged: (bool value) {
              //                     //     setState(() {
              //                     //       isSwitched = value;
              //                     //       // Call function to store switch value
              //                     //       _saveSettings(selectedRingtone!);
              //                     //     });
              //                     //   },
              //                     // ),
              //                   ],
              //                 ),
              //               ),

              // Text('Alarm',
              //   style:Theme.of(context).textTheme.titleLarge,),
              // Container(
              //   child: _buildRingtoneDropdown(),
              // ),
              // Divider(),
              // SizedBox(
              //   height:height/37.8,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Vibrate',
              //       style:Theme.of(context).textTheme.titleLarge,),
              //     Switch(
              //       value: isSwitched,
              //       onChanged: (bool value) {
              //         setState(() {
              //           isSwitched = value; // Update the state of the switch when it's toggled
              //         });
              //       },
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height:height/37.8,
              // ),
              //
              // Divider(),
              SizedBox(
                height:height/37.8,
              ),
              Text('Radius',style: Theme.of(context).textTheme.titleLarge, ),
              SizedBox(
                height: height/75.6,
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
                          Row(
                            children: [
                              Text('Radius in Meter', style: Theme.of(context).textTheme.bodyMedium,),
                              SizedBox(
                                width: width/2.1176470,
                              ),
                              Text('${(meterRadius).toStringAsFixed(_imperial ? 2:2)}', style: Theme.of(context).textTheme.bodyMedium,),
                              Text("km"),
                            ],
                          ),
                          Slider(
                            divisions: 10,
                            min: 0.1,
                            max: 3, // Adjust max value according to your requirement
                            value: meterRadius,
                            onChanged: (double value) {
                              setState(() {
                                meterRadius = double.parse(value.toStringAsFixed(2));
                              });
                              _saveRadiusData();
                            },
                          ),

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
                          Row(
                            children: [
                              Text('Radius in Miles', style: TextStyle(fontSize: 16)),
                              SizedBox(
                                width:width/2.4,
                              ),
                              Text('${milesRadius.toStringAsFixed(_imperial ? 2:2)}', style: Theme.of(context).textTheme.bodyMedium,),

                              Text("miles"),
                            ],
                          ),
                          Slider(
                            divisions: 10,
                            min: 0.10,
                            max: 2, // Adjust max value according to your requirement
                            value: milesRadius,
                            onChanged: (double value) {
                              setState(() {
                                milesRadius = double.parse(value.toStringAsFixed(2));
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
              Text("The Minimum value must exceed 0.10",style: Theme.of(context).textTheme.bodySmall,),
              SizedBox(
                height: height/75.6,
              ),
              Padding(
                padding:  EdgeInsets.only(top:height/15.12,left:width/3),
                child: FilledButton(
                  onPressed: () {
                    _savesettings(selectedRingtone!);
                    _handleSettingsSet();
                  },  child: Text("Set"),
                  // Call the saveAlarm functio
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


// import 'package:audioplayers/audioplayers.dart'; // Add this line
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
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
//             // Save selected ringtone
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
//     // Set the release mode to keep the source after playback has completed.
//     // Start the player as soon as the app is displayed.
//     // WidgetsBinding.instance.addPostFrameCallback((_) async {
//     //   await _audioPlayer.setSource(AssetSource( "ringtone/$ringtones"));
//     //   await _audioPlayer.resume();
//     // });
//     // Load selected unit when the widget initializes
//
//
//   }
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
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
// // Method to retrieve the package name of the sound settings app
//
// // Future<void> _pickRingtone() async {
// //   FilePickerResult? result = await FilePicker.platform.pickFiles(
// //     type: FileType.audio,
// //     allowCompression: true,
// //   );
// //
// //   if (result != null) {
// //     String? filePath = result.files.single.path;
// //     if (filePath != null) {
// //       // Use the selected ringtone file path
// //       print('Selected ringtone: $filePath');
// //       // You can save the file path or use it directly in your app
// //     }
// //   } else {
// //     // User canceled the picker
// //   }
// // }
//
//
//
//
// }





























