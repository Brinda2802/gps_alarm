import 'package:audioplayers/audioplayers.dart'; // Add this line
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
             FilledButton(
               onPressed: () {  },
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
