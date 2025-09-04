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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              controller.refreshStates();
            },
            tooltip: 'Refresh States',
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.stateList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "No states found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Pull to refresh or tap the refresh button",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshStates(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshStates(),
          child: ListView.builder(
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
          ),
        );
      }),
    );
  }

  Widget _buildTrekTile(Trek trek) {
    return Obx(() => CheckboxListTile(
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