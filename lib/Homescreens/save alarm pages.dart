import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitiled/Track.dart';

import '../Apiutils.dart';
import '../Map screen page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

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


  @override
  _MyAlarmsPageState createState() => _MyAlarmsPageState();
}

class _MyAlarmsPageState extends State<MyAlarmsPage> {
  bool isFavorite = false;

  bool _enabled = false;
  final _controller= ValueNotifier<bool>(false);
  List<AlarmDetails> alarms = [];

  @override
  void initState() {
    super.initState();
    loadData();

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

    setState(() {});
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> alarmsJson = alarms.map((alarm) => alarm.toJson()).toList();

    prefs.setStringList('alarms', alarmsJson.map((json) => jsonEncode(json)).toList());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Alarms'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(),
        child: ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Material(
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
                    height: 180,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${alarms[index].alarmName}",style: TextStyle(
                                fontSize: 20,color: Colors.black,fontWeight: FontWeight.w500,
                  
                              ),),
                              Padding(
                                padding: const EdgeInsets.only(left: 190.0),
                                child: Icon(Icons.location_on,size: 30,color: Colors.orange,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right
                                    : 30.0),
                                child: Text("3km",style: TextStyle(
                                                  fontSize: 18,color: Colors.black,fontWeight: FontWeight.w500,
                  
                                                ),),
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
                                    onTap: (){
                  
                                setState(() {
                  alarms.removeAt(index);
                                });
                                saveData();
                          },
                  
                  
                                      child: Icon(Icons.delete,size: 28,color: Colors.black,)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("Delete",style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black45,
                                  ),),
                                ],
                              ),
                              Column(
                                children: [
                  
                  
                  
                                      Icon(Icons.edit,size: 28,color: Colors.black,),
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
                              Column(
                                children: [
                  
                  
                  
                                  GestureDetector(
                                      onTap: () {
                  
                                        bool newFavoriteStatus = !alarms[index].isFavourite;
                                        updateFavoriteStatus(index, newFavoriteStatus);
                                      },
                                      child:
                                      Icon(
                                        alarms[index].isFavourite ? Icons.favorite : Icons.favorite_outline,
                                        size: 26,
                                        color: alarms[index].isFavourite ? Colors.red : Colors.black,
                                      ),),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("favourite",style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black45,
                                  ),),
                                ],
                              ),
                              Column(
                                children: [
                  
                  
                  
                                  // Icon(Icons.pin_drop,size: 26,color: Colors.black,),
                                  Image.asset("assets/pin drop.png",height: 30,width: 30,),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("Pin",style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black45,
                                  ),),
                                ],
                              ),
                              AdvancedSwitch(
                                width: 32,
                                height: 16,
                                controller: ValueNotifier<bool>(false),
                              ),
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
                      )
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     SizedBox(height: 10),
                      //     Text('Alarm Name: ${alarms[index].alarmName}'),
                      //     SizedBox(height: 10),
                      //     Text('Notes: ${alarms[index].notes}'),
                      //     SizedBox(height: 10),
                      //     Text('Location Radius: ${alarms[index].locationRadius} meters'),
                      //     SizedBox(height: 10),
                      //     Text('Is Alarm On: ${alarms[index].isAlarmOn ? 'On' : 'Off'}'),
                      //     SizedBox(height: 20),
                      //     GestureDetector( onTap: () {
                      //                   //         setState(() {
                      //                   //           alarms.removeAt(index);
                      //                   //         });
                      //                   //         saveData();
                      //                   //       },
                      //
                      //       child: Icon(Icons.delete),
                      //     ),
                      //     // Add more details as needed
                      //   ],
                      // ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
