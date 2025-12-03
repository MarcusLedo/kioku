import 'package:get/get.dart';

class DeckListingModel {
  Rx<String> searchQuery = ''.obs;

  RxList<Map<String, dynamic>> decks = <Map<String, dynamic>>[].obs;
}
