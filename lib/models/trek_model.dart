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
  final String guideNeeded; // YES/NO/RECOMMENDED/OPTIONAL
  final String snowTrek; // YES/NO
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
      'recommendendSeason': season, // Note: JSON has typo "recommendendSeason"
      'terrainType': type,
      'images': imageUrl, // JSON uses 'images' not 'image'
      'altitude': altitude,
      'totalDistance': totalDistance,
      'ageGroup': ageGroup,
      'guideNeeded': guideNeeded,
      'snowTrek': snowTrek,
      'recommendedGear': recommendedGear,
    };
  }

  factory Trek.fromJson(Map<String, dynamic> json) {
    return Trek(
      // ✅ CORRECTED: Using exact keys from the JSON response
      trekName: json['trekName'] ?? 'Unknown Trek',
      state: json['state'] ?? 'Unknown State',
      district: json['district'] ?? 'N/A',
      difficulty: json['difficultyLevel'] ?? 'N/A',
      season: json['recommendendSeason'] ?? 'All Seasons', // Note: JSON has typo "recommendendSeason"
      type: json['terrainType'] ?? 'Miscellaneous',
      imageUrl: json['images'] ?? '', // JSON uses 'images' not 'image'
      altitude: (json['altitude'] ?? 'N/A').toString(),
      totalDistance: json['totalDistance'] ?? 'N/A',
      ageGroup: (json['ageGroup'] ?? 'N/A').toString(),
      guideNeeded: (json['guideNeeded'] ?? '').toString().toUpperCase(),
      snowTrek: (json['snowTrek'] ?? 'NO').toString().toUpperCase(),
      recommendedGear: (json['recommendedGear'] ?? '').toString(),
      description: 'Trek in ${json['state'] ?? 'Unknown State'} - ${json['terrainType'] ?? 'Miscellaneous'} terrain',
    );
  }

  // Kept for backward compatibility if needed by other parts; not used in current mapping
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final lowerValue = value.toLowerCase().trim();
      return lowerValue == 'true' || lowerValue == 'yes' || lowerValue == '1';
    }
    return false;
  }
}