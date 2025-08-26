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
    final String difficultyLevel = json['difficultyLevel'] ?? 'N/A';
    final String durationOrSeason = json['duration'] ?? 'All Seasons';
    final String incomingAgeGroup = json['ageGroup'] ?? 'N/A';
    final bool incomingGuideNeeded = _parseBool(json['guideNeeded']);
    final bool incomingSnowTrek = _parseBool(json['snowTrek']);

    return Trek(
      // ✅ CORRECTED: Using keys directly from the server's response
      trekName: json['trekName'] ?? 'Unknown Trek',
      state: json['state'] ?? 'Unknown State',
      district: json['trekType'] ?? 'N/A', // Assuming trekType maps to district
      difficulty: difficultyLevel,
      season: durationOrSeason, // Backend swaps season/duration in dataset
      type: json['trekType'] ?? 'Miscellaneous',
      imageUrl: json['image'] ?? '',
      altitude: (json['maxAltitude'] ?? 'N/A').toString(),
      totalDistance: json['distance'] ?? 'N/A',
      ageGroup: _deriveAgeGroup(incomingAgeGroup, difficultyLevel),
      guideNeeded: incomingGuideNeeded || _inferGuideNeeded(difficultyLevel),
      snowTrek: incomingSnowTrek || _inferSnowTrek(durationOrSeason),
      recommendedGear: json['recommendedGear'] ?? '',
      description: json['trekDescription'] ?? 'No description available for this trek.',
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final lowerValue = value.toLowerCase().trim();
      return lowerValue == 'true' || lowerValue == 'yes' || lowerValue == '1';
    }
    return false;
  }

  static String _deriveAgeGroup(String incoming, String difficulty) {
    if (incoming.isNotEmpty && incoming != 'N/A') return incoming;
    final d = difficulty.toLowerCase();
    if (d.contains('easy')) return '10-60';
    if (d.contains('moderate')) return '14-55';
    if (d.contains('difficult') || d.contains('hard')) return '18-45';
    return '12-60';
  }

  static bool _inferGuideNeeded(String difficulty) {
    final d = difficulty.toLowerCase();
    return d.contains('moderate') || d.contains('difficult') || d.contains('hard');
  }

  static bool _inferSnowTrek(String seasonOrDuration) {
    final s = seasonOrDuration.toLowerCase();
    return s.contains('winter') || s.contains('dec') || s.contains('jan') || s.contains('feb');
  }
}