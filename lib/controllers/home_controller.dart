import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedDifficulty = ''.obs;
  var selectedTrekType = ''.obs;
  var selectedSeason  = ''.obs;

  void selectSeason(String season) {
    selectedSeason.value = season;
  }

  void selectDifficulty(String level) {
    selectedDifficulty.value = level;
  }

  void selectTrekType(String type) {
    selectedTrekType.value = type; // Single selection
  }
}
