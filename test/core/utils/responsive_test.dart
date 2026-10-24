import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:softverse_kds/core/utils/responsive.dart';

void main() {
  group('AppResponsive Tests', () {
    test('getDesignSize returns correct reference sizes', () {
      // Mobile portrait -> reference Figma 390x884
      expect(
        AppResponsive.getDesignSize(const Size(390, 844)),
        equals(const Size(390, 884)),
      );
      expect(
        AppResponsive.getDesignSize(const Size(412, 915)),
        equals(const Size(390, 884)),
      );

      // Landscape phones -> 1:1 scaling
      expect(
        AppResponsive.getDesignSize(const Size(915, 412)),
        equals(const Size(915, 412)),
      );
      expect(
        AppResponsive.getDesignSize(const Size(844, 390)),
        equals(const Size(844, 390)),
      );

      // Foldable unfolded upright (780x808 -> width >= 600) -> 1:1 scaling
      expect(
        AppResponsive.getDesignSize(const Size(780, 808)),
        equals(const Size(780, 808)),
      );

      // Tablets & POS terminals -> 1:1 scaling
      expect(
        AppResponsive.getDesignSize(const Size(800, 1280)),
        equals(const Size(800, 1280)),
      );
      expect(
        AppResponsive.getDesignSize(const Size(1280, 800)),
        equals(const Size(1280, 800)),
      );
      expect(
        AppResponsive.getDesignSize(const Size(1920, 1080)),
        equals(const Size(1920, 1080)),
      );
    });

    testWidgets('Orientation and dimension predicates', (tester) async {
      // 1. Phone portrait (390x844)
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(AppResponsive.isLandscape(context), isFalse);
              expect(AppResponsive.isWide(context), isFalse);
              expect(AppResponsive.isDualPane(context), isFalse);
              expect(AppResponsive.isTabletOrLarger(context), isFalse);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // 2. Phone landscape (915x412)
      tester.view.physicalSize = const Size(915, 412);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(AppResponsive.isLandscape(context), isTrue);
              expect(AppResponsive.isWide(context), isTrue);
              expect(AppResponsive.isDualPane(context), isTrue);
              expect(AppResponsive.isTabletOrLarger(context), isTrue);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // 3. Foldable opened upright (780x808)
      tester.view.physicalSize = const Size(780, 808);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(AppResponsive.isLandscape(context), isFalse);
              expect(AppResponsive.isWide(context), isTrue);
              expect(AppResponsive.isDualPane(context), isTrue);
              expect(AppResponsive.isTabletOrLarger(context), isTrue);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // 4. 15.6" POS Display (1920x1080)
      tester.view.physicalSize = const Size(1920, 1080);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(AppResponsive.isLandscape(context), isTrue);
              expect(AppResponsive.isWide(context), isTrue);
              expect(AppResponsive.isDualPane(context), isTrue);
              expect(AppResponsive.isTabletOrLarger(context), isTrue);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    test('gridAxisCount calculations', () {
      expect(AppResponsive.gridAxisCountForWidth(400, itemWidth: 320), equals(1));
      expect(AppResponsive.gridAxisCountForWidth(700, itemWidth: 320), equals(2));
      expect(AppResponsive.gridAxisCountForWidth(1100, itemWidth: 320), equals(3));
      expect(AppResponsive.gridAxisCountForWidth(1920, itemWidth: 320), equals(4));
    });

    testWidgets('ResponsiveCenter constrains max width', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveCenter(
              maxWidth: 500,
              child: SizedBox(height: 100, key: Key('child')),
            ),
          ),
        ),
      );

      final box = tester.renderObject<RenderBox>(find.byKey(const Key('child')));
      expect(box.size.width, lessThanOrEqualTo(500));
    });

    testWidgets('ResponsiveTwoPane layout builder behavior', (tester) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveTwoPane(
              breakpoint: 800,
              first: Text('Pane 1'),
              second: Text('Pane 2'),
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.text('Pane 1'), findsOneWidget);
      expect(find.text('Pane 2'), findsOneWidget);
    });
  });
}
