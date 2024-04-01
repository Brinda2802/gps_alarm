import 'dart:convert';
import 'package:audioplayers/audioplayers.dart'; // Add this line

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitiled/Homescreens/save%20alarm%20pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:file_picker/file_picker.dart';


import '../Map screen page.dart';
import '../Track.dart';


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late  final AudioPlayer _audioPlayer = AudioPlayer();
  double radius=0;
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
  DropdownButton<String> _buildRingtoneDropdown() {
    return DropdownButton<String>(
      value: selectedRingtone,
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true, // Expand to fill available space
      items: ringtones.map((ringtone) => DropdownMenuItem<String>(
        value: ringtone,
        child: Text(ringtone.split('/').last), // Display only filename
      )).toList(),
      onChanged: (String? value) {
        if (value != null) { // Handle null selection gracefully
          setState(() {
            selectedRingtone = value;
            _saveSelectedRingtone(value); // Persist selection
            _playRingtone(selectedRingtone!); // Play or set notification sound
          });
        }
      },
      hint: const Text('Select Ringtone'), // Use const for immutability
      style: const TextStyle( // Use const for immutability
        color: Colors.black,
        fontSize: 18,
      ),
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
  }
  Future<void> _saveSelectedRingtone(String ringtone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRingtone', ringtone);
  }

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
    _buildRingtoneDropdown();



    // Set the release mode to keep the source after playback has completed.


    // Start the player as soon as the app is displayed.
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await _audioPlayer.setSource(AssetSource( "ringtone/$ringtones"));
    //   await _audioPlayer.resume();
    // });
    // Load selected unit when the widget initializes
  }
  // Method to load the selected unit from shared preferences
  // Method to save the selected unit to shared preferences
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

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  Future<void>? _launched;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  bool _imperial=false;
  Widget build(BuildContext context) {
    final Uri toLaunch =
    Uri(scheme: 'https', host: 'www.google.com');
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Image.asset("assets/mapimage.png",height: 100,width: 100,),
                Text('GPS ALARM',style: TextStyle(
                  color: CupertinoColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),),
              ],
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.track_changes),
              title: Text('Track'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>Track(selectedRingtone:"$selectedRingtone"   ))
                );
                // Handle item 1 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Set a alarm'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>MyHomePage())
                );
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm_on_outlined),
              title: Text('Saved Alarm'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>
                        MyAlarmsPage(


                        )));
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>Settings())
                );
                // Handle item 2 tap
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('Communicate',style: TextStyle(
                color: Colors.orange,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                setState(() {
                  _launched = _launchInBrowser(toLaunch);
                });
                // _launchInBrowser(toLaunch);
                // Handle item 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Rate/Review'),
              onTap: () {
                setState(() {
                  _launched = _launchInBrowser(toLaunch);
                });
                // Handle item 2 tap
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('App',style: TextStyle(
                color: Colors.orange,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),),
            ),
            ListTile(
              leading: Icon(Icons.error),
              title: Text('About'),
              onTap: () {
                // Handle item 2 tap
              },
            ),

            // Add more list items as needed
          ],
        ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Units',style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              value: _selectedUnit,
              onChanged: (newValue) {
                _saveSelectedUnit(newValue!); // Save the selected unit
              },
              hint: Text('Select Unit'),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              underline: Container(
                height: 2,
                color: Colors.transparent,
              ),
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 36,
              isExpanded: true,
              items: _units.map((unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),



          Divider(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Alarm',style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),),
          ),
          SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: GestureDetector(
          //     onTap: (){
          //       // _pickRingtone();
          //     },
          //     child: Text('Default Radius',style: TextStyle(
          //       color: Colors.blueGrey,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w600,
          //     ),),
          //   ),
          // ),


          // MeterCalculatorWidget(callback: updateradiusvalue),
          // Expanded(child: _buildRingtoneDropdown()),
          // DropdownButton<String>(
          //
          //   value: _selectedUnit, // Selected unit
          //   onChanged: _onUnitChanged, // Method to handle dropdown value change
          //   items: _units.map((unit) {
          //     return DropdownMenuItem<String>(
          //       value: unit,
          //       child: Text(unit),
          //     );
          //   }).toList(),
          // ),

Padding(
  padding: const EdgeInsets.all(4.0),
  child: Container(
    child: _buildRingtoneDropdown(),
  ),
),
          Divider(),Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Radius',style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: MeterCalculatorWidget(callback:updateradiusvalue,),
            ),
          ),
          Divider(),
        ],
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
class MeterCalculatorWidget extends StatefulWidget {
  final Function(double) callback;

  const MeterCalculatorWidget({
    Key? key,
    required this.callback,

  }) : super(key: key);

  @override
  _MeterCalculatorWidgetState createState() => _MeterCalculatorWidgetState();
}

class _MeterCalculatorWidgetState extends State<MeterCalculatorWidget> {
  String? _selectedUnit;
  double _radius = 200;
  bool _imperial=false;
  @override
  void initState() {
    _loadSelectedUnit();
    // TODO: implement initState
    super.initState();
  }
  Future _loadSelectedUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedUnit = prefs.getString('selectedUnit');
      _imperial=(_selectedUnit == 'Imperial system (mi/ft)');
      _radius=_imperial?1.24:2000;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedUnit);
    print(_radius);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Radius',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 15.0, // Set your desired thumb radius
                  ),
                ),
                child: Slider(

                  activeColor: Colors.red,
                  value: _radius,
                  divisions:100,
                  min:  _imperial?0.05:50,
                  max: _imperial?5.05:5050, // Set your maximum radius value here
                  onChanged: (value) {
                    setState(() {
                      _radius = double.parse(value.toStringAsFixed(2)); // Round the value to the nearest integer
                    });
                    widget.callback(value);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(' $_radius ${_imperial ? 'miles' : 'meters'}'),
          // Display the rounded value with the appropriate unit based on the selected system
        ],
      ),
    );
  }
}




