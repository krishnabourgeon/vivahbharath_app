// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/custom/responsive.dart';
// import 'package:vivahbharath_app/view/onboarding_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(builder: responsiveBuilder, home: WelcomeScreen());
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/services/multi_provider_list.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // MultiProvider exposes RegisterProvider / HomeProvider to every screen.
    // ScreenUtilInit is required because Helpers.successToast (used by the
    // providers for "No internet" etc.) sizes its text with `.sp`.
    return MultiProvider(
      providers: MultiProviderList.providerList,
      child: ScreenUtilInit(
        // Same ~390pt phone the mockups are drawn for (see kDesignWidth).
        designSize: const Size(kDesignWidth, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => MaterialApp(
          builder: responsiveBuilder,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}