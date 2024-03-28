import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitiled/Track.dart';
import 'package:location/location.dart' as location;

import '../Apiutils.dart';
import '../Map screen page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import '../main.dart';

// class MyAlarmsPage extends StatefulWidget {
//   final String alarmName;
//   final String notes;
//   final double locationRadius;
//   final bool isAlarmOn;
//
//   MyAlarmsPage({
//     required this.alarmName,
//     required this.notes,
//     required this.locationRadius,
//     required this.isAlarmOn,
//   });
//
//   @override
//   _MyAlarmsPageState createState() => _MyAlarmsPageState();
// }
// class AlarmDetails {
//   final String alarmName;
//   final String notes;
//   final double locationRadius;
//   final bool isAlarmOn;
//
//   AlarmDetails({
//     required this.alarmName,
//     required this.notes,
//     required this.locationRadius,
//     required this.isAlarmOn,
//   });
// }
// class _MyAlarmsPageState extends State<MyAlarmsPage> {
//   List<AlarmDetails> alarms = [];
//
//   @override
//   @override
//   void initState() {
//     super.initState();
//     alarms.add(widget.alarmDetails);
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Alarms'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 300),
//         child: ListView.builder(
//           itemCount: alarms.length,
//           itemBuilder: (context, index) {
//             return Material(
//               elevation: 3,
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 height: 150,
//                 width: 300,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.black12),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Alarm Name: ${widget.alarms[index].alarmName}'),
//                     SizedBox(height: 10),
//                     Text('Notes: ${widget.alarms[index].notes}'),
//                     SizedBox(height: 10),
//                     Text('Location Radius: ${widget.alarms[index].locationRadius} meters'),
//                     SizedBox(height: 10),
//                     Text('Is Alarm On: ${widget.alarms[index].isAlarmOn ? 'On' : 'Off'}'),
//                     SizedBox(height: 20),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           alarms.removeAt(index);
//                         });
//                       },
//                       child: Icon(Icons.delete),
//                     ),
//
//                     // Add more details as needed
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


// class _MyAlarmsPageState extends State<MyAlarmsPage> {
//   List<AlarmDetails> alarms = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Alarms'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 300),
//         child: ListView.builder(
//           itemCount: 10,
//           itemBuilder: (context, index) {
//             return
//             Material(
//                 elevation: 3,
//                 borderRadius: BorderRadius.circular(10),
//                 child: Container(
//                   height:150,
//                   width: 300,
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.black12),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Alarm Name: ${widget.alarmName}'),
//                       SizedBox(height: 10),
//                       Text('Notes: ${widget.notes}'),
//                       SizedBox(height: 10),
//                       Text('Location Radius: ${widget.locationRadius} meters'),
//                       SizedBox(height: 10),
//                       Text('Is Alarm On: ${widget.isAlarmOn ? 'On' : 'Off'}'),
//                       SizedBox(height: 20),
//                       // Add more details as needed
//                     ],
//                   ),
//                 ),
//             );
//
//           },
//         ),
//       ),
//
//     );
//   }
// }
// Padding(
//   padding: const EdgeInsets.all(30.0),
//   child: Material(
//     elevation: 3,
//     borderRadius: BorderRadius.circular(10),
//     child: Container(
//       height:150,
//       width: 300,
//
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.black12),
//         borderRadius: BorderRadius.circular(10),
//       ),
//
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Alarm Name: ${widget.alarmName}'),
//           SizedBox(height: 10),
//           Text('Notes: ${widget.notes}'),
//           SizedBox(height: 10),
//           Text('Location Radius: ${widget.locationRadius} meters'),
//           SizedBox(height: 10),
//           Text('Is Alarm On: ${widget.isAlarmOn ? 'On' : 'Off'}'),
//           SizedBox(height: 20),
//           // Add more details as needed
//         ],
//       ),
//     ),
//   ),
// ),
class MyAlarmsPage extends StatefulWidget {


  const MyAlarmsPage({super.key, });

  @override
  _MyAlarmsPageState createState() => _MyAlarmsPageState();
}

