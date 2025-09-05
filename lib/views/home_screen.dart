import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekify/controllers/home_controller.dart';
import 'package:trekify/controllers/trek_controller.dart';
import 'package:trekify/widgets/custom_drawer.dart';
import 'package:trekify/widgets/difficulty_card.dart';
import 'package:trekify/widgets/season_card.dart';
import 'package:trekify/widgets/trek_type_card.dart';
import 'package:trekify/widgets/enhanced_search_bar.dart';
import 'package:trekify/widgets/trek_stat_card.dart';
import 'package:trekify/widgets/featured_trek_card.dart';

import '../controllers/app_drawer_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) => GetBuilder<TrekController>(
        builder: (trekController) => GetBuilder<AppDrawerController>(
          builder: (appDrawerController) => _HomeScreenContent(
            homeController: homeController,
            trekController: trekController,
            appDrawerController: appDrawerController,
          ),
        ),
      ),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  final HomeController homeController;
  final TrekController trekController;
  final AppDrawerController appDrawerController;

  const _HomeScreenContent({
    required this.homeController,
    required this.trekController,
    required this.appDrawerController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Ensure status bar content is visible with light content
      extendBodyBehindAppBar: true,
      body: SafeArea(
        // Only apply SafeArea to the bottom to avoid double padding at top
        top: false,
        child: Column(
          children: [
            // Fixed Top Section - Hero with gradient background and title
            _buildFixedHeroSection(context),
            
            // Scrollable Bottom Section - All content below hero
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildMainContent(context),
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }

  Widget _buildFixedHeroSection(BuildContext context) {
    // Get the status bar height to ensure proper spacing
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      height: 200 + statusBarHeight, // Add status bar height to total height
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Enhanced Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E3A8A), // Deep blue
                  const Color(0xFF3B82F6), // Blue
                  const Color(0xFF059669), // Emerald
                  const Color(0xFF10B981), // Light emerald
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
          
          // Enhanced Mountain Pattern
          CustomPaint(
            painter: _EnhancedMountainPainter(),
            size: Size.infinite,
          ),
          
          // Enhanced overlay for better readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          // Navigation Buttons - positioned below status bar
          Positioned(
            top: statusBarHeight + 16, // Add status bar height to top position
            left: 24,
            child: _buildMenuButton(context),
          ),
          Positioned(
            top: statusBarHeight + 16, // Add status bar height to top position
            right: 24,
            child: _buildNotificationButton(),
          ),
          
          // Hero Title - Fixed position
          Positioned(
            left: 28,
            bottom: 28,
            child: _buildHeroTitle(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 26),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
        onPressed: () {
          // Handle notifications
        },
      ),
    );
  }



  Widget _buildHeroTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome text
        Text(
          'Discover Your',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.95),
            height: 1.1,
          ).copyWith(
            fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Next Adventure',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 0.9,
            letterSpacing: -0.5,
          ).copyWith(
            fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explore breathtaking treks and mountain trails',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
            height: 1.2,
          ).copyWith(
            fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchSection(),
            const SizedBox(height: 36),
            _buildFeaturedTreksSection(),
            const SizedBox(height: 44),
            _buildStatisticsSection(),
            const SizedBox(height: 44),
            _buildDifficultySection(),
            const SizedBox(height: 44),
            _buildTrekTypesSection(),
            const SizedBox(height: 44),
            _buildSeasonalSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return EnhancedSearchBar(
      hintText: "Search for trek names...",
      onSearch: (query) {
        // Handle real-time search updates (optional)
        // This can be used for live search suggestions if needed
      },
      onSubmitted: (query) {
        // Handle search submission
        if (query.trim().isNotEmpty) {
          // Show loading state briefly
          Get.snackbar(
            '🔍 Searching...', 
            'Finding treks matching "${query.trim()}"',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.blue.shade600,
            colorText: Colors.white,
            duration: const Duration(seconds: 1),
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            icon: const Icon(Icons.search, color: Colors.white),
          );
          
          // Update the search query in trek controller
          trekController.updateSearchQuery(query.trim());
          // Navigate to treks screen (index 2) to show search results
          appDrawerController.navigateToPage(2);
        }
      },
      onFilterTap: () {
        // Navigate to treks screen with filter drawer open
        trekController.updateSearchQuery(''); // Clear any existing search
        appDrawerController.navigateToPage(2);
        // The filter drawer will be opened from the treks screen
      },
    );
  }

  Widget _buildFeaturedTreksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Featured Treks',
          Icons.star_rounded,
          const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 260,
          child: Obx(() {
            // Check for network errors first
            if (trekController.errorMessage.value != null) {
              return _buildErrorState(
                trekController.errorMessage.value!,
                () => trekController.retryFetchTreks(),
              );
            }
            
            // Show loading state
            if (trekController.isLoading.value) {
              return _buildLoadingState();
            }
            
            // Show empty state if no treks
            if (homeController.featuredTreks.isEmpty) {
              return _buildEmptyState(
                'No featured treks available',
                Icons.explore_outlined,
                Colors.grey.shade400,
              );
            }
            
            // Show featured treks
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: homeController.featuredTreks.length,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, index) {
                final trek = homeController.featuredTreks[index];
                return Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: FeaturedTrekCard(
                    title: trek['title'] ?? 'Unknown Trek',
                    location: trek['location'] ?? 'Unknown Location',
                    difficulty: trek['difficulty'] ?? 'Moderate',
                    rating: trek['rating'] ?? '4.0',
                    imageUrl: trek['imageUrl'] ?? '',
                    onTap: () {
                      print('Featured trek tapped: ${trek['title']}');
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Trek Statistics',
          Icons.analytics_rounded,
          const Color(0xFF6366F1),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TrekStatCard(
                icon: Icons.terrain_rounded,
                title: 'Total Treks',
                value: homeController.totalTreks,
                color: const Color(0xFF3B82F6),
                suffix: '+',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TrekStatCard(
                icon: Icons.location_on_rounded,
                title: 'Destinations',
                value: homeController.totalDestinations,
                color: const Color(0xFF10B981),
                suffix: '+',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TrekStatCard(
                icon: Icons.star_rounded,
                title: 'Rating',
                value: homeController.averageRating.value.toStringAsFixed(1),
                color: const Color(0xFFF59E0B),
                suffix: '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultySection() {
    final difficultyOptions = const ['Easy', 'Moderate', 'Difficult'];
    final difficultyImageUrls = {
      'Easy': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843181/easy_tix09h.jpg',
      'Moderate': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/moderate_xu1jby.jpg',
      'Difficult': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/difficult_net5vk.jpg',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Choose Your Challenge',
          Icons.fitness_center_rounded,
          const Color(0xFFEF4444),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: difficultyOptions.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final level = difficultyOptions[index];
              return Container(
                margin: const EdgeInsets.only(right: 20),
                child: DifficultyCard(
                  title: level,
                  imageUrl: difficultyImageUrls[level] ?? '',
                  isSelected: false,
                  onTap: () {
                    trekController.applyQuickFilter(difficulty: level);
                    appDrawerController.navigateToPage(2);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrekTypesSection() {
    final trekTypes = const ['Fort', 'Lake', 'Jungle', 'Waterfall', 'Hilltop'];
    final trekTypeImageUrls = {
      'Fort': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843229/fort_kqk8zg.jpg',
      'Lake': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843228/lake_vsrt8o.jpg',
      'Jungle': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843181/easy_tix09h.jpg',
      'Waterfall': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843229/waterfall_afk20t.jpg',
      'Hilltop': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843181/easy_tix09h.jpg',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Explore Trek Types',
          Icons.explore_rounded,
          const Color(0xFF8B5CF6),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: trekTypes.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final type = trekTypes[index];
              return Container(
                margin: const EdgeInsets.only(right: 20),
                child: TrekTypeCard(
                  title: type,
                  imageUrl: trekTypeImageUrls[type] ?? '',
                  isSelected: false,
                  onTap: () {
                    trekController.applyQuickFilter(type: type);
                    appDrawerController.navigateToPage(2);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonalSection() {
    final seasons = const ['Spring', 'Summer', 'Autumn', 'Winter', 'Monsoon'];
    final seasonImageUrls = {
      'Spring': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843946/spring_lpsuye.jpg',
      'Summer': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843343/summer_dzcwmb.jpg',
      'Autumn': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843368/autumn_etoy7u.jpg',
      'Winter': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843353/winter_oj4ise.jpg',
      'Monsoon': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843391/monsoon_becpgn.jpg',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Seasonal Adventures',
          Icons.wb_sunny_rounded,
          const Color(0xFFF97316),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: seasons.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final season = seasons[index];
              return Container(
                margin: const EdgeInsets.only(right: 20),
                child: SeasonCard(
                  title: season,
                  imageUrl: seasonImageUrls[season] ?? '',
                  isSelected: false,
                  onTap: () {
                    trekController.applyQuickFilter(season: season);
                    appDrawerController.navigateToPage(2);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              letterSpacing: -0.5,
            ).copyWith(
              fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message, IconData icon, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ).copyWith(
              fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Connection Error',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ).copyWith(
              fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              errorMessage,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ).copyWith(
                fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              'Retry',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ).copyWith(
                fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading treks...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ).copyWith(
              fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
            ),
          ),
        ],
      ),
    );
  }

}

// Enhanced Mountain Painter
class _EnhancedMountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Primary mountain range
    final primaryPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.12);

    final primaryPath = Path();
    primaryPath.moveTo(0, size.height * 0.8);
    primaryPath.lineTo(size.width * 0.15, size.height * 0.5);
    primaryPath.lineTo(size.width * 0.35, size.height * 0.7);
    primaryPath.lineTo(size.width * 0.55, size.height * 0.4);
    primaryPath.lineTo(size.width * 0.75, size.height * 0.6);
    primaryPath.lineTo(size.width, size.height * 0.5);
    primaryPath.lineTo(size.width, size.height);
    primaryPath.lineTo(0, size.height);
    primaryPath.close();

    canvas.drawPath(primaryPath, primaryPaint);

    // Secondary mountain range (behind)
    final secondaryPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.08);

    final secondaryPath = Path();
    secondaryPath.moveTo(size.width * 0.2, size.height * 0.85);
    secondaryPath.lineTo(size.width * 0.4, size.height * 0.6);
    secondaryPath.lineTo(size.width * 0.6, size.height * 0.8);
    secondaryPath.lineTo(size.width * 0.8, size.height * 0.65);
    secondaryPath.lineTo(size.width, size.height * 0.75);
    secondaryPath.lineTo(size.width, size.height);
    secondaryPath.lineTo(size.width * 0.2, size.height);
    secondaryPath.close();

    canvas.drawPath(secondaryPath, secondaryPaint);

    // Distant mountain peaks
    final distantPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.05);

    final distantPath = Path();
    distantPath.moveTo(size.width * 0.1, size.height * 0.9);
    distantPath.lineTo(size.width * 0.25, size.height * 0.75);
    distantPath.lineTo(size.width * 0.45, size.height * 0.85);
    distantPath.lineTo(size.width * 0.65, size.height * 0.7);
    distantPath.lineTo(size.width * 0.85, size.height * 0.8);
    distantPath.lineTo(size.width, size.height * 0.7);
    distantPath.lineTo(size.width, size.height);
    distantPath.lineTo(size.width * 0.1, size.height);
    distantPath.close();

    canvas.drawPath(distantPath, distantPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
