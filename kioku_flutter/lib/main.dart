import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_export.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase before running the app
  await SupabaseService.initialize();
  
  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    value,
  ) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          locale: Locale('en', ''),
          fallbackLocale: Locale('en', ''),
          title: 'Kioku',
          initialRoute: AppRoutes.initialRoute,
          getPages: AppRoutes.pages,
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
        );
      },
    );
  }
}
