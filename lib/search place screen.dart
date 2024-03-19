// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
//
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   late GoogleMapController googleMapController;
//   static const CameraPosition initialCameraposition=CameraPosition(target: LatLng(13.067439, 13.067439),zoom: 15);
//   Set<Marker> markersList={};
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition:initialCameraposition,mapType: MapType.normal,onMapCreated:(GoogleMapController controller){
//             googleMapController=controller;
//           },
//           ),
//           ElevatedButton(onPressed: _handlePressButton, child: Text("Search Places"))
//         ],
//
//       ),
//     );
//   }
//   Future <void> _handlePressButton()async{
//     Prediction? p=PlacesAutocompleteResponse(status: status, predictions: predictions) as Prediction?
//   }
// }




import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmDetails {
  final String alarmName;
  final double lat;
  final double lng;
  final double locationRadius;

  AlarmDetails({
    required this.alarmName,
    required this.lat,
    required this.lng,
    required this.locationRadius,
  });

// You can implement toJson and fromJson methods as needed for serialization
}

class Track extends StatefulWidget {
  final AlarmDetails? alarm;

  const Track({Key? key, this.alarm}) : super(key: key);

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {
  TextEditingController controller = TextEditingController();
  GoogleMapController? mapController;
  location.LocationData? currentLocation;
  location.Location _locationService = location.Location();
  bool _isCameraMoving = true;
  final LatLng _defaultLocation = const LatLng(13.067439, 80.237617); // Default location

  List<AlarmDetails> alarms = [];
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();

    loadData();
    markLocation();
    checkAlarm(); // Check for alarm when the screen initializes
  }

  Future markLocation() async {
    // Your markLocation function implementation
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

  Future<void> _requestLocationPermission() async {
    // Your _requestLocationPermission function implementation
  }

  void checkAlarm() {
    // Check if current location is within any alarm radius
    if (currentLocation != null) {
      for (var alarm in alarms) {
        double distance = calculateDistance(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          LatLng(alarm.lat, alarm.lng),
        );

        if (distance <= alarm.locationRadius) {
          // Alarm is triggered
          _triggerAlarm(alarm);
          break; // Exit loop after triggering the first alarm
        }
      }
    }
  }

  double degreesToRadians(double degrees) {
    // Your degreesToRadians function implementation
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    // Your calculateDistance function implementation
  }

  void _triggerAlarm(AlarmDetails alarm) {
    // Implement your alarm logic here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alarm'),
        content: Text('You have reached your destination for ${alarm.alarmName}!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            circles: _circles,
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              zoom: 20,
              target: _defaultLocation,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
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
          Padding(
            padding: const EdgeInsets.only(left: 280.0, top: 500),
            child: FloatingActionButton(
              onPressed: () {
                mapController?.animateCamera(
                  CameraUpdate.zoomIn(),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 280.0, top: 600),
            child: FloatingActionButton(
              onPressed: () {
                mapController?.animateCamera(
                  CameraUpdate.zoomOut(),
                );
              },
              child: Icon(Icons.remove),
            ),
          ),
        ],
      ),
    );
  }
}
