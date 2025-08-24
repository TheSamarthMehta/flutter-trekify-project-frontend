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
    // ✅ ADDED: Initialize in the constructor
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'Trek Name': trekName,
      'State': state,
      'District': district,
      'Difficulty Level': difficulty,
      'Season': season,
      'Type': type,
      'Images': imageUrl,
      'Altitude': altitude,
      'Total Distance': totalDistance,
      'Age Group': ageGroup,
      'Guide Needed?': guideNeeded,
      'Snow Trek?': snowTrek,
      'Recommended Gear': recommendedGear,
      'Description': description,
    };
  }

  factory Trek.fromJson(Map<String, dynamic> json) {
    return Trek(
      trekName: json['Trek Name'] ?? 'Unknown Trek',
      state: json['State'] ?? 'Unknown State',
      district: json['District'] ?? 'N/A',
      // ✅ FIXED: Changed to match your API data
      difficulty: json['Difficulty Level'] ?? 'N/A',
      season: json['Season'] ?? 'All Seasons',
      type: json['Type'] ?? 'Miscellaneous',
      // ✅ FIXED: Changed to match your API data
      imageUrl: json['Images'] ?? '',
      altitude: (json['Altitude'] ?? 'N/A').toString(),
      totalDistance: json['Total Distance'] ?? 'N/A',
      ageGroup: json['Age Group'] ?? 'N/A',
      // Handle boolean conversion safely
      guideNeeded: _parseBool(json['Guide Needed?']),
      snowTrek: _parseBool(json['Snow Trek?']),
      recommendedGear: json['Recommended Gear'] ?? '',
      description: json['Description'] ?? 'No description available for this trek.',
    );
  }
  // Helper function to safely parse boolean values which might be strings
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value.toLowerCase() == 'yes';
    }
    return false;
  }
}
