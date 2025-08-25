// lib/models/trek_model.dart
class Trek {
  final String trekName;
  final String state;
  final String district;
  final String difficulty;
  final String season;
  final String type;
  final String imageUrl;
  final String altitude;
  final String totalDistance;
  final String ageGroup;
  final bool guideNeeded;
  final bool snowTrek;
  final String recommendedGear;
  final String description;

  Trek({
    required this.trekName,
    required this.state,
    required this.difficulty,
    required this.season,
    required this.type,
    required this.imageUrl,
    required this.altitude,
    required this.district,
    required this.totalDistance,
    required this.ageGroup,
    required this.guideNeeded,
    required this.snowTrek,
    required this.recommendedGear,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'trekName': trekName,
      'state': state,
      'district': district,
      'difficultyLevel': difficulty,
      'season': season,
      'trekType': type,
      'image': imageUrl,
      'maxAltitude': altitude,
      'distance': totalDistance,
      'ageGroup': ageGroup,
      'guideNeeded': guideNeeded,
      'snowTrek': snowTrek,
      'recommendedGear': recommendedGear,
      'trekDescription': description,
    };
  }

  factory Trek.fromJson(Map<String, dynamic> json) {
    return Trek(
      // ✅ CORRECTED: Using keys directly from the server's response
      trekName: json['trekName'] ?? 'Unknown Trek',
      state: json['state'] ?? 'Unknown State',
      district: json['trekType'] ?? 'N/A', // Assuming trekType maps to district
      difficulty: json['difficultyLevel'] ?? 'N/A',
      season: json['duration'] ?? 'All Seasons', // Assuming duration maps to season
      type: json['trekType'] ?? 'Miscellaneous',
      imageUrl: json['image'] ?? '',
      altitude: (json['maxAltitude'] ?? 'N/A').toString(),
      totalDistance: json['distance'] ?? 'N/A',
      ageGroup: json['ageGroup'] ?? 'N/A',
      guideNeeded: _parseBool(json['guideNeeded']),
      snowTrek: _parseBool(json['snowTrek']),
      recommendedGear: json['recommendedGear'] ?? '',
      description: json['trekDescription'] ?? 'No description available for this trek.',
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final lowerValue = value.toLowerCase().trim();
      return lowerValue == 'true' || lowerValue == 'yes' || lowerValue == 'recommended';
    }
    return false;
  }
}