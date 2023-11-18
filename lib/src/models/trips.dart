class Trip {
  String routeId;
  String tripHeadsign;
  String tripShortName;

  Trip({
    required this.routeId,
    required this.tripHeadsign,
    required this.tripShortName,
  });

  factory Trip.fromMap(Map<String, dynamic> json) {
    return Trip(
      routeId: json["route_id"],
      tripHeadsign: json["trip_headsign"],
      tripShortName: json["trip_short_name"],
    );
  }
}
