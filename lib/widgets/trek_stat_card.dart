import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Simple trek statistics card widget
class TrekStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final dynamic value;
  final Color color;
  final String suffix;

  const TrekStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75, // Final optimization - further reduced height
      padding: const EdgeInsets.all(6), // Final optimization - further reduced padding
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Ensure minimal space usage
        children: [
          // Simple icon
          Icon(
            icon,
            color: color,
            size: 14, // Final optimization - further reduced icon size
          ),
          const SizedBox(height: 2), // Final optimization - further reduced spacing
          
          // Simple value display
          Text(
            '${value}$suffix',
            style: GoogleFonts.poppins(
              fontSize: 14, // Final optimization - further reduced font size
              fontWeight: FontWeight.bold,
              color: color,
            ).copyWith(
              fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 1), // Minimal spacing
          
          // Simple title
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 8, // Final optimization - further reduced font size
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ).copyWith(
              fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
