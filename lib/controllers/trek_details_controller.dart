import 'package:get/get.dart';
import 'package:trekify/models/trek_model.dart';
import 'package:trekify/models/review_model.dart';

class TrekDetailsController extends GetxController {
  final trek = Rxn<Trek>();
  final reviews = <Review>[].obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic argument = Get.arguments;
    if (argument is Trek) {
      trek.value = argument;
      _loadSampleReviews();
    }
  }

  void addReview(Review review) {
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