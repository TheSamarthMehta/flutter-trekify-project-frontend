// lib/models/onboarding_info.dart

class OnboardingInfo {
  // ✅ EDITED: Renamed to 'path' for consistency with both images and videos.
  final String path;
  final String title;
  final String description;
  // ✅ ADDED: A flag to distinguish between image and video types.
  final bool isVideo;

  OnboardingInfo({
    required this.path,
    required this.title,
    required this.description,
    this.isVideo = false, // Defaults to false (image)
  });

  factory OnboardingInfo.fromJson(Map<String, dynamic> json) {
    return OnboardingInfo(
      path: json['path'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isVideo: json['isVideo'] ?? false,
    );
  }
}
