
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitiled/Homescreens/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'Apiutils.dart';
import 'Homescreens/save alarm pages.dart';
import 'Track.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';


//
// final Uri _url = Uri.parse('https://flutter.dev');
class MyHomePage extends StatefulWidget {
  // final Function(String, String, double, bool) onSave;


  final String? title;

  const MyHomePage({super.key,  this.title, });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var latlong;
  double radius=0;
  updateradiusvalue(value){
    setState(() {
      radius=value;
    });

  }
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '';

  final Uri toLaunch =
  Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');



  TextEditingController controller = TextEditingController();
  GoogleMapController? mapController;
  location.LocationData? currentLocation;
  location.Location _locationService = location.Location();
  bool _isCameraMoving = true;

  final LatLng _defaultLocation = const LatLng(
      13.067439, 80.237617); // Default location

  TextEditingController searchController = TextEditingController();
  List<AlarmDetails> alarms = [];
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    alramnamecontroller.text="Welcome";



    loadData();

  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? alarmsJson = prefs.getStringList('alarms');

    if (alarmsJson != null) {
      alarms = alarmsJson.map((json) => AlarmDetails.fromJson(jsonDecode(json))).toList();
    } else {
      alarms = [];
    }

    setState(() {});
  }

  // Future<void> _launchInBrowser(Uri url) async {
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

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
    }

    log("location 1");
    _locationService.onLocationChanged.listen((
        location.LocationData newLocation) {
      log("location changed");
      if (_isCameraMoving) return;

      setState(() {
        if (newLocation.latitude != null && newLocation.longitude != null) {
          _current = LatLng(newLocation.latitude!, newLocation.longitude!);
        }
        currentLocation = newLocation;
        Marker? tap = _markers.length > 1 ? _markers.last : null;

        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId("_currentLocation"),
          icon: BitmapDescriptor.defaultMarker,
          position: currentLocation != null
              ? LatLng(
              currentLocation!.latitude!, currentLocation!.longitude!)
              : _defaultLocation,
        ));
        if(tap != null) {
          _markers.add(tap);
        }
      });

      if (mapController != null && _markers.length<2) {
        mapController!.animateCamera(CameraUpdate.newLatLng(
          LatLng(newLocation.latitude!, newLocation.longitude!),
        ));
      }
    });
    log("location 2");
  }


  Future<void> _moveToLocation(String locationName) async {
    List<geocoding.Location> locations = await geocoding.locationFromAddress(
        locationName);
    if (locations.isNotEmpty) {
      LatLng destination = LatLng(
          locations[0].latitude!, locations[0].longitude!);

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(destination));
      }
    }
  }
  Set<Marker> _markers={};

  LatLng? _current = const LatLng(
      13.067439, 80.237617);
  LatLng? _target = null;
  bool _handletap = false;


  TextEditingController notescontroller = TextEditingController();
  // Initialize the TextEditingController with the default value
  TextEditingController alramnamecontroller = TextEditingController(text: "Welcome");
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String _appBarTitle = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Future<void> _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   await launchUrl(launchUri);
  // }

  @override
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
                  MaterialPageRoute(builder: (context)=>Track())
                );
                // Handle item 1 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Set a alarm'),
              onTap: () {
                Navigator.of(context).pop();
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
          _appBarTitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(

            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              zoom: 15,
              target: _defaultLocation,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: _markers,
            onTap: _handleTap,


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
          Positioned(
            top: 50,
            left: 19,
            right: 16,
            child:
            Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ), child: placesAutoCompleteTextField(),),
            ),
            //   child: Center(
            //     child: Padding(
            //       padding: const EdgeInsets.only(left: 20.0),
            //       child: TypeAheadField(
            //         suggestionsCallback: (pattern) async {
            //           return await _fetchSuggestions(pattern);
            //         },
            //         itemBuilder: (context, suggestion) {
            //           return ListTile(
            //             title: Text(suggestion.description),
            //           );
            //         },
            //         onSelected: (suggestion) {
            //           searchController.text = suggestion.description;
            //           _moveToLocation(suggestion.description);
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 300.0, left: 100),
          //   child: Container(
          //       height: 100,
          //       width: 100,
          //       decoration: BoxDecoration(
          //         color:Colors.red[50],
          //         borderRadius: BorderRadius.circular(100),
          //         border: Border.all(color: Colors.red),
          //       ),
          //
          //       child: Icon(
          //         CupertinoIcons.location_solid, size: 40, color: Colors.red,)),
          // ),
          // Padding(
          //       padding: const EdgeInsets.only(top: 400.0),
          //       child: Material(
          //         elevation: 5,
          //         borderRadius: BorderRadius.circular(30),
          //         child: Container(
          //           height: 300,
          //           width: double.infinity,
          //
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             border: Border.all(color: Colors.black12),
          //             borderRadius: BorderRadius.circular(30),
          //           ),child: Column(
          //           children: [
          //             Row(
          //               children: [
          //                 Icon(CupertinoIcons.up_arrow,size: ,)
          //               ],
          //             )
          //           ],
          //         ),
          //         ),
          //       ),
          //     ),
          Padding(
            padding: const EdgeInsets.only(top:500.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _showCustomBottomSheet(context);
                },
                child: Text('Set the alarm'),
              ),

              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       _setDestination(
              //           37.7749, -122.4194); // Example: San Francisco, CA
              //     },
              //     child: Text('Set Destination'),
              //   ),
              // ),
            ),
          ),
        ],
      ),


    );
  }
  // void _showCustomBottomSheet(BuildContext context) {
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
  //             height: 300,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               color: Colors.transparent,
  //               border: Border.all(color: Colors.black12),
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //             child: Column(
  //               children: [
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: (){
  //
  //                           },
  //                             child: Icon(CupertinoIcons.up_arrow,size: 20,)),
  //                         Text("details"),
  //                       ],
  //                     ),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         GestureDetector(
  //                             onTap:(){
  //
  //           },
  //                     child: Icon(Icons.close,size: 20,)),
  //                         Text("cancel"),
  //                       ],
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // Add your button press logic here
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Color(0xffFFEF9A9A), // Set the background color here
  //                       ),
  //                       child: Text('Save'),
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // Add your button press logic here
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Color(0xffFFEF9A9A), // Set the background color here
  //                       ),
  //                       child: Text('Start'),
  //                     ),
  //
  //
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //
  //
  //                   ],
  //                 ),
  //                 // Add more widgets as needed
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showCustomBottomSheet(BuildContext context)async {
    if (!_handletap) {

      // Show a snackbar if a destination is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a destination on the map.'),
        ),
      );
      return;
    }
    loadData();
    alramnamecontroller.text=_appBarTitle;
    notescontroller.clear();
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
                              // Add your details logic here
                            },
                            child: Icon(CupertinoIcons.up_arrow, size: 20),
                          ),
                          Text("Details"),
                        ],
                      ),
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
                        onPressed: () {
                          saveAlarm(context); // Call the saveAlarm function
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFFEF9A9A),
                        ),
                        child: Text("Save"),
                      ),



                      ElevatedButton(
                        onPressed: () {
                          // Add your start logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFFEF9A9A),
                        ),
                        child: Text('Start'),
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
  void saveAlarm(BuildContext context) async {
    if (alramnamecontroller.text.isEmpty ||

        radius == null) {
      Navigator.of(context).pop();
      // Show a Snackbar prompting the user to fill in the required fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all the required fields.'),

        ),
      );
      return; // Exit the function without saving the data
    }


    setState(() {

      AlarmDetails newAlarm = AlarmDetails(
        alarmName: alramnamecontroller.text,
        notes: notescontroller.text,
        locationRadius: radius,
        isAlarmOn: true, isFavourite: false, lat: _target!.latitude, lng: _target!.longitude, id:Uuid().v4(),
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


  placesAutoCompleteTextField() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: "AIzaSyA3byIibe-X741Bw5rfEzOHZEKuWdHvCbw",
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          suffixIcon: Icon(Icons.search,size: 25,color: Colors.black26,),
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["in", "fr"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) async {

          print("placeDetails" + prediction.lat.toString());
          print("placeDetails - Lat: ${prediction.lat}, Lng: ${prediction.lng}");
          double lat = double.parse(prediction.lat!);
          double lng = double.parse(prediction.lng!);
          //
          // // Call _handleTap to add a marker at the selected location
          await _handleTap(LatLng(lat,lng ));


          if (mapController != null) {
            mapController!.animateCamera(CameraUpdate.newLatLng(
              LatLng(lat, lng),
            ));
          }
        },

        // itemClick: (Prediction prediction) async {
        //   print(prediction.lat);
        //   print(prediction.lng);
        //
        //  await _handleTap(LatLng(prediction.lat as double, prediction.lng as double));
        //   controller.text = prediction.description ?? "";
        //   controller.selection = TextSelection.fromPosition(
        //       TextPosition(offset: prediction.description?.length ?? 0));
        // },
        itemClick: (Prediction prediction) async {
          // Extract the latitude and longitude from the prediction

          print("enter");

          // Set the text field value to the prediction description
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },



        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,

        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }
  // _handleTap(LatLng point) {
  //   setState(() { _markers.
  //     _markers.add(Marker(
  //       markerId: MarkerId(point.toString()),
  //       position: point,
  //       infoWindow: InfoWindow(
  //         title: 'I am a marker',
  //       ),
  //       icon:
  //       BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor),
  //     ));
  //   });
  // }


//   void _setDestination(double latitude, double longitude) {
//     LatLng destination = LatLng(latitude, longitude);
//
//     if (mapController != null) {
//       mapController!.animateCamera(CameraUpdate.newLatLng(destination));
//     }
//   }
// }


//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:location/location.dart' as location;
// import 'package:geocoding/geocoding.dart' as geocoding;
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, this.title}) : super(key: key);
//
//   final String? title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController controller = TextEditingController();
//   GoogleMapController? mapController;
//   location.LocationData? currentLocation;
//   location.Location _locationService = location.Location();
//   bool _isCameraMoving = true;
//   final LatLng _defaultLocation = const LatLng(13.067439, 80.237617); // Default location
//   Set<Circle> _circles = {};
//   BitmapDescriptor? _destinationIcon;
//
//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     _loadCustomIcons();
//   }
//
//   Future<void> _requestLocationPermission() async {
//     bool serviceEnabled = await _locationService.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _locationService.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }
//
//     location.PermissionStatus permissionStatus = await _locationService.hasPermission();
//     if (permissionStatus == location.PermissionStatus.denied) {
//       permissionStatus = await _locationService.requestPermission();
//       if (permissionStatus != location.PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     _locationService.onLocationChanged.listen((location.LocationData newLocation) {
//       if (_isCameraMoving) return;
//
//       setState(() {
//         currentLocation = newLocation;
//       });
//
//       if (mapController != null) {
//         mapController!.animateCamera(CameraUpdate.newLatLng(
//           LatLng(newLocation.latitude!, newLocation.longitude!),
//         ));
//       }
//     });
//   }
//
//   Future<void> _loadCustomIcons() async {
//     _destinationIcon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(devicePixelRatio: 2.5),
//       'assets/custom_pin.png', // Replace with your image file
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.satellite,
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false,
//             initialCameraPosition: CameraPosition(
//               zoom: 15,
//               target: _defaultLocation,
//             ),
//             onMapCreated: (GoogleMapController controller) {
//               mapController = controller;
//             },
//             markers: {
//               Marker(
//                 markerId: MarkerId("_currentLocation"),
//                 icon: BitmapDescriptor.defaultMarker,
//                 position: currentLocation != null
//                     ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
//                     : _defaultLocation,
//               ),
//               Marker(
//                 markerId: MarkerId("_destination"),
//                 icon: _destinationIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//                 position: LatLng(0.0, 0.0), // Replace with the actual coordinates
//               ),
//             },
//             circles: _circles,
//             onCameraMoveStarted: () {
//               setState(() {
//                 _isCameraMoving = true;
//               });
//             },
//             onCameraIdle: () {
//               setState(() {
//                 _isCameraMoving = false;
//               });
//             },
//           ),
//           Positioned(
//             top: 200,
//             left: 19,
//             right: 16,
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(
//                   color: Colors.black,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: placesAutoCompleteTextField(),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: ElevatedButton(
//               onPressed: () {
//                 _setDestination(37.7749, -122.4194); // Example: San Francisco, CA
//               },
//               child: Text('Set Destination'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   placesAutoCompleteTextField() {
//     return Container(
//       child: GooglePlaceAutoCompleteTextField(
//         textEditingController: controller,
//         googleAPIKey: "AIzaSyA3byIibe-X741Bw5rfEzOHZEKuWdHvCbw",
//         inputDecoration: InputDecoration(
//           hintText: "Search your location",
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//         ),
//         debounceTime: 400,
//         countries: ["in", "fr"],
//         isLatLngRequired: true,
//         getPlaceDetailWithLatLng: (Prediction prediction) {
//           print("placeDetails" + prediction.lat.toString());
//         },
//         itemClick: (Prediction prediction) async {
//           double latitude = prediction.lat as double;
//           double longitude = prediction.lng as double;
//
//           setState(() {
//              // Clear existing circles
//             _circles.add(Circle(
//               circleId: CircleId("circle_1"),
//               center: LatLng(latitude, longitude),
//               radius: 500, // Radius in meters
//               fillColor: Colors.red.withOpacity(0.3),
//               strokeWidth: 10,
//             ));
//           });
//
//           controller.text = prediction.description ?? "";
//           controller.selection = TextSelection.fromPosition(
//               TextPosition(offset: prediction.description?.length ?? 0));
//         },
//         seperatedBuilder: Divider(),
//         containerHorizontalPadding: 10,
//         itemBuilder: (context, index, Prediction prediction) {
//           return Container(
//             padding: EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 Icon(Icons.location_on),
//                 SizedBox(
//                   width: 7,
//                 ),
//                 Expanded(child: Text("${prediction.description ?? ""}"))
//               ],
//             ),
//           );
//         },
//         isCrossBtnShown: true,
//       ),
//     );
//   }
//
//   void _setDestination(double latitude, double longitude) {
//     LatLng destination = LatLng(latitude, longitude);
//
//     if (mapController != null) {
//       mapController!.animateCamera(CameraUpdate.newLatLng(destination));
//     }
//   }
// }
  _handleTap(LatLng point) async {

    _handletap=true;
    ByteData byteData = await rootBundle.load('assets/locationimage.png');
    Uint8List imageData = byteData.buffer.asUint8List();

    // Create a BitmapDescriptor from the image data
    BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(imageData);
    setState(() {
      _target=point;
      Marker? tap = _markers.isNotEmpty ? _markers.first : null;

      _markers.clear();
      if(tap != null) {
        _markers.add(tap);
      }
      // Convert the set to a list
      List<Marker> markerList = _markers.toList();

      // Load the custom icon image


      // Add a new marker with the custom icon
      markerList.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: _appBarTitle,
        ),
        icon: customIcon,
      ));

      // Convert the list back to a set
      _markers = markerList.toSet();
    });

    // Perform reverse geocoding to get the address from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);

    // Extract the location name from the placemark
    String name = placemarks.isEmpty ? 'Default' : [
      placemarks[0].name,
      placemarks[0].subLocality,
      placemarks[0].locality,
    ].toList()
        .where((element) => element != null && element != '')
        .join(', ');
    String locationName = name;

    // Update the app bar title with the location name
    setState(() {
      _appBarTitle = locationName;
    });
  }


}











// class MeterCalculatorWidget extends StatefulWidget {
//   final Function(double) callback;
//
//   const MeterCalculatorWidget({super.key, required this.callback});
//
//
//
//   @override
//   _MeterCalculatorWidgetState createState() => _MeterCalculatorWidgetState();
// }
//
// class _MeterCalculatorWidgetState extends State<MeterCalculatorWidget> {
//   double _radius = 200;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Text(
//             'Radius',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SliderTheme(
//                 data: SliderTheme.of(context).copyWith(
//                   thumbShape: RoundSliderThumbShape(
//                     enabledThumbRadius: 15.0, // Set your desired thumb radius
//                   ),
//                 ),
//                 child: Slider(
//                   activeColor: Colors.red,
//
//                   value: _radius,
//                   divisions: 20,
//                   min: 20,
//                   max: 1000, // Set your maximum radius value here
//                   onChanged: (value) {
//                     setState(() {
//                       _radius = value.roundToDouble(); // Round the value to the nearest integer
//                     });
//                     widget.callback(value);
//                   },
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Text(' ${_radius.round()} meters'), // Display the rounded value
//         ],
//       ),
//
//     );
//   }
// }
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





