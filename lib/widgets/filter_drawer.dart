import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/trek_controller.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final TrekController controller = Get.find<TrekController>();

    final difficulties = ['Easy', 'Moderate', 'Difficult'];
    final seasons = ['Spring', 'Summer', 'Autumn', 'Winter', 'Monsoon'];
    final types = ['Fort', 'Lake', 'Jungle', 'Waterfall', 'Hilltop'];
    final distances = ['0-10 km', '11-20 km', '20+ km'];
    final ageGroups = ['0-10 years', '10-18 years', '18-40 years', '40+ years'];

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Filters", style: Theme.of(context).textTheme.headlineSmall),
              const Divider(thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ EDITED: Sections now point to the temporary filter sets.
                      _buildFilterSection(context, "Difficulty", difficulties, controller.tempSelectedDifficulties, controller),
                      _buildFilterSection(context, "Season", seasons, controller.tempSelectedSeasons, controller),
                      _buildFilterSection(context, "Type", types, controller.tempSelectedTypes, controller),
                      _buildFilterSection(context, "Age Group", ageGroups, controller.tempSelectedAgeGroups, controller),
                      _buildFilterSection(context, "Distance", distances, controller.tempSelectedDistances, controller),
                      _buildFilterSection(context, "State", controller.uniqueStates, controller.tempSelectedStates, controller),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      // ✅ EDITED: Now clears the temporary filters.
                      onPressed: controller.clearTempFilters,
                      child: const Text("Clear"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      // ✅ EDITED: Now calls the new method to apply filters.
                      onPressed: controller.applyFiltersFromTemp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ✅ EDITED: The `onSelected` callback now calls `toggleTempFilter`.
  Widget _buildFilterSection(BuildContext context, String title, List<String> options, RxSet<String> tempSelectedOptions, TrekController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Obx(() => Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: options.map((option) {
            final isSelected = tempSelectedOptions.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                controller.toggleTempFilter(tempSelectedOptions, option);
              },
              selectedColor: Colors.teal.withOpacity(0.3),
              checkmarkColor: Colors.teal,
            );
          }).toList(),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}
