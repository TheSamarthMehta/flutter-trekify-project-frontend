// lib/views/trek_details_screen.dart

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:trekify/controllers/trek_details_controller.dart';
import 'package:trekify/models/review_model.dart';
import 'package:trekify/controllers/wishlist_controller.dart';

import '../controllers/iternary_controllers.dart';


class TrekDetailsScreen extends GetView<TrekDetailsController> {
  final WishlistController wishlistController = Get.find<WishlistController>();
  final ItineraryController itineraryController = Get.find<ItineraryController>();
  TrekDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.trek.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final trek = controller.trek.value!;
        final List<String> gearList = trek.recommendedGear
            .split(RegExp(r',|;|/'))
            .map((g) => g.trim())
            .where((g) => g.isNotEmpty && g.toLowerCase() != 'n/a' && g.toLowerCase() != 'na')
            .toList();

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280.0,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.teal,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                title: Text(
                  trek.trekName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                centerTitle: true,
                titlePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: trek.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                          color: Colors.grey,
                          child: const Icon(Icons.broken_image,
                              color: Colors.white, size: 50)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.5, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Obx(() => IconButton(
                  icon: Icon(
                    wishlistController.isInWishlist(trek)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: wishlistController.isInWishlist(trek)
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                  onPressed: () {
                    wishlistController.toggleWishlist(trek);
                  },
                )),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Trek Details Card
                      _buildDetailCard(
                        title: 'Trek Details',
                        icon: Icons.list_alt_rounded,
                        child: Column(
                          children: [
                            _buildDetailRow(
                                'State', trek.state, Icons.map_outlined),
                            _buildDetailRow('District', trek.district,
                                Icons.location_city_outlined),
                            _buildDetailRow('Difficulty', trek.difficulty,
                                Icons.trending_up_rounded),
                            _buildDetailRow('Altitude', trek.altitude,
                                Icons.landscape_outlined),
                            _buildDetailRow('Best Season', trek.season,
                                Icons.wb_sunny_outlined),
                            _buildDetailRow(
                                'Total Distance',
                                trek.totalDistance,
                                Icons.directions_walk_rounded),
                            _buildDetailRow('Age Group', trek.ageGroup, Icons.group),
                            _buildGuideRow('Guide Needed?', trek.guideNeeded, Icons.support_agent),
                            _buildYesNoRow('Snow Trek?', trek.snowTrek, Icons.ac_unit),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // About This Trek Card
                      _buildDetailCard(
                        title: 'Trek Description',
                        icon: Icons.article_outlined,
                        child: Text(
                          trek.description,
                          style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Recommended Gear Card (always visible)
                      _buildDetailCard(
                        title: 'Recommended Gear',
                        icon: Icons.backpack_outlined,
                        child: gearList.isEmpty
                            ? const Text(
                                'No specific gear listed for this trek.',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: gearList.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.teal,
                                            size: 18),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 10),

                      // ✅ EDITED: Reviews Card now uses the main card builder
                      Obx(() => _buildReviewCard(context, controller.reviews)),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          itineraryController.addToItinerary(controller.trek.value!);
        },
        label: const Text('ADD TO ITINERARY'),
        icon: const Icon(Icons.add_location_alt_outlined),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildDetailCard(
      {required String title, required IconData icon, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.teal,
            child: Row(children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 16),
          Text('$label:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600])),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooleanDetailRow(String label, bool value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 16),
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600])),
          const Spacer(),
          Text(
            value ? 'Yes' : 'No',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: value ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYesNoRow(String label, String value, IconData icon) {
    final v = (value).toUpperCase();
    final bool yes = v == 'YES' || v == 'TRUE' || v == '1';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 16),
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600])),
          const Spacer(),
          Text(
            yes ? 'Yes' : 'No',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: yes ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideRow(String label, String value, IconData icon) {
    final v = (value).toUpperCase();
    Color color = Colors.grey.shade700;
    String display = v;
    if (v == 'YES' || v == 'REQUIRED') { color = Colors.red.shade700; display = 'Yes'; }
    else if (v == 'NO' || v == 'NOT NEEDED' || v == 'NOT REQUIRED') { color = Colors.green.shade700; display = 'No'; }
    else if (v == 'RECOMMENDED' || v == 'ADVISABLE' || v == 'ADVISED') { color = Colors.orange.shade700; display = 'Recommended'; }
    else if (v == 'OPTIONAL' || v == 'MAYBE') { color = Colors.blueGrey.shade700; display = 'Optional'; }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 16),
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600])),
          const Spacer(),
          Text(
            display,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ EDITED: This now uses the main _buildDetailCard for a consistent look
  Widget _buildReviewCard(BuildContext context, List<Review> reviews) {
    return _buildDetailCard(
      title: "Reviews",
      icon: Icons.reviews_outlined,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showWriteReviewDialog(context),
              icon: const Icon(Icons.edit_note_outlined),
              label: const Text("Write a review"),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.teal.shade300),
                foregroundColor: Colors.teal.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const Divider(height: 32),
          SizedBox(
            height: 220, // Height for the horizontal scroller
            child: reviews.isEmpty
                ? const Center(
                child: Text("Be the first to share your experience!",
                    style: TextStyle(fontSize: 16, color: Colors.grey)))
                : PageView.builder(
              controller: PageController(
                viewportFraction: 0.9,
              ),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return _buildModernReviewCard(reviews[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // This modern review card stays the same
  Widget _buildModernReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.teal.withOpacity(0.1),
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM d, yyyy').format(review.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  review.rating,
                      (index) => Icon(
                    Icons.star_rounded,
                    color: Colors.amber.shade600,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                '"${review.comment}"',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  height: 1.5,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWriteReviewDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController commentController = TextEditingController();
    final RxInt rating = 0.obs;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Share Your Experience'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              const Text("Tap a star to rate", style: TextStyle(fontSize: 16)),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => rating.value = index + 1,
                    icon: Icon(
                      index < rating.value
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber.shade600,
                      size: 36,
                    ),
                  );
                }),
              )),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Your Review',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  commentController.text.isNotEmpty &&
                  rating.value > 0) {
                final newReview = Review(
                  userName: nameController.text,
                  rating: rating.value,
                  comment: commentController.text,
                  timestamp: DateTime.now(),
                );
                controller.addReview(newReview);
                Get.back();
              } else {
                Get.snackbar(
                  'Incomplete',
                  'Please fill all fields and provide a rating.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade600,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(12),
                );
              }
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }
}