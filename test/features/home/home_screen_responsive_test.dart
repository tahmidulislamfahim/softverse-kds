import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:softverse_kds/core/controller/nav_shell_controller.dart';
import 'package:softverse_kds/core/models/order_card_model.dart';
import 'package:softverse_kds/core/utils/constants/colors.dart';
import 'package:softverse_kds/core/utils/responsive.dart';
import 'package:softverse_kds/core/utils/theme/theme.dart';
import 'package:softverse_kds/features/home/controller/home_controller.dart';
import 'package:softverse_kds/features/home/views/screens/home_screen.dart';

class FakeHomeController extends HomeController {
  @override
  // ignore: must_call_super
  void onInit() {
    pageController = PageController(initialPage: currentPage.value);
  }

  @override
  void onClose() {
    pageController.dispose();
  }
}

void main() {
  late FakeHomeController homeController;
  late NavShellController navController;

  setUp(() {
    Get.reset();
    navController = NavShellController();
    Get.put<NavShellController>(navController);
    homeController = FakeHomeController();
    Get.put<HomeController>(homeController);
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
            home: const HomeScreen(),
          );
        },
      ),
    );
  }

  final sampleOrders = [
    const OrderCardModel(
      orderId: '#101',
      customerName: 'Table 4',
      subtitle: '12:30:15',
      table: 'T-4',
      actionLabel: 'Paid',
      gradientColors: [AppColors.accentGreenStart, AppColors.accentGreenEnd],
      borderColor: AppColors.accentGreenBorder,
      textColor: AppColors.darkText,
      items: [
        OrderItemModel(name: 'Classic Cheeseburger', quantity: 2),
        OrderItemModel(name: 'French Fries', quantity: 1),
      ],
    ),
    const OrderCardModel(
      orderId: '#102',
      customerName: 'Takeaway - John',
      subtitle: '12:32:00',
      table: 'Takeout',
      actionLabel: 'Ongoing',
      gradientColors: [AppColors.accentOrangeStart, AppColors.accentOrangeEnd],
      borderColor: AppColors.accentOrangeBorder,
      textColor: AppColors.darkText,
      items: [
        OrderItemModel(name: 'Crispy Chicken Wings', quantity: 12),
        OrderItemModel(name: 'Coca Cola', quantity: 2),
      ],
    ),
  ];

  group('HomeScreen & OrderCarousel Responsive Tests', () {
    testWidgets('Empty orders state displays No orders message', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      homeController.orders.clear();
      homeController.remainingOrders.value = 0;

      await tester.pumpWidget(buildTestScreen(const Size(1920, 1080)));
      await tester.pumpAndSettle();

      expect(find.text('No orders'), findsOneWidget);
      expect(find.text('Remaining Orders'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Narrow phone portrait (390x844) renders PageView carousel without overflow', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      homeController.orders.assignAll(sampleOrders);
      homeController.remainingOrders.value = 2;

      await tester.pumpWidget(buildTestScreen(const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
      expect(find.text('#101'), findsOneWidget);
      expect(find.text('Classic Cheeseburger'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Landscape phone (844x390) renders grid layout without overflow', (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      homeController.orders.assignAll(sampleOrders);
      homeController.remainingOrders.value = 2;

      await tester.pumpWidget(buildTestScreen(const Size(844, 390)));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('#101'), findsOneWidget);
      expect(find.text('#102'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Foldable opened upright (780x808) renders multi-column grid without overflow', (tester) async {
      tester.view.physicalSize = const Size(780, 808);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      homeController.orders.assignAll(sampleOrders);
      homeController.remainingOrders.value = 2;

      await tester.pumpWidget(buildTestScreen(const Size(780, 808)));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('#101'), findsOneWidget);
      expect(find.text('#102'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('15.6 inch POS display (1920x1080) renders wide grid seamlessly', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      homeController.orders.assignAll(sampleOrders);
      homeController.remainingOrders.value = 2;

      await tester.pumpWidget(buildTestScreen(const Size(1920, 1080)));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('#101'), findsOneWidget);
      expect(find.text('#102'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
