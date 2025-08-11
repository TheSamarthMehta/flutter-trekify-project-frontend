// lib/views/main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/app_drawer_controller.dart';
import 'package:trekify/views/home_screen.dart';
import 'package:trekify/views/profile_screen.dart';
import 'package:trekify/views/states_screen.dart';
import 'package:trekify/views/treks_screen.dart';
import 'package:trekify/views/wishlist_screen.dart';
import 'package:trekify/widgets/custom_drawer.dart';

class MainScreen extends GetView<AppDrawerController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const StatesScreen(),
      const TreksScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];

    // ✅ EDITED: WillPopScope now calls the new controller method.
    return WillPopScope(
      onWillPop: controller.handleBackButton,
      child: Scaffold(
        drawer: CustomDrawer(),
        body: Obx(() => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        )),
      ),
    );
  }
}
