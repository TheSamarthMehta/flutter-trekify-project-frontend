import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/trek_controller.dart';
import 'package:trekify/widgets/custom_drawer.dart';
import 'package:trekify/widgets/filter_drawer.dart';
import 'package:trekify/widgets/trek_card.dart';

class TreksScreen extends StatefulWidget {
  const TreksScreen({super.key});

  @override
  State<TreksScreen> createState() => _TreksScreenState();
}

class _TreksScreenState extends State<TreksScreen> {
  final TrekController controller = Get.find<TrekController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // This is no longer needed here as data is fetched on splash screen
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.fetchTreks();
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        onEndDrawerChanged: (isOpened) {
          if (!isOpened) {
            controller.handleDrawerClose();
          }
        },
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _isSearching
                ? TextField(
              key: const ValueKey('SearchBar'),
              controller: _searchController,
              // ✅ EDITED: autofocus is now conditional to prevent keyboard on app start
              autofocus: _isSearching,
              decoration: const InputDecoration(
                hintText: 'Search treks or states...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onChanged: (query) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  controller.updateSearchQuery(query);
                });
              },
            )
                : Text(controller.activeFilterTitle, key: const ValueKey('Title')),
          )),
          actions: [
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: child.key == const ValueKey('search')
                      ? Tween<double>(begin: 0.75, end: 1.0).animate(anim)
                      : Tween<double>(begin: 0.85, end: 1.0).animate(anim),
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: _isSearching
                    ? const Icon(Icons.close, key: ValueKey('close'))
                    : const Icon(Icons.search, key: ValueKey('search')),
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    controller.updateSearchQuery('');
                  }
                });
              },
            ),
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  controller.onFilterDrawerOpen();
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
          ],
        ),
        drawer: CustomDrawer(),
        endDrawer: const FilterDrawer(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value != null) {
            return _buildErrorWidget(context, controller.errorMessage.value!);
          }
          if (controller.allTreks.isEmpty) {
            return const Center(child: Text("No treks are available at the moment."));
          }
          if (controller.filteredTreks.isEmpty) {
            return _buildEmptyFilterWidget();
          }
          return ListView.builder(
            itemCount: controller.filteredTreks.length,
            itemBuilder: (context, index) {
              final trek = controller.filteredTreks[index];
              return TrekCard(trek: trek);
            },
          );
        }),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text("An Error Occurred", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.fetchTreks(),
                child: const Text("Retry"),
              )
            ]
        ),
      ),
    );
  }

  Widget _buildEmptyFilterWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("No Treks Found", style: TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          const Text(
            "Try adjusting your search or filters.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.clearAllFilters();
              if (_isSearching) {
                _searchController.clear();
              }
            },
            child: const Text("Clear Filters"),
          )
        ],
      ),
    );
  }
}
