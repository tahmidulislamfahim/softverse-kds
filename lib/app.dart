import 'core/utils/responsive.dart';
import 'package:softverse_kds/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'core/bindings/controller_binder.dart';
import 'core/services/storage_service.dart';
import 'core/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        final screenSize = MediaQuery.sizeOf(context);
        final designSize = AppResponsive.getDesignSize(screenSize);

        return ScreenUtilInit(
          key: ValueKey('${designSize.width}_${designSize.height}'),
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return ToastificationWrapper(
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: AppRoute.getSplashScreen(),
                getPages: AppRoute.routes,
                initialBinding: ControllerBinder(),
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: _initialThemeMode(),
              ),
            );
          },
        );
      },
    );
  }

  ThemeMode _initialThemeMode() {
    final saved = StorageService.themeMode;
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
