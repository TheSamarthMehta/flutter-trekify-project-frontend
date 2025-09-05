// lib/widgets/trek_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ 1. IMPORT GETX
import 'package:shimmer/shimmer.dart';
import 'package:trekify/models/trek_model.dart';

class TrekCard extends StatelessWidget {
  final Trek trek;
  const TrekCard({super.key, required this.trek});

  @override
  Widget build(BuildContext context) {
    // ✅ 2. WRAP THE CARD IN AN INKWELL/GESTUREDETECTOR FOR THE TAP EVENT
    return InkWell(
      // ✅ 3. USE GET.TONAMED() FOR CLEAN, NAMED ROUTING
      onTap: () {
        Get.toNamed(
          '/trek-details', // The route you defined in main.dart
          arguments: trek, // Pass the entire trek object to the next screen
        );
      },
      // Ensures the ripple effect matches the card's shape
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: trek.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trek.trekName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.grey[600], size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          trek.state,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[800]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildInfoChip(trek.altitude,
                            Icons.landscape_outlined, Colors.orange),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                            trek.difficulty, Icons.trending_up, Colors.blue),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                            trek.season, Icons.wb_sunny, Colors.green),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                            trek.type, Icons.filter_hdr, Colors.purple),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    final chipLabel = label.isNotEmpty ? label : 'N/A';
    return Chip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(
        chipLabel,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: color.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}