import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitiled/Homescreens/settings.dart';
import 'package:untitiled/Track.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import '../Apiutils.dart';
import '../Map screen page.dart';
import '../about page.dart';
import '../main.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class MyAlarmsPage extends StatefulWidget {
  const MyAlarmsPage({
    super.key,
  });

  @override
  _MyAlarmsPageState createState() => _MyAlarmsPageState();
}

class _MyAlarmsPageState extends State<MyAlarmsPage> {
  LatLng? currentLocation;
  double radius = 0;

  updateradiusvalue(value) {
    setState(() {
      radius = value;
    });
  }

  bool isFavorite = false;
  List<AlarmDetails> alarms = [];

  // void _showCustomBottomSheet(BuildContext context, int index) async {
  //   TextEditingController alramnamecontroller =
  //       TextEditingController(text: alarms[index].alarmName);
  //   TextEditingController notescontroller =
  //       TextEditingController(text: alarms[index].notes);
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         child: Material(
  //           elevation: 5,
  //           borderRadius: BorderRadius.circular(30),
  //           child: Container(
  //
  //             height: 450,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               color: Colors.transparent,
  //               border: Border.all(color: Colors.black12),
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //
  //
  //             child: Column(
  //               children: [
  //                 SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             Navigator.of(context)
  //                                 .pop(); // Close the bottom sheet on cancel
  //                           },
  //                           child: Icon(Icons.close, size: 20),
  //                         ),
  //                         Text("Cancel"),
  //                       ],
  //                     ),
  //                     FilledButton(
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
  //                   ],
  //                 ),
  //                 SizedBox(height: 20),
  //                 // Integrate the MeterCalculatorWidget
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Column(
  //                       children: [
  //                         MeterCalculatorWidget(
  //                           callback: updateradiusvalue,
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Alarm Name:",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w500,
  //                           color: Colors.black,
  //                           fontSize: 18),
  //                     ),
  //                     SizedBox(height: 10),
  //                     Container(
  //                       height: 50,
  //                       width: 300,
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(color: Colors.black12),
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left: 10.0),
  //                         child: TextField(
  //                           controller: alramnamecontroller,
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                           decoration: InputDecoration(
  //                             hintText: "Alarm name",
  //                             border: InputBorder.none,
  //                             enabledBorder: InputBorder.none,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 20),
  //                     Text(
  //                       "Notes:",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w500,
  //                           color: Colors.black,
  //                           fontSize: 18),
  //                     ),
  //                     SizedBox(height: 10),
  //                     Container(
  //                       height: 50,
  //                       width: 300,
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(color: Colors.black12),
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left: 10.0),
  //                         child: TextField(
  //                           controller: notescontroller,
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                           decoration: InputDecoration(
  //                             hintText: "Notes",
  //                             border: InputBorder.none,
  //                             enabledBorder: InputBorder.none,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 20),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showCustomBottomSheet(BuildContext context, int index)async {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    TextEditingController alramnamecontroller =
          TextEditingController(text: alarms[index].alarmName);
      TextEditingController notescontroller =
          TextEditingController(text: alarms[index].notes);


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(

            height: height/2.29090,
            width: double.infinity,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Call the saveAlarm function
                      },
                      child: Text("Cancel"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 120.0),
                      child: FilledButton(
                                              onPressed: () async {
                                                setState(() {
                                                  alarms[index].alarmName = alramnamecontroller.text;
                                                  alarms[index].notes = notescontroller.text;
                                                  alarms[index].locationRadius = radius;
                                                });

                                                saveData();
                                                loadData();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Save"),
                                            ),
                    ),


                  ],
                ),

                // Integrate the MeterCalculatorWidget
                MeterCalculatorWidget(
                  callback: updateradiusvalue,

                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alarm Name:", style: Theme.of(context).textTheme.titleMedium,),

                    Container(
                      height:height/ 15.12,
                      width: width/1.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),

                      ),child: Padding(
                      padding:  EdgeInsets.only(left: width/36),
                      child: TextField(
                        controller: alramnamecontroller,

                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: "Alarm name",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    ),


                    Text("Notes:",style: Theme.of(context).textTheme.titleMedium,),

                    Container(
                      height: height/10.8,
                      width:width/1.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),

                      ),child: Padding(
                      padding:  EdgeInsets.only(left: width/36),
                      child: TextField(
                        controller: notescontroller,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: "Notes",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
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
  //       math.cos(lat1) *
  //           math.cos(lat2) *
  //           math.sin(dLon / 2) *
  //           math.sin(dLon / 2);
  //   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  //   double distance = earthRadius * c;
  //
  //   return distance / 1000;
  // }
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
  //   // Convert meters to kilometers and return the result
  //   return distanceInMeters / 1000;
  // }
  @override
  void initState() {
    super.initState();
    loadData();
    saveData();
  }
  // Future<void> sendEmail() async {
  //   final email = Email(
  //     body: 'GPSAlarm',
  //     subject: 'feedback',
  //     recipients: ['brindhakarthi02@gmail.com'],
  //   );
  //
  //   try {
  //     await FlutterEmailSender.send(email);
  //   } on Exception catch (e) {
  //     print('Error launching email: $e');
  //   }
  // }
  // Future<void> sendEmail() async {
  //   final email = Email(
  //         body: 'GPSAlarm',
  //         subject: 'feedback',
  //         recipients: ['brindhakarthi02@gmail.com'],
  //       );
  //   try {
  //     await FlutterEmailSender.send(email);
  //     // Your email sending code using mailer or flutter_email_sender
  //   } on PlatformException catch (e) {
  //     if (e.code == 'not_available') {
  //       print('No email client found!');
  //       // Show a user-friendly message explaining the issue
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('No email client found on this device. Please configure a default email app.'),
  //         ),
  //       );
  //     } else {
  //       // Handle other potential errors
  //       print('Error sending email: ${e.message}');
  //     }
  //   }
  // }
  Future<void> sendEmail(BuildContext context) async {
    final email = Email(
      body: 'GPSAlarm',
      subject: 'feedback',
      recipients: ['brindhakarthi02@gmail.com'],
    );
    try {
      await FlutterEmailSender.send(email);
      // Your email sending code using mailer or flutter_email_sender
    } on PlatformException catch (e) {
      if (e.code == 'not_available') {
        print('No email client found!');
        // Show a user-friendly message explaining the issue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No email client found on this device. Please configure a default email app.'),
          ),
        );
      } else {
        // Handle other potential errors
        print('Error sending email: ${e.message}');
      }
    }
  }

