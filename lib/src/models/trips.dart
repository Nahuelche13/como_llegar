class Trip {
  String tripId;
  String tripHeadsign;
  String tripShortName;
  String shapeId;

  Trip({
    required this.tripId,
    required this.tripHeadsign,
    required this.tripShortName,
    required this.shapeId,
  });

  factory Trip.fromMap(Map<String, dynamic> json) {
    return Trip(
      tripId: json["trip_id"],
      tripHeadsign: json["trip_headsign"],
      tripShortName: json["trip_short_name"],
      shapeId: json["shape_id"],
    );
  }
}