class _MyAlarmsPageState extends State<MyAlarmsPage> {
  LatLng? currentLocation;
  Set<Marker> _markers={};
  location.Location _locationService = location.Location();
  double radius=0;
  updateradiusvalue(value){
    setState(() {
      radius=value;
    });
  }
  bool isFavorite = false;
  bool _enabled = false;
  final _controller= ValueNotifier<bool>(false);
  List<AlarmDetails> alarms = [];
  void _showCustomBottomSheet(BuildContext context, int index) async {
    TextEditingController alramnamecontroller = TextEditingController(text: alarms[index].alarmName);
    TextEditingController notescontroller = TextEditingController(text: alarms[index].notes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(); // Close the bottom sheet on cancel
                            },
                            child: Icon(Icons.close, size: 20),
                          ),
                          Text("Cancel"),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       alarms.add(AlarmDetails(
                      //         alarmName: alramnamecontroller.text,
                      //         notes: notescontroller.text,
                      //         locationRadius: radius,
                      //         isAlarmOn: true,
                      //       ));
                      //     });
                      //
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(builder: (context)=> MyAlarmsPage(alarmName: alramnamecontroller.text, notes: notescontroller.text, locationRadius: radius, isAlarmOn:true,))
                      //     );
                      //     // Add your save logic here
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Color(0xffFFEF9A9A),
                      //   ),
                      //   child: Text('Save'),
                      // ),
                      ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFFEF9A9A),
                        ),
                        child: Text("Save"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Integrate the MeterCalculatorWidget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Column(
                        children: [
                          MeterCalculatorWidget(callback: updateradiusvalue),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alarm Name:",style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18
                      ),),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),

                        ),child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: alramnamecontroller,

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: "Alarm name",
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      ),
                      SizedBox(height: 20),

                      Text("Notes:",style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18
                      ),),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),

                        ),child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: notescontroller,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: "Notes",
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );


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

    return distance/1000;
  }
  @override
  void initState() {
    super.initState();
    loadData();

    // calculateDistance(LatLng(currentLocation!.latitude,currentLocation!.longitude ),LatLng(alarms[index].lat, alarms[index].lng)).toStringAsFixed(2);

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
      alarms = alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json))).toList();
    }
    double? storedLatitude = prefs.getDouble('current_latitude');
    double? storedLongitude = prefs.getDouble('current_longitude');


    setState(() {
      if (storedLatitude != null && storedLongitude != null) {
        currentLocation=LatLng(storedLatitude,storedLongitude);
        print('Stored location: ($storedLatitude, $storedLongitude)');
        // Marker? tap = _markers.length > 1 ? _markers.last : null;
      }
    });
  }
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> alarmsJson = alarms.map((alarm) => alarm.toJson()).toList();

    prefs.setStringList('alarms', alarmsJson.map((json) => jsonEncode(json)).toList());

  }
  Future<void>? _launched;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFEF9A9A),
        title: Text('My Alarms'),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all( 16.0),
            child:Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>Track(
                        alarm:alarms[index],
                      ))
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${alarms[index].alarmName}",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis, // Add this line
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Icon(Icons.location_on,size: 30,color: Colors.orange,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(),

                            child: Text(
                            currentLocation != null ?  calculateDistance(LatLng(currentLocation!.latitude,currentLocation!.longitude ),LatLng(alarms[index].lat, alarms[index].lng)).toStringAsFixed(0):"3km" ,

                              style: TextStyle(
                                fontSize: 18,color: Colors.green,fontWeight: FontWeight.w500,

                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),

                            child: Text(
                             "km",

                              style: TextStyle(
                                fontSize: 18,color: Colors.green,fontWeight: FontWeight.w500,

                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("${alarms[index].notes}",style: TextStyle(
                        fontSize: 18,color: Colors.black54,fontWeight: FontWeight.w500,

                      ),),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final alarmToDelete = alarms[index]; // Store the alarm for later

                                  // Show confirmation Snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Are you sure you want to delete "${alarmToDelete.alarmName}"?'),
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
                                },
                                child: Icon(Icons.delete, size: 28, color: Colors.black),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Delete",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                  onTap:(){
                                     _showCustomBottomSheet(context,index,);
                                  },
                                  child: Icon(Icons.edit,size: 28,color: Colors.black,)),
                              SizedBox(
                                height: 15,
                              ),
                              Text("edit",style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black45,
                              ),),
                            ],
                          ),
                          // Column(
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //
                          //         bool newFavoriteStatus = !alarms[index].isFavourite;
                          //         updateFavoriteStatus(index, newFavoriteStatus);
                          //       },
                          //       child:
                          //       Icon(
                          //         alarms[index].isFavourite ? Icons.favorite : Icons.favorite_outline,
                          //         size: 26,
                          //         color: alarms[index].isFavourite ? Colors.red : Colors.black,
                          //       ),),
                          //     SizedBox(
                          //       height: 15,
                          //     ),
                          //     Text("favourite",style: TextStyle(
                          //       fontWeight: FontWeight.w500,
                          //       fontSize: 15,
                          //       color: Colors.black45,
                          //     ),),
                          //   ],
                          // ),
                          // Column(
                          //   children: [
                          //
                          //
                          //     // Icon(Icons.pin_drop,size: 26,color: Colors.black,),
                          //     Image.asset("assets/pin drop.png",height: 30,width: 30,),
                          //     SizedBox(
                          //       height: 15,
                          //     ),
                          //     Text("Pin",style: TextStyle(
                          //       fontWeight: FontWeight.w500,
                          //       fontSize: 15,
                          //       color: Colors.black45,
                          //     ),),
                          //   ],
                          // ),
                          Switch(
                            value: alarms[index].isEnabled,
                            onChanged: (value) {
                              setState(() {
                                alarms[index].isEnabled = value;
                                // _controller.value = alarms.where((alarm) => alarm.isEnabled).isNotEmpty;
                                saveData();
                              });
                            },
                          ),
                          // AdvancedSwitch(
                          //   width: 32,
                          //   height: 16,
                          //   controller: ValueNotifier<bool>(false),
                          // ),
                          // Column(
                          //   children: [
                          //
                          //
                          //
                          //      Icon(Icons.swi,size: 26,color: Colors.black,),
                          //
                          //     SizedBox(
                          //       height: 15,
                          //     ),
                          //     Text("Pin",style: TextStyle(
                          //       fontWeight: FontWeight.w500,
                          //       fontSize: 15,
                          //       color: Colors.black45,
                          //     ),),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
