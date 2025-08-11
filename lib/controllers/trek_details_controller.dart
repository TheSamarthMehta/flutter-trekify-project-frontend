// lib/controllers/trek_details_controller.dart
import 'package:get/get.dart';
import 'package:trekify/models/trek_model.dart';
// ✅ 1. IMPORT THE NEW REVIEW MODEL
import 'package:trekify/models/review_model.dart';

class TrekDetailsController extends GetxController {
  final trek = Rxn<Trek>();
  // ✅ 2. CREATE A REACTIVE LIST TO HOLD REVIEWS
  final reviews = <Review>[].obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic argument = Get.arguments;
    if (argument is Trek) {
      trek.value = argument;
      // ✅ 3. LOAD SOME SAMPLE REVIEWS WHEN THE CONTROLLER IS INITIALIZED
      _loadSampleReviews();
    }
  }

  // ✅ 4. METHOD TO ADD A NEW REVIEW TO THE LIST
  void addReview(Review review) {
    // .insert(0, review) adds the newest review to the top of the list
    reviews.insert(0, review);
  }

  // Helper method to populate with initial data
  void _loadSampleReviews() {
    reviews.assignAll([
      Review(
        userName: 'Riya Sharma',
        rating: 4,
        comment:
        'Amazing experience! The views were breathtaking and the guide was very knowledgeable. Highly recommended for everyone.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        userName: 'Arjun Verma',
        rating: 5,
        comment: 'A challenging but incredibly rewarding trek. The landscape is unreal!',
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ]);
  }
}