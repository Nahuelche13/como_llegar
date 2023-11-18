class Stoptime {
  final String stopId;
  final String arrivalTime;
  final String tripHeadsign;

  const Stoptime({
    required this.stopId,
    required this.arrivalTime,
    required this.tripHeadsign,
  });

  factory Stoptime.fromMap(Map<String, dynamic> json) {
    return Stoptime(
        stopId: json["stop_id"],
        arrivalTime: json["arrival_time"],
        tripHeadsign: json["trip_headsign"]);
  }
}

/*
class Stoptime {
  final String tripId;
  final int arrivalTime;
  final String stopId;
  final int stopSequence;

  const Stoptime({
    required this.tripId,
    required this.arrivalTime,
    required this.stopId,
    required this.stopSequence,
  });

  factory Stoptime.fromMap(Map<String, dynamic> json) {
    return Stoptime(
      tripId: json["trip_id"],
      arrivalTime: json["arrival_time"],
      stopId: json["stop_id"],
      stopSequence: json["stop_sequence"],
    );
  }
}
*/