  void updateFavoriteStatus(int index, bool isFavorite) {
    setState(() {
      alarms[index].isFavourite = isFavorite;
      saveData(); // Save the updated list of alarms
    });
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? alarmsJson = prefs.getStringList('alarms');

    if (alarmsJson != null) {
      alarms = alarmsJson
          .map((json) => AlarmDetails.fromJson(jsonDecode(json)))
          .toList();
    }
    double? storedLatitude = prefs.getDouble('current_latitude');
    double? storedLongitude = prefs.getDouble('current_longitude');

    setState(() {
      if (storedLatitude != null && storedLongitude != null) {
        currentLocation = LatLng(storedLatitude, storedLongitude);
        print('Stored location: ($storedLatitude, $storedLongitude)');
        // Marker? tap = _markers.length > 1 ? _markers.last : null;
      }
    });
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> alarmsJson =
        alarms.map((alarm) => alarm.toJson()).toList();

    prefs.setStringList(
        'alarms', alarmsJson.map((json) => jsonEncode(json)).toList());

    //prefs.reload();
  }
  int screenIndex=0;
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

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
  final Uri toLaunch =
  Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color(0xffFFEF9A9A),
        title: Text("GPS Alarm" ),
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: (int index) {
          handleScreenChanged(index); // Assuming you have a handleScreenChanged function
        },
        selectedIndex: screenIndex,
        children: <Widget>[
          SizedBox(
            //height: 32,
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
      body: alarms.isEmpty
          ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/newlocationalarm.json', // Your empty list Lottie animation
                    width: 300, // Adjust as needed
                    height: 300, // Adjust as needed
                  ),
                  Text("No Alarms",style: Theme.of(context).textTheme.titleLarge),
                  Text("Create a new alarm",style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ):
      Padding(
        padding:  EdgeInsets.only(left:width/45,right:width/45),
        child: ListView.separated(
          itemCount: alarms.length,
          separatorBuilder: (context, index) {
            return SizedBox(
            height:height/94.5,
          );},
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Track(
                          alarm: alarms[index],
                        )));
              },
              child: Card.filled(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${alarms[index].alarmName}",
                             style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis, // Add this line
                            ),
                          ),

                          Switch(
                            // This bool value toggles the switch.
                            value: alarms[index].isEnabled,
                            onChanged: (value) {
                              setState(() {
                                alarms[index].isEnabled = value;
                                saveData();
                              });
                            },
                          ),
                          // Text(
                          //   currentLocation != null
                          //       ? calculateDistance(
                          //               LatLng(currentLocation!.latitude,
                          //                   currentLocation!.longitude),
                          //               LatLng(alarms[index].lat,
                          //                   alarms[index].lng))
                          //           .toStringAsFixed(0)
                          //       : "3km",
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // Text(
                          //   "km",
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //     // color: Colors.green,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                        ],
                      ),

                      Text(
                        "${alarms[index].notes}",
                         style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).colorScheme.primary,

                            
                                ),
                                Text(
                                  currentLocation != null
                                      ? (calculateDistance(
                                      LatLng(currentLocation!.latitude, currentLocation!.longitude),
                                       LatLng(alarms[index].lat, alarms[index].lng))
                                      / 1000) // Divide by 1000 to convert meters to kilometers
                                      .toStringAsFixed(0) // Adjust the precision as needed
                                      : "3 km", // Default value if currentLocation is null
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),


                                Text(
                                  "km",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                             onPressed: () {  final alarmToDelete = alarms[
                             index]; // Store the alarm for later

                             // Show confirmation Snackbar
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text(
                                     'Are you sure you want to delete "${alarmToDelete.alarmName}"?'),
                                 action: SnackBarAction(
                                   label: 'Delete',
                                   onPressed: () {
                                     setState(() {
                                       alarms.removeAt(index);
                                     });
                                     saveData();
                                   },
                                 ),
                               ),
                             );
                             }, icon: Icon(Icons.delete),color: Theme.of(context).colorScheme.error,
                              ),

                          IconButton(
                            onPressed: () {  _showCustomBottomSheet(
                            context,
                            index,
                          );}, icon: Icon(Icons.edit),
                            color: Theme.of(context).colorScheme.secondary,
                          ),

                          // Switch(
                          //   value: alarms[index].isEnabled,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       alarms[index].isEnabled = value;
                          //       saveData();
                          //     });
                          //   },
                          // ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
         floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.plus),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>MyHomePage())
          );
        },
      ),
    );
  }
}
