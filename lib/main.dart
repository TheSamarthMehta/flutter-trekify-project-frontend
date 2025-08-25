import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trekify/controllers/states_controller.dart';
import 'package:trekify/controllers/trek_details_binding.dart';
import 'package:trekify/views/main_screen.dart';
import 'package:trekify/services/trek_service.dart';
import 'package:trekify/views/setting_screen.dart';
import 'package:trekify/views/splash_screen.dart';
import 'package:trekify/views/trek_details_screen.dart';
import 'package:trekify/controllers/trek_controller.dart';
import 'controllers/app_drawer_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/iternary_controllers.dart';
import 'controllers/wishlist_controller.dart';
import 'package:trekify/views/edit_profile_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // ✅ Register your service first
  Get.lazyPut<TrekService>(() => TrekService());
  // Get.lazyPut<OnboardingService>(() => OnboardingService());
  Get.put(AppDrawerController());
  Get.put(HomeController());
  Get.put(TrekController());
  Get.put(WishlistController());
  Get.put(StatesController());
  Get.put(ItineraryController());
  // Get.put(OnboardingController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Trekify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      // Start with a specific route
      getPages: [
        // The main route that holds our drawer and IndexedStack
        GetPage(name: '/splash', page: () => const SplashScreen()),
        // GetPage(name: '/login', page: () => const LoginScreen()),
        // GetPage(name: '/signup', page: () => const SignUpScreen()),
        // GetPage(name: '/onboarding', page: () => const OnboardingScreen()), // ✅ ADDED
        GetPage(name: '/', page: () => const MainScreen()),
        GetPage(name: '/edit-profile', page: () => const EditProfileScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(
          name: '/trek-details',
          page: () => TrekDetailsScreen(),
          binding: TrekDetailsBinding(),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }
}
