class AlarmDetails {
  String id;
  String alarmName;
  String notes;
  double locationRadius;
  bool isAlarmOn;
  bool isFavourite;
  double lat;
  double lng;

  AlarmDetails({
    required this.id,
    required this.alarmName,
    required this.notes,
    required this.locationRadius,
    required this.isAlarmOn,
    required this.isFavourite,
    required this.lat,
    required this.lng,

  });

  // Factory method to create an AlarmDetails instance from a JSON map
  factory AlarmDetails.fromJson(Map<String, dynamic> json) {
    return AlarmDetails(
      alarmName: json['alarmName'],
      notes: json['notes'],
      locationRadius: json['locationRadius'].toDouble(),
      isAlarmOn: json['isAlarmOn'], isFavourite: json['isFavourite'], lat: json['lat'], lng: json['lng'], id: json['id'],
    );
  }

  // Convert the AlarmDetails instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'alarmName': alarmName,
      'notes': notes,
      'locationRadius': locationRadius,
      'isAlarmOn': isAlarmOn,
      'isFavourite':isFavourite,
      'lat':lat,
      'lng':lng,
      'id':id,
    };
  }
}
