// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// //
// // class Firstpage extends StatefulWidget {
// //   const Firstpage({super.key});
// //
// //   @override
// //   State<Firstpage> createState() => _FirstpageState();
// // }
// //
// // class _FirstpageState extends State<Firstpage> {
// //   late GoogleMapController googleMapController;
// //   // static const _initialCameraPosition= CameraPosition(
// //   //     static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
// //   //   target:
// //   // )
// //   //
// //
// //   // static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
// //   // static const _initialCameraPosition=CameraPosition(
// //   //   target:LatLng(37.4223, -122.0848),
// //   //   zoom: 15,
// //   // );
// //   static const LatLng _pGooglePlex=LatLng(37.8998,-122.0848);
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: GoogleMap(
// //         myLocationButtonEnabled: false,
// //           zoomControlsEnabled: false,mapType: MapType.normal,
// //           onMapCreated: (GoogleMapController controller){
// //           googleMapController=controller;
// //           },
// //           initialCameraPosition: CameraPosition(
// //             zoom: 15,
// //             target: _pGooglePlex,
// //           ),
// //         markers: {
// //           Marker(
// //               markerId: MarkerId("_currentLocation"),
// //               icon: BitmapDescriptor.defaultMarker,
// //               position: _pGooglePlex)
// //         }
// //         ),
// //           );
// //
// //
// //
// //
// //
// //
// //   }
// // }
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart';
// //
// // class MapScreen extends StatefulWidget {
// //   @override
// //   _MapScreenState createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> {
// //   GoogleMapController? mapController;
// //   LocationData? currentLocation;
// //   Location location = Location();
// //
// //   final LatLng _defaultLocation = const LatLng(37.7749, -122.4194); // Default location
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _requestLocationPermission();
// //   }
// //
// //   Future<void> _requestLocationPermission() async {
// //     bool serviceEnabled = await location.serviceEnabled();
// //     if (!serviceEnabled) {
// //       serviceEnabled = await location.requestService();
// //       if (!serviceEnabled) {
// //         return;
// //       }
// //     }
// //
// //     PermissionStatus permissionStatus = await location.hasPermission();
// //     if (permissionStatus == PermissionStatus.denied) {
// //       permissionStatus = await location.requestPermission();
// //       if (permissionStatus != PermissionStatus.granted) {
// //         return;
// //       }
// //     }
// //
// //     updateLocation();
// //   }
// //
// //   Future<void> updateLocation() async {
// //     try {
// //       LocationData currentLocationResult = await location.getLocation();
// //       if (mounted) {
// //         setState(() {
// //           currentLocation = currentLocationResult;
// //         });
// //       }
// //     } catch (e) {
// //       print("Error: $e");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: GoogleMap(
// //         myLocationButtonEnabled: false,
// //         zoomControlsEnabled: false,
// //         initialCameraPosition: CameraPosition(
// //           zoom: 15,
// //           target: currentLocation != null
// //               ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
// //               : _defaultLocation,
// //         ),
// //         onMapCreated: (GoogleMapController controller) {
// //           mapController = controller;
// //         },
// //         markers: {
// //           Marker(
// //             markerId: MarkerId("_currentLocation"),
// //             icon: BitmapDescriptor.defaultMarker,
// //             position: currentLocation != null
// //                 ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
// //                 : _defaultLocation,
// //           )
// //         },
// //       ),
// //     );
// //   }
// // }
//
// // Import necessary packages at the beginning of your file
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart' as location;
// // import 'package:geocoding/geocoding.dart' as geocoding;
// //
// // class MapScreen extends StatefulWidget {
// //   @override
// //   _MapScreenState createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> {
// //   GoogleMapController? mapController;
// //   location.LocationData? currentLocation;
// //   location.Location _locationService = location.Location();
// //   bool _isCameraMoving = false;
// //
// //   final LatLng _defaultLocation = const LatLng(13.067439, 80.237617); // Default location
// //
// //   TextEditingController searchController = TextEditingController();
// //   List<geocoding.Location> searchResults = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _requestLocationPermission();
// //   }
// //
// //   Future<void> _requestLocationPermission() async {
// //     bool serviceEnabled = await _locationService.serviceEnabled();
// //     if (!serviceEnabled) {
// //       serviceEnabled = await _locationService.requestService();
// //       if (!serviceEnabled) {
// //         // Handle the case where the user doesn't enable location services
// //         // You can show a dialog or a message to inform the user
// //         return;
// //       }
// //     }
// //
// //     location.PermissionStatus permissionStatus = await _locationService.hasPermission();
// //     if (permissionStatus == location.PermissionStatus.denied) {
// //       permissionStatus = await _locationService.requestPermission();
// //       if (permissionStatus != location.PermissionStatus.granted) {
// //         // Handle the case where the user denies location permission
// //         // You can show a dialog or a message to inform the user
// //         return;
// //       }
// //     }
// //
// //     // Start listening for location updates
// //     _locationService.onLocationChanged.listen((location.LocationData newLocation) {
// //       if (_isCameraMoving) return;
// //
// //       setState(() {
// //         currentLocation = newLocation;
// //       });
// //
// //       if (mapController != null) {
// //         mapController!.animateCamera(CameraUpdate.newLatLng(
// //           LatLng(newLocation.latitude!, newLocation.longitude!),
// //         ));
// //       }
// //     });
// //   }
// //
// //   Future<void> _moveToLocation(String locationName) async {
// //     List<geocoding.Location> locations = await geocoding.locationFromAddress(locationName);
// //     if (locations.isNotEmpty) {
// //       LatLng destination = LatLng(locations[0].latitude!, locations[0].longitude!);
// //
// //       if (mapController != null) {
// //         mapController!.animateCamera(CameraUpdate.newLatLng(destination));
// //       }
// //     }
// //   }
// //
// //   void _setDestination(double latitude, double longitude) {
// //     LatLng destination = LatLng(latitude, longitude);
// //
// //     if (mapController != null) {
// //       mapController!.animateCamera(CameraUpdate.newLatLng(destination));
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Column(
// //         children: [
// //           // Search Bar with Autocomplete
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Autocomplete<geocoding.Location>(
// //               optionsBuilder: (TextEditingValue textEditingValue) {
// //                 return searchResults;
// //               },
// //               onSelected: (geocoding.Location location) {
// //                 _moveToLocation(location.formattedAddress!);
// //                 searchController.text = location.formattedAddress!;
// //               },
// //               fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
// //                   FocusNode focusNode, VoidCallback onFieldSubmitted) {
// //                 return TextField(
// //                   controller: searchController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Search Location',
// //                     suffixIcon: IconButton(
// //                       icon: Icon(Icons.search),
// //                       onPressed: () {
// //                         _moveToLocation(searchController.text);
// //                       },
// //                     ),
// //                   ),
// //                   onChanged: (String value) async {
// //                     List<geocoding.Location> results =
// //                     await geocoding.locationFromAddress(value);
// //                     setState(() {
// //                       searchResults = results;
// //                     });
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //           // Map
// //           Expanded(
// //             child: GoogleMap(
// //               myLocationButtonEnabled: false,
// //               zoomControlsEnabled: false,
// //               initialCameraPosition: CameraPosition(
// //                 zoom: 15,
// //                 target: _defaultLocation,
// //               ),
// //               onMapCreated: (GoogleMapController controller) {
// //                 mapController = controller;
// //               },
// //               markers: {
// //                 Marker(
// //                   markerId: MarkerId("_currentLocation"),
// //                   icon: BitmapDescriptor.defaultMarker,
// //                   position: currentLocation != null
// //                       ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
// //                       : _defaultLocation,
// //                 ),
// //               },
// //               onCameraMoveStarted: () {
// //                 setState(() {
// //                   _isCameraMoving = true;
// //                 });
// //               },
// //               onCameraIdle: () {
// //                 setState(() {
// //                   _isCameraMoving = false;
// //                 });
// //               },
// //             ),
// //           ),
// //           // Button to set a destination
// //           ElevatedButton(
// //             onPressed: () {
// //               if (searchResults.isNotEmpty) {
// //                 _setDestination(
// //                   searchResults[0].latitude!,
// //                   searchResults[0].longitude!,
// //                 );
// //               } else {
// //                 // Default destination (San Francisco, CA)
// //                 _setDestination(37.7749, -122.4194);
// //               }
// //             },
// //             child: Text('Set Destination'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
//
//
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import 'package:geocoding/geocoding.dart' as geocoding;
// import 'package:google_maps_webservice/directions.dart';
// import 'package:google_maps_webservice/directions.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
//
// import 'package:location/location.dart' as location;
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import 'package:geocoding/geocoding.dart' as geocoding;
//  import 'package:location/location.dart' as location;
// // import 'package:google_places_flutter/google_places_flutter.dart' as places;
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   TextEditingController controller = TextEditingController();
//   GoogleMapController? mapController;
//   location.LocationData? currentLocation;
//   location.Location _locationService = location.Location();
//   bool _isCameraMoving = true;
//
//   final LatLng _defaultLocation = const LatLng(
//       13.067439, 80.237617); // Default location
//
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
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
//     location.PermissionStatus permissionStatus = await _locationService
//         .hasPermission();
//     if (permissionStatus == location.PermissionStatus.denied) {
//       permissionStatus = await _locationService.requestPermission();
//       if (permissionStatus != location.PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     _locationService.onLocationChanged.listen((
//         location.LocationData newLocation) {
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
//   Future<void> _moveToLocation(String locationName) async {
//     List<geocoding.Location> locations = await geocoding.locationFromAddress(
//         locationName);
//     if (locations.isNotEmpty) {
//       LatLng destination = LatLng(
//           locations[0].latitude!, locations[0].longitude!);
//
//       if (mapController != null) {
//         mapController!.animateCamera(CameraUpdate.newLatLng(destination));
//       }
//     }
//   }
//
//   void _setDestination(double latitude, double longitude) {
//     LatLng destination = LatLng(latitude, longitude);
//
//     if (mapController != null) {
//       mapController!.animateCamera(CameraUpdate.newLatLng(destination));
//     }
//   }
//
//   // Future<List<Suggestion>> _fetchSuggestions(String query) async {
//   //   final response = await PlacesAutocomplete.show(
//   //     context: context,
//   //     apiKey: "AIzaSyA3byIibe-X741Bw5rfEzOHZEKuWdHvCbw",
//   //     language: "en",
//   //     components: [Component(Component.country, "en")],
//   //   );
//   //
//   //   if (response != null && response.matchedSubstrings.isNotEmpty) {
//   //     List<Suggestion> suggestions = response.matchedSubstrings
//   //         .map((MatchedSubstring prediction) =>
//   //         Suggestion(description: prediction.toString()))
//   //         .toList();
//   //
//   //     return suggestions;
//   //   } else {
//   //     return [];
//   //   }
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
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
//                     ? LatLng(
//                     currentLocation!.latitude!, currentLocation!.longitude!)
//                     : _defaultLocation,
//               ),
//               Marker(
//                 markerId: MarkerId("_destination"),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(
//                     BitmapDescriptor.hueBlue),
//                 position: LatLng(0.0, 0.0),
//               ),
//             },
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
//             left: 16,
//             right: 16,
//             child: placesAutoCompleteTextField(),
//             // Container(
//             //   height: 50,
//             //   decoration: BoxDecoration(
//             //     color: Colors.white,
//             //     border: Border.all(
//             //       color: Colors.black,
//             //     ),
//             //     borderRadius: BorderRadius.circular(10),
//             //   ),
//             //   child: Center(
//             //     child: Padding(
//             //       padding: const EdgeInsets.only(left: 20.0),
//             //       child: TypeAheadField(
//             //         suggestionsCallback: (pattern) async {
//             //           return await _fetchSuggestions(pattern);
//             //         },
//             //         itemBuilder: (context, suggestion) {
//             //           return ListTile(
//             //             title: Text(suggestion.description),
//             //           );
//             //         },
//             //         onSelected: (suggestion) {
//             //           searchController.text = suggestion.description;
//             //           _moveToLocation(suggestion.description);
//             //         },
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: ElevatedButton(
//               onPressed: () {
//                 _setDestination(
//                     37.7749, -122.4194); // Example: San Francisco, CA
//               },
//               child: Text('Set Destination'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   placesAutoCompleteTextField() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20),
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
//
//         itemClick: (Prediction prediction) {
//           controller.text = prediction.description ?? "";
//           controller.selection = TextSelection.fromPosition(
//               TextPosition(offset: prediction.description?.length ?? 0));
//         },
//         seperatedBuilder: Divider(),
//         containerHorizontalPadding: 10,
//
//         // OPTIONAL// If you want to customize list view item builder
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
//
//         isCrossBtnShown: true,
//
//         // default 600 ms ,
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:google_maps_webservice/places.dart' as places;
// // import 'package:location/location.dart';
// //
// // class MapScreen extends StatefulWidget {
// //   @override
// //   _MapScreenState createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> {
// //   GoogleMapController? mapController;
// //   LocationData? currentLocation;
// //   Location location = Location();
// //   bool _isCameraMoving = false;
// //   TextEditingController _searchController = TextEditingController();
// //   places.PlacesSearchResponse? _placesSearchResponse;
// //
// //   final LatLng _defaultLocation = const LatLng(37.7749, -122.4194); // Default location
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _requestLocationPermission();
// //   }
// //
// //   Future<void> _requestLocationPermission() async {
// //     bool serviceEnabled = await location.serviceEnabled();
// //     if (!serviceEnabled) {
// //       serviceEnabled = await location.requestService();
// //       if (!serviceEnabled) {
// //         return;
// //       }
// //     }
// //
// //     PermissionStatus permissionStatus = await location.hasPermission();
// //     if (permissionStatus == PermissionStatus.denied) {
// //       permissionStatus = await location.requestPermission();
// //       if (permissionStatus != PermissionStatus.granted) {
// //         return;
// //       }
// //     }
// //
// //     _getCurrentLocation();
// //   }
// //
// //   Future<void> _getCurrentLocation() async {
// //     try {
// //       LocationData currentLocationResult = await location.getLocation();
// //       if (mounted) {
// //         setState(() {
// //           currentLocation = currentLocationResult;
// //         });
// //       }
// //     } catch (e) {
// //       print("Error: $e");
// //     }
// //   }
// //
// //   Future<void> _performSearch(String input) async {
// //     final places.PlacesSearchResponse response = await places.GoogleMapsPlaces(apiKey: 'YOUR_GOOGLE_MAPS_API_KEY').searchByText(
// //       input,
// //       language: "en",
// //       type: "address",
// //     );
// //
// //     setState(() {
// //       _placesSearchResponse = response;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: TextField(
// //           controller: _searchController,
// //           decoration: InputDecoration(
// //             hintText: 'Search for a place...',
// //           ),
// //           onChanged: (value) {
// //             _performSearch(value);
// //           },
// //         ),
// //       ),
// //       body: Column(
// //
// //         children: [
// //           if (_placesSearchResponse != null)
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: _placesSearchResponse!.results.length,
// //                 itemBuilder: (context, index) {
// //                   return ListTile(
// //                     title: Text(_placesSearchResponse!.results[index].formattedAddress ?? ""),
// //                     onTap: () {
// //                       // Handle selection of a place
// //                       // You may want to navigate to a new screen or update the map marker
// //                       // with the selected place's coordinates
// //                       print(_placesSearchResponse!.results[index].formattedAddress);
// //                     },
// //                   );
// //                 },
// //               ),
// //             ),
// //           Expanded(
// //             flex: 3,
// //             child: GoogleMap(
// //               myLocationButtonEnabled: false,
// //               zoomControlsEnabled: false,
// //               initialCameraPosition: CameraPosition(
// //                 zoom: 15,
// //                 target: currentLocation != null
// //                     ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
// //                     : _defaultLocation,
// //               ),
// //               onMapCreated: (GoogleMapController controller) {
// //                 mapController = controller;
// //               },
// //               markers: {
// //                 Marker(
// //                   markerId: MarkerId("_currentLocation"),
// //                   icon: BitmapDescriptor.defaultMarker,
// //                   position: currentLocation != null
// //                       ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
// //                       : _defaultLocation,
// //                 )
// //               },
// //               onCameraMoveStarted: () {
// //                 _isCameraMoving = true;
// //               },
// //               onCameraIdle: () {
// //                 _isCameraMoving = false;
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // Column(
// // children: [
// // // Search Bar
// // Padding(
// // padding: const EdgeInsets.all(8.0),
// // child: Container(
// // height:50,
// // width: 300,
// // decoration: BoxDecoration(
// // color: Colors.white,
// // border: Border.all(
// // color: Colors.black,
// // ),
// // borderRadius: BorderRadius.circular(10)
// // ),
// //
// // child: TextField(
// // controller: searchController,
// // decoration: InputDecoration(
// // labelText: 'Search Location',
// // suffixIcon: IconButton(
// // icon: Icon(Icons.search),
// // onPressed: () {
// // _moveToLocation(searchController.text);
// // },
// // ),
// // ),
// // ),
// // ),
// // ),
// // // Map
// // Expanded(
// // child: GoogleMap(
// // myLocationButtonEnabled: false,
// // zoomControlsEnabled: false,
// // initialCameraPosition: CameraPosition(
// // zoom: 15,
// // target: _defaultLocation,
// // ),
// // onMapCreated: (GoogleMapController controller) {
// // mapController = controller;
// // },
// // markers: {
// // Marker(
// // markerId: MarkerId("_currentLocation"),
// // icon: BitmapDescriptor.defaultMarker,
// // position: currentLocation != null
// // ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
// //     : _defaultLocation,
// // ),
// // Marker(
// // markerId: MarkerId("_destination"),
// // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
// // position: LatLng(0.0, 0.0),
// // ),
// // },
// // onCameraMoveStarted: () {
// // setState(() {
// // _isCameraMoving = true;
// // });
// // },
// // onCameraIdle: () {
// // setState(() {
// // _isCameraMoving = false;
// // });
// // },
// // ),
// // ),
// // // Button to set a destination
// // ElevatedButton(
// // onPressed: () {
// // _setDestination(37.7749, -122.4194); // Example: San Francisco, CA
// // },
// // child: Text('Set Destination'),
// // ),
// // ],
// // ),