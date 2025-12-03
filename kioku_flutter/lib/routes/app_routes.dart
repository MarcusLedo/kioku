import 'package:get/get.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/authentication_screen/binding/authentication_binding.dart';
import '../presentation/signup_screen/signup_screen.dart';
import '../presentation/signup_screen/binding/signup_binding.dart';
import '../presentation/homepage_screen/homepage_screen.dart';
import '../presentation/homepage_screen/binding/homepage_binding.dart';
import '../presentation/deck_listing_screen/deck_listing_screen.dart';
import '../presentation/deck_listing_screen/binding/deck_listing_binding.dart';
import '../presentation/deck_details_screen/deck_details_screen.dart';
import '../presentation/deck_details_screen/binding/deck_details_binding.dart';
import '../presentation/flashcard_study_screen/flashcard_study_screen.dart';
import '../presentation/flashcard_study_screen/binding/flashcard_study_binding.dart';
import '../presentation/account_screen/account_screen.dart';
import '../presentation/account_screen/binding/account_binding.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/profile_screen/binding/profile_binding.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/settings_screen/binding/settings_binding.dart';
import '../presentation/association_screen/association_screen.dart';
import '../presentation/association_screen/binding/association_binding.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/app_navigation_screen/binding/app_navigation_binding.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String authenticationScreen = '/authentication_screen';

  static const String signupScreen = '/signup-screen';

  static const String homepageScreen = '/homepage-screen';

  static const String deckListingScreen = '/deck-listing-screen';

  static const String deckDetailsScreen = '/deck-details-screen';

  static const String flashcardStudyScreen = '/flashcard-study-screen';

  static const String accountScreen = '/account-screen';

  static const String profileScreen = '/profile-screen';

  static const String settingsScreen = '/settings-screen';

  static const String associationScreen = '/association-screen';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/';

  static List<GetPage> pages = [
    GetPage(
      name: authenticationScreen,
      page: () => AuthenticationScreen(),
      bindings: [AuthenticationBinding()],
    ),
    GetPage(
      name: signupScreen,
      page: () => SignupScreen(),
      bindings: [SignupBinding()],
    ),
    GetPage(
      name: homepageScreen,
      page: () => const HomepageScreen(),
      bindings: [HomepageBinding()],
    ),
    GetPage(
      name: deckListingScreen,
      page: () => const DeckListingScreen(),
      bindings: [DeckListingBinding()],
    ),
    GetPage(
      name: deckDetailsScreen,
      page: () => const DeckDetailsScreen(),
      bindings: [DeckDetailsBinding()],
    ),
    GetPage(
      name: flashcardStudyScreen,
      page: () => const FlashcardStudyScreen(),
      bindings: [FlashcardStudyBinding()],
    ),
    GetPage(
      name: accountScreen,
      page: () => const AccountScreen(),
      bindings: [AccountBinding()],
    ),
    GetPage(
      name: profileScreen,
      page: () => const ProfileScreen(),
      bindings: [ProfileBinding()],
    ),
    GetPage(
      name: settingsScreen,
      page: () => const SettingsScreen(),
      bindings: [SettingsBinding()],
    ),
    GetPage(
      name: associationScreen,
      page: () => const AssociationScreen(),
      bindings: [AssociationBinding()],
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
    ),
    GetPage(
      name: initialRoute,
      page: () => AuthenticationScreen(),
      bindings: [AuthenticationBinding()],
    ),
  ];
}
