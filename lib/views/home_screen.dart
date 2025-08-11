import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/home_controller.dart';
import 'package:trekify/controllers/trek_controller.dart';
import 'package:trekify/widgets/custom_drawer.dart';
import 'package:trekify/widgets/difficulty_card.dart';
import 'package:trekify/widgets/season_card.dart';
import 'package:trekify/widgets/trek_type_card.dart';

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
      appBar: AppBar(
        title: const Text('Trekify Home'),
        backgroundColor: Colors.teal,
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search for treks...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Difficulty Section
              Text("Difficulty", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: difficultyOptions.length,
                  itemBuilder: (context, index) {
                    final level = difficultyOptions[index];
                    return DifficultyCard(
                      title: level,
                      // ✅ EDITED: Using network URL
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
              const SizedBox(height: 20),

              // Trek Types Section
              Text("Trek Types", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trekTypes.length,
                  itemBuilder: (context, index) {
                    final type = trekTypes[index];
                    return TrekTypeCard(
                      title: type,
                      // ✅ EDITED: Using network URL
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
              const SizedBox(height: 20),

              // Seasonal Treks Section
              Text("Seasonal Treks", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: seasons.length,
                  itemBuilder: (context, index) {
                    final season = seasons[index];
                    return SeasonCard(
                      title: season,
                      // ✅ EDITED: Using network URL
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
            ],
          ),
        ),
      ),
    );
  }
}
