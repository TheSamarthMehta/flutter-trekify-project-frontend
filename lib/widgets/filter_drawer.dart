import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekify/controllers/trek_controller.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final TrekController controller = Get.find<TrekController>();

    final difficulties = ['Easy', 'Moderate', 'Difficult'];
    final seasons = ['Summer', 'Winter', 'Monsoon'];
    final types = ['Fort', 'Lake', 'Jungle', 'Waterfall', 'Hilltop'];
    final distances = ['0-10 km', '11-20 km', '20+ km'];
    final ageGroups = ['0-10 years', '10-18 years', '18-40 years', '40+ years'];

    return Drawer(
      backgroundColor: Colors.grey.shade50,
      child: SafeArea(
        child: Column(
          children: [
            // Beautiful Header
            _buildHeader(context),
            
            // Filter Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRadioFilterSection(context, "Difficulty", difficulties, controller.tempSelectedDifficulties, controller),
                    _buildRadioFilterSection(context, "Season", seasons, controller.tempSelectedSeasons, controller),
                    _buildRadioFilterSection(context, "Type", types, controller.tempSelectedTypes, controller),
                    _buildRadioFilterSection(context, "Age Group", ageGroups, controller.tempSelectedAgeGroups, controller),
                    _buildRadioFilterSection(context, "Distance", distances, controller.tempSelectedDistances, controller),
                    _buildMultiSelectFilterSection(context, "State", controller.uniqueStates, controller.tempSelectedStates, controller),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            _buildActionButtons(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E3A8A),
            const Color(0xFF3B82F6),
            const Color(0xFF059669),
            const Color(0xFF10B981),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                "Filters",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Customize your trek search",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioFilterSection(BuildContext context, String title, List<String> options, RxSet<String> tempSelectedOptions, TrekController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children: options.map((option) {
              final isSelected = tempSelectedOptions.contains(option);
              return GestureDetector(
                onTap: () {
                  // Radio behavior: clear all and select only this one
                  tempSelectedOptions.clear();
                  tempSelectedOptions.add(option);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF059669) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF059669) : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        Icon(
                          Icons.radio_button_checked,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                      ] else ...[
                        Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.grey.shade500,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        option,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildMultiSelectFilterSection(BuildContext context, String title, List<String> options, RxSet<String> tempSelectedOptions, TrekController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children: options.map((option) {
              final isSelected = tempSelectedOptions.contains(option);
              return GestureDetector(
                onTap: () {
                  controller.toggleTempFilter(tempSelectedOptions, option);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF059669) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF059669) : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                      ] else ...[
                        Icon(
                          Icons.circle_outlined,
                          color: Colors.grey.shade500,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        option,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildActionButtons(TrekController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.clearTempFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: const Color(0xFF059669), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Clear All",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: controller.applyFiltersFromTemp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                "Apply Filters",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
