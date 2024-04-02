// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'Homescreens/settings.dart';
//
// class settingstate extends StatefulWidget {
//   const settingstate({super.key});
//
//   @override
//   State<settingstate> createState() => _settingstateState();
// }
// class _settingstateState extends State<settingstate> {
//   List<String> _units = ['Metric system (m/km)', 'Imperial system (mi/ft)'];
//   String? _selectedUnit;
//   double radius=0;
//   bool _imperial=false;
//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedUnit(); // Load initial state from Shared Preferences
//   }
//   Future<void> _loadSelectedUnit() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _selectedUnit = prefs.getString('selectedUnit');
//       _imperial = (_selectedUnit == 'Imperial system (mi/ft)');
//       radius = _imperial ? prefs.getDouble('radius_imperial') ?? 1.24 : prefs.getDouble('radius_metric') ?? 2000;
//     });
//   }
//
//   // Save the selected unit and radius to Shared Preferences
//   void _saveSelectedUnit(String newValue) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('selectedUnit', newValue);
//     setState(() {
//       _selectedUnit = newValue;
//       _imperial = (_selectedUnit == 'Imperial system (mi/ft)');
//       if (_imperial) {
//         final metricRadius = radius;
//         radius = metricRadius * 0.000621371; // Convert from meters to miles
//         prefs.setDouble('radius_metric', metricRadius);
//         prefs.setDouble('radius_imperial', radius);
//       } else {
//         final imperialRadius = radius;
//         radius = imperialRadius * 1609.34; // Convert from miles to meters
//         prefs.setDouble('radius_imperial', imperialRadius);
//         prefs.setDouble('radius_metric', radius);
//       }
//     });
//   }
//
//   // Update radius value from MeterCalculatorWidget
//   void updateradiusvalue(double newRadius) {
//     setState(() {
//       radius = newRadius;
//     });
//     _saveSelectedUnit(_selectedUnit!); // Re-save the selected unit to update radius in Shared Preferences
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  Center(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: DropdownButton<String>(
//                 // ... dropdown configuration
//                 onChanged: (newValue) => _saveSelectedUnit(newValue!),
//               ),
//             ),
//             _imperial
//                 ? MeterCalculatorWidget(
//               callback: updateradiusvalue,
//               unit: Unit.imperial, // Explicitly set unit for Imperial system
//             )
//                 : MeterCalculatorWidget(
//               callback: updateradiusvalue,
//               unit: Unit.metric, // Explicitly set unit for Metric system
//             ),
//           ],
//         ),
//       ),
//         // Column(
//         //     children: [
//         //       Padding(
//         //   padding: const EdgeInsets.all(30.0),
//         //   child: DropdownButton<String>(
//         //     value: _selectedUnit,
//         //     onChanged: (newValue) {
//         //       _saveSelectedUnit(newValue!); // Save the selected unit
//         //     },
//         //     hint: Text('Select Unit'),
//         //     style: TextStyle(
//         //       color: Colors.black,
//         //       fontSize: 18,
//         //     ),
//         //     underline: Container(
//         //       height: 2,
//         //       color: Colors.transparent,
//         //     ),
//         //     icon: Icon(Icons.arrow_drop_down),
//         //     iconSize: 36,
//         //     isExpanded: true,
//         //     items: _units.map((unit) {
//         //       return DropdownMenuItem<String>(
//         //         value: unit,
//         //         child: Text(unit),
//         //       );
//         //     }).toList(),
//         //   ),
//         // ),
//         //       Padding(
//         //     padding: const EdgeInsets.all(4.0),
//         //     child: Container(
//         //     child: MeterCalculatorWidget(
//         //     callback: updateradiusvalue,
//         //
//         //     ), // Pass unit system to MeterCalculatorWidget
//         //     ),
//         //     ),
//         //     ],
//         //     ),
//       ),
//
//     );
//   }
// }




// class MeterCalculatorWidget extends StatefulWidget {
//   final Function(double) callback;
//
//   const MeterCalculatorWidget({
//     Key? key,
//     required this.callback,
//   }) : super(key: key);
//
//   @override
//   _MeterCalculatorWidgetState createState() => _MeterCalculatorWidgetState();
// }
//
// class _MeterCalculatorWidgetState extends State<MeterCalculatorWidget> {
//   String? _selectedUnit;
//   double _radius = 200;
//   bool _imperial = false;
//
//   @override
//   void initState() {
//     _loadSelectedUnit();
//     super.initState();
//   }
//
//   Future _loadSelectedUnit() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _selectedUnit = prefs.getString('selectedUnit');
//       _imperial = (_selectedUnit == 'Imperial system (mi/ft)');
//       _radius = _imperial
//           ? double.parse(prefs.getString('radius_imperial') ?? '1.24')
//           : double.parse(prefs.getString('radius_metric') ?? '2000');
//     });
//   }
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
//                   value: _radius,
//                   divisions: 100,
//                   min: _imperial ? 0.05 : 50,
//                   max: _imperial ? 5.05 : 5050, // Set your maximum radius value here
//                   onChanged: (value) {
//                     setState(() {
//                       _radius = double.parse(value.toStringAsFixed(2)); // Round the value to the nearest integer
//                       _storeRadius(value);
//                       widget.callback(value);
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Text('$_radius ${_imperial ? 'miles' : 'meters'}'),
//           // Display the rounded value with the appropriate unit based on the selected system
//         ],
//       ),
//     );
//   }
//
//   void _storeRadius(double value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (_imperial) {
//       await prefs.setString('radius_imperial', value.toStringAsFixed(2));
//     } else {
//       await prefs.setString('radius_metric', value.toStringAsFixed(2));
//     }
//   }
// }
