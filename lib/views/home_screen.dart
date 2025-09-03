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
import 'package:trekify/widgets/floating_action_button.dart';
import 'package:trekify/widgets/weather_widget.dart';
import 'package:trekify/widgets/featured_trek_card.dart';

import '../controllers/app_drawer_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final TrekController trekController = Get.find<TrekController>();
    final AppDrawerController appDrawerController = Get.find<AppDrawerController>();

    // ✅ EDITED: Replace these placeholder URLs with your actual cloud URIs.
    final difficultyImageUrls = {
      'Easy': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843181/easy_tix09h.jpg',
      'Moderate': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/moderate_xu1jby.jpg',
      'Difficult': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/difficult_net5vk.jpg',
    };

    final trekTypeImageUrls = {
      'Fort': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843229/fort_kqk8zg.jpg',
      'Lake': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843228/lake_vsrt8o.jpg',
      'Jungle': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843227/jungle_svj7u0.jpg',
      'Waterfall': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843229/waterfall_afk20t.jpg',
      'Hilltop': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843227/hilltop_rvj0un.jpg',
    };

    final seasonImageUrls = {
      'Spring': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843946/spring_lpsuye.jpg',
      'Summer': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843343/summer_dzcwmb.jpg',
      'Autumn': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843368/autumn_etoy7u.jpg',
      'Winter': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843353/winter_oj4ise.jpg',
      'Monsoon': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843391/monsoon_becpgn.jpg',
    };

    final difficultyOptions = const ['Easy', 'Moderate', 'Difficult'];
    final trekTypes = const ['Fort', 'Lake', 'Jungle', 'Waterfall', 'Hilltop'];
    final seasons = const ['Spring', 'Summer', 'Autumn', 'Winter', 'Monsoon'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Mountain Background
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Mountain Background Image
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.shade800,
                          Colors.blue.shade600,
                          Colors.green.shade700,
                        ],
                      ),
                    ),
                    child: CustomPaint(
                      painter: MountainPainter(),
                      size: Size.infinite,
                    ),
                  ),
                  // Overlay for better text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Hero Content
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discover Your',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Next Adventure',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore breathtaking treks and mountain trails',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          
          // Main Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Search Bar
                    EnhancedSearchBar(
                      hintText: "Search for treks, mountains, trails...",
                      onSearch: (query) {
                        // Handle search functionality
                        print('Searching for: $query');
                      },
                      onFilterTap: () {
                        // Handle filter tap
                        print('Filter tapped');
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Weather Widget
                    WeatherWidget(
                      temperature: '18°C',
                      condition: 'Partly Cloudy',
                      location: 'Mountain Peak',
                      weatherIcon: Icons.cloud,
                      primaryColor: Colors.blue.shade600,
                      onTap: () {
                        // Handle weather tap
                        print('Weather tapped');
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Weather Detail Cards
                    Row(
                      children: [
                        Expanded(
                          child: WeatherCard(
                            title: 'Humidity',
                            value: '65',
                            unit: '%',
                            icon: Icons.water_drop,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: WeatherCard(
                            title: 'Wind',
                            value: '12',
                            unit: ' km/h',
                            icon: Icons.air,
                            color: Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: WeatherCard(
                            title: 'Visibility',
                            value: '8',
                            unit: ' km',
                            icon: Icons.visibility,
                            color: Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),

                    // Featured Treks Section
                    _buildSectionHeader(
                      context,
                      'Featured Treks',
                      Icons.star,
                      Colors.amber.shade600,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          FeaturedTrekCard(
                            title: 'Himalayan Peak Trek',
                            location: 'Himalayas, India',
                            difficulty: 'Difficult',
                            duration: '7 days',
                            rating: '4.9',
                            imageUrl: 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/difficult_net5vk.jpg',
                            isPremium: true,
                            onTap: () {
                              print('Featured trek tapped: Himalayan Peak');
                            },
                          ),
                          FeaturedTrekCard(
                            title: 'Valley of Flowers',
                            location: 'Uttarakhand, India',
                            difficulty: 'Moderate',
                            duration: '5 days',
                            rating: '4.7',
                            imageUrl: 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/moderate_xu1jby.jpg',
                            onTap: () {
                              print('Featured trek tapped: Valley of Flowers');
                            },
                          ),
                          FeaturedTrekCard(
                            title: 'Western Ghats Trail',
                            location: 'Karnataka, India',
                            difficulty: 'Easy',
                            duration: '3 days',
                            rating: '4.5',
                            imageUrl: 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843181/easy_tix09h.jpg',
                            onTap: () {
                              print('Featured trek tapped: Western Ghats');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Quick Stats Section
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.terrain,
                            title: 'Total Treks',
                            value: '150+',
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.location_on,
                            title: 'Destinations',
                            value: '25+',
                            color: Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.star,
                            title: 'Rating',
                            value: '4.8',
                            color: Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Difficulty Section with enhanced design
                    _buildSectionHeader(
                      context,
                      'Choose Your Challenge',
                      Icons.fitness_center,
                      Colors.red.shade600,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: difficultyOptions.length,
                        itemBuilder: (context, index) {
                          final level = difficultyOptions[index];
                          return DifficultyCard(
                            title: level,
                            imageUrl: difficultyImageUrls[level]!,
                            isSelected: false,
                            onTap: () {
                              trekController.applyQuickFilter(difficulty: level);
                              appDrawerController.navigateToPage(2);
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Trek Types Section
                    _buildSectionHeader(
                      context,
                      'Explore Trek Types',
                      Icons.explore,
                      Colors.purple.shade600,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: trekTypes.length,
                        itemBuilder: (context, index) {
                          final type = trekTypes[index];
                          return TrekTypeCard(
                            title: type,
                            imageUrl: trekTypeImageUrls[type]!,
                            isSelected: false,
                            onTap: () {
                              trekController.applyQuickFilter(type: type);
                              appDrawerController.navigateToPage(2);
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Seasonal Treks Section
                    _buildSectionHeader(
                      context,
                      'Seasonal Adventures',
                      Icons.wb_sunny,
                      Colors.orange.shade600,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: seasons.length,
                        itemBuilder: (context, index) {
                          final season = seasons[index];
                          return SeasonCard(
                            title: season,
                            imageUrl: seasonImageUrls[season]!,
                            isSelected: false,
                            onTap: () {
                              trekController.applyQuickFilter(season: season);
                              appDrawerController.navigateToPage(2);
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      floatingActionButton: CustomFloatingActionButton(
        onMainButtonTap: () {
          // Handle main FAB tap
          print('Main FAB tapped');
        },
        onNearbyTap: () {
          // Handle nearby tap
          print('Nearby tapped');
        },
        onWeatherTap: () {
          // Handle weather tap
          print('Weather tapped');
        },
        onEmergencyTap: () {
          // Handle emergency tap
          print('Emergency tapped');
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
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
}

// Custom Painter for Mountain Background
class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.1);

    final path = Path();
    
    // First mountain (left)
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second mountain (right)
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.05);

    final path2 = Path();
    path2.moveTo(size.width * 0.4, size.height * 0.8);
    path2.lineTo(size.width * 0.6, size.height * 0.5);
    path2.lineTo(size.width * 0.8, size.height * 0.7);
    path2.lineTo(size.width, size.height * 0.6);
    path2.lineTo(size.width, size.height);
    path2.lineTo(size.width * 0.4, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
