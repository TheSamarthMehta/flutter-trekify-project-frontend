// lib/views/states_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/states_controller.dart';
import 'package:trekify/models/trek_model.dart';
import 'package:trekify/widgets/custom_drawer.dart';
import 'package:trekify/widgets/animated_progress_bar.dart';

class StatesScreen extends GetView<StatesController> {
  const StatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('States'),
        backgroundColor: Colors.teal,
      ),
      drawer: CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.stateList.isEmpty) {
          return const Center(child: Text("No states found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.stateList.length,
          itemBuilder: (context, index) {
            final state = controller.stateList[index];
            final treksInState = controller.getTreksForState(state.name);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() {
                final completionPercentage = controller.getCompletionPercentage(state.name);

                return AnimatedProgressBar(
                  percentage: completionPercentage,
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ✅ EDITED: Default text color is now dark for visibility
                        Text(
                          state.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${(completionPercentage * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ],
                    ),
                    children: treksInState.map((trek) {
                      return _buildTrekTile(trek);
                    }).toList(),
                  ),
                );
              }),
            );
          },
        );
      }),
    );
  }

  Widget _buildTrekTile(Trek trek) {
    return Obx(() => CheckboxListTile(
      // Use a standard background color for the items in the dropdown
      tileColor: Colors.grey.shade100,
      title: Text(trek.trekName, style: const TextStyle(color: Colors.black87)),
      subtitle: Text(trek.difficulty, style: TextStyle(color: Colors.grey.shade700)),
      value: controller.exploredTreks.contains(trek.trekName),
      onChanged: (bool? value) {
        controller.toggleExploredTrek(trek.trekName);
      },
      secondary: GestureDetector(
        onTap: () => Get.toNamed('/trek-details', arguments: trek),
        child: Icon(Icons.info_outline, color: Colors.teal.shade400),
      ),
      activeColor: Colors.teal,
      controlAffinity: ListTileControlAffinity.leading,
    ));
  }
}