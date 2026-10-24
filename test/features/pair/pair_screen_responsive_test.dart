import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:softverse_kds/core/utils/responsive.dart';
import 'package:softverse_kds/core/utils/theme/theme.dart';
import 'package:softverse_kds/features/pair/controller/pair_controller.dart';
import 'package:softverse_kds/features/pair/views/screens/pair_screen.dart';

void main() {
  late PairController controller;

  setUp(() {
    Get.reset();
    controller = PairController();
    Get.put<PairController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildTestScreen(Size size) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: ScreenUtilInit(
        key: ValueKey('${size.width}_${size.height}'),
        designSize: AppResponsive.getDesignSize(size),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            theme: AppTheme.lightTheme,
            home: const PairScreen(),
          );
        },
      ),
    );
  }

  group('PairScreen Responsive Tests', () {
    testWidgets('Portrait phone (390x844) renders vertical flow without overflow', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestScreen(const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(find.text('Connect'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Softverse KDS'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Landscape phone (844x390) renders side-by-side layout without overflow', (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestScreen(const Size(844, 390)));
      await tester.pumpAndSettle();

      expect(find.text('Connect'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tablet/Foldable wide (1024x768) renders side-by-side layout', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestScreen(const Size(1024, 768)));
      await tester.pumpAndSettle();

      expect(find.text('Connect'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
