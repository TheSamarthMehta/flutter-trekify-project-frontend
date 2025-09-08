// lib/views/trek_details_screen.dart

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekify/controllers/trek_details_controller.dart';
import 'package:trekify/controllers/wishlist_controller.dart';

import '../controllers/iternary_controllers.dart';


class TrekDetailsScreen extends GetView<TrekDetailsController> {
  final WishlistController wishlistController = Get.find<WishlistController>();
  final ItineraryController itineraryController = Get.find<ItineraryController>();
  TrekDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        child: Obx(() {
        if (controller.trek.value == null) {
          return _buildLoadingState();
        }

        final trek = controller.trek.value!;
        final List<String> gearList = trek.recommendedGear
            .split(RegExp(r',|;|/'))
            .map((g) => g.trim())
            .where((g) => g.isNotEmpty && g.toLowerCase() != 'n/a' && g.toLowerCase() != 'na')
            .toList();

        return CustomScrollView(
          slivers: [
            // Enhanced Hero Header
            SliverAppBar(
              expandedHeight: 350.0,
              pinned: true,
              stretch: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() => IconButton(
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
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Hero Image
                    CachedNetworkImage(
                      imageUrl: trek.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.grey[300]!, Colors.grey[100]!],
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey[400]!, Colors.grey[300]!],
                          ),
                        ),
                        child: const Icon(Icons.broken_image, color: Colors.white, size: 50),
                      ),
                    ),
                    
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                    
                    // Trek Name Overlay
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(trek.difficulty).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              trek.difficulty,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            trek.trekName,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: Colors.white.withOpacity(0.9), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${trek.state}, ${trek.district}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                // Quick Stats Section
                _buildQuickStatsSection(trek),
                
                // Main Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      // Trek Details Card
                      _buildModernDetailCard(
                        title: 'Trek Information',
                        icon: Icons.info_outline_rounded,
                        color: Colors.blue,
                        child: _buildModernDetailGrid(trek),
                      ),
                      const SizedBox(height: 16),

                      // About This Trek Card
                      _buildModernDetailCard(
                        title: 'About This Trek',
                        icon: Icons.article_outlined,
                        color: Colors.green,
                        child: Text(
                          trek.description,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Recommended Gear Card
                      _buildModernDetailCard(
                        title: 'Essential Gear',
                        icon: Icons.backpack_outlined,
                        color: Colors.orange,
                        child: gearList.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'No specific gear requirements listed for this trek.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : _buildGearGrid(gearList),
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 100), // Space for FAB
                    ],
                  ),
                ),
              ]),
            ),
          ],
        );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            itineraryController.addToItinerary(controller.trek.value!);
            Get.snackbar('Added', '${controller.trek.value!.trekName} added to itinerary');
          },
          label: Text(
            'ADD TO ITINERARY',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          icon: const Icon(Icons.add_location_alt_rounded),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal.shade400, Colors.teal.shade600],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection(trek) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade400, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.landscape_rounded,
              label: 'Altitude',
              value: trek.altitude,
              color: Colors.white,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.directions_walk_rounded,
              label: 'Distance',
              value: trek.totalDistance,
              color: Colors.white,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.group_rounded,
              label: 'Age Group',
              value: trek.ageGroup,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: color.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModernDetailCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildModernDetailGrid(trek) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildModernDetailItem(
                icon: Icons.map_rounded,
                label: 'State',
                value: trek.state,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModernDetailItem(
                icon: Icons.location_city_rounded,
                label: 'District',
                value: trek.district,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildModernDetailItem(
                icon: Icons.trending_up_rounded,
                label: 'Difficulty',
                value: trek.difficulty,
                color: _getDifficultyColor(trek.difficulty),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModernDetailItem(
                icon: Icons.wb_sunny_rounded,
                label: 'Best Season',
                value: trek.season,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildModernDetailItem(
                icon: Icons.support_agent_rounded,
                label: 'Guide',
                value: _formatGuideValue(trek.guideNeeded),
                color: _getGuideColor(trek.guideNeeded),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildModernDetailItem(
                icon: Icons.ac_unit_rounded,
                label: 'Snow Trek',
                value: _formatYesNo(trek.snowTrek),
                color: _getYesNoColor(trek.snowTrek),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGearGrid(List<String> gearList) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: gearList.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.orange, size: 16),
              const SizedBox(width: 6),
              Text(
                item,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
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


  // Utility methods
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'difficult':
        return Colors.red;
      case 'easy to moderate':
        return Colors.lightGreen;
      case 'moderate to difficult':
        return Colors.deepOrange;
      default:
        return Colors.blue;
    }
  }

  String _formatGuideValue(String value) {
    final v = value.toUpperCase();
    if (v == 'YES' || v == 'REQUIRED') return 'Required';
    if (v == 'NO' || v == 'NOT NEEDED' || v == 'NOT REQUIRED') return 'Not Required';
    if (v == 'RECOMMENDED' || v == 'ADVISABLE' || v == 'ADVISED') return 'Recommended';
    if (v == 'OPTIONAL' || v == 'MAYBE') return 'Optional';
    return value;
  }

  Color _getGuideColor(String value) {
    final v = value.toUpperCase();
    if (v == 'YES' || v == 'REQUIRED') return Colors.red;
    if (v == 'NO' || v == 'NOT NEEDED' || v == 'NOT REQUIRED') return Colors.green;
    if (v == 'RECOMMENDED' || v == 'ADVISABLE' || v == 'ADVISED') return Colors.orange;
    if (v == 'OPTIONAL' || v == 'MAYBE') return Colors.blueGrey;
    return Colors.grey;
  }

  String _formatYesNo(String value) {
    final v = value.toUpperCase();
    if (v == 'YES' || v == 'TRUE' || v == '1') return 'Yes';
    return 'No';
  }

  Color _getYesNoColor(String value) {
    final v = value.toUpperCase();
    if (v == 'YES' || v == 'TRUE' || v == '1') return Colors.blue;
    return Colors.grey;
  }

}