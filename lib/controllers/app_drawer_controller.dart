// lib/controllers/app_drawer_controller.dart
import 'package:get/get.dart';

class AppDrawerController extends GetxController {
  final selectedIndex = 0.obs;
  // A stack to keep track of the user's navigation history.
  // It starts with the Home screen (index 0).
  final navigationStack = <int>[0].obs;

  // ✅ ADDED: A new, general-purpose navigation method.
  // This updates the stack and the selected index without affecting the drawer.
  void navigateToPage(int index) {
    // If the user is already on the target page, do nothing.
    if (navigationStack.last == index) {
      return;
    }

    // Add the new page to the history stack.
    navigationStack.add(index);
    // Update the selected index to display the new page.
    selectedIndex.value = index;
  }

  // ✅ EDITED: This method now uses the new navigateToPage method.
  // It's specifically for the drawer, so it also closes it.
  void selectPageFromDrawer(int index) {
    navigateToPage(index);
    Get.back(); // Safely closes the drawer
  }

  // This method handles all back button presses.
  Future<bool> handleBackButton() async {
    // If there is more than one page in the history, go back.
    if (navigationStack.length > 1) {
      // Remove the current page from history.
      navigationStack.removeLast();
      // Update the selected index to show the previous page.
      selectedIndex.value = navigationStack.last;
      // Return false to prevent the app from closing.
      return false;
    } else {
      // If only the Home screen is left in the history, close the app.
      return true;
    }
  }

  void reset() {
    selectedIndex.value = 0;
    navigationStack.assignAll([0]); // Reset stack on logout
  }
}
