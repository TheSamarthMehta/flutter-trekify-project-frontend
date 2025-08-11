// lib/widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_drawer_controller.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final List<String> menuItems = ['Home', 'States', 'Treks', 'Wishlist', 'Profile'];
  final List<IconData> icons = [
    Icons.home,
    Icons.map,
    Icons.terrain,
    Icons.favorite_border,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.find<AppDrawerController>();

    return Drawer(
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.teal[800],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'Trekify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.white24),
            Expanded(
              child: GetBuilder<AppDrawerController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final isSelected = controller.selectedIndex.value == index;

                      return ListTile(
                        leading: Icon(
                          icons[index],
                          color: isSelected ? Colors.tealAccent : Colors.white70,
                        ),
                        title: Text(
                          menuItems[index],
                          style: TextStyle(
                            color: isSelected ? Colors.tealAccent : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          // ✅ EDITED: Calls the new method to ensure the drawer closes.
                          controller.selectPageFromDrawer(index);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
