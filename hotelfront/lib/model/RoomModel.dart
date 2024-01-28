class Room {
  final String id;
  final String type;
  final int pricePerNight;
  final List<String> features;

  Room({
    required this.id,
    required this.type,
    required this.pricePerNight,
    required this.features,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      type: json['type'],
      pricePerNight: json['pricePerNight'],
      features: List<String>.from(json['features']),
    );
  }
}
