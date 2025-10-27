import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late CoffeeCubit mockCoffeeCubit;
  late SavedImagesCubit mockSavedImagesCubit;
  late Uint8List tBytes1;
  late String tFileName1;
  late CoffeeImageEntity tCoffeeImage1;
  late Uint8List tBytes2;
  late String tFileName2;
  late CoffeeImageEntity tCoffeeImage2;

  setUp(() {
    mockCoffeeCubit = MockCoffeeCubit();
    mockSavedImagesCubit = MockSavedImagesCubit();

    tFileName1 = 'test.png';
    tBytes1 = Uint8List.fromList([
      // 1x1 red pixel
      255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0,
      255, 219, 0, 67, 0, 8, 6, 6, 7, 6, 5, 8, 7, 7, 7, 9, 9, 8, 10, 12, 20, 13,
      12, 11, 11, 12, 25, 18, 19, 15, 20, 29, 26, 31, 30, 29, 26, 28, 28, 32,
      36, 46, 39, 32, 34, 44, 35, 28, 28, 40, 55, 41, 44, 48, 49, 52, 52, 52,
      31, 39, 57, 61, 56, 50, 60, 46, 51, 52, 50,
      255, 192, 0, 17, 8, 0, 1, 0, 1, 3, 1, 17, 0, 2, 17, 1, 3, 17, 1,
      255, 196, 0, 20, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      255, 196, 0, 20, 16, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      255, 218, 0, 12, 3, 1, 0, 2, 17, 3, 17, 0, 63, 0, 237, 255, 217,
    ]);
    tCoffeeImage1 = CoffeeImageModel(fileName: tFileName1, bytes: tBytes1);
    tFileName2 = 'test2.png';
    tBytes2 = Uint8List.fromList([
      // 1x1 green pixel
      255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0,
      255, 219, 0, 67, 0, 8, 6, 6, 7, 6, 5, 8, 7, 7, 7, 9, 9, 8, 10, 12, 20, 13,
      12, 11, 11, 12, 25, 18, 19, 15, 20, 29, 26, 31, 30, 29, 26, 28, 28, 32,
      36, 46, 39, 32, 34, 44, 35, 28, 28, 40, 55, 41, 44, 48, 49, 52, 52, 52,
      31, 39, 57, 61, 56, 50, 60, 46, 51, 52, 50,
      255, 192, 0, 17, 8, 0, 1, 0, 1, 3, 1, 17, 0, 2, 17, 1, 3, 17, 1,
      255, 196, 0, 20, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      255, 196, 0, 20, 16, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      255, 218, 0, 12, 3, 1, 0, 2, 17, 3, 17, 0, 63, 0, 210, 255, 217,
    ]);
    tCoffeeImage2 = CoffeeImageModel(fileName: tFileName2, bytes: tBytes2);
  });

  Future<void> buildApp(WidgetTester tester) async {
    await tester.pumpApp(
      widget: const SavedImagesScreen(),
      coffeeCubit: mockCoffeeCubit,
      savedImagesCubit: mockSavedImagesCubit,
    );
  }

  group('SavedImagesScreen tests', () {
    testWidgets(
      '''
      A CircularProgressIndicator widget 
      is rendered in saved images initial state
      ''',
      (tester) async {
        when(() => mockSavedImagesCubit.state).thenReturn(SavedImagesInitial());

        await buildApp(tester);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      '''
      A CircularProgressIndicator widget 
      is rendered in saved images loading state
      ''',
      (tester) async {
        when(() => mockSavedImagesCubit.state).thenReturn(SavedImagesLoading());

        await buildApp(tester);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'Fails to get the locally saved images and emits an error state',
      (tester) async {
        late AppLocalizations l10n;

        when(() => mockSavedImagesCubit.state).thenReturn(SavedImagesError());

        await tester.pumpApp(
          widget: Builder(
            builder: (context) {
              l10n = context.l10n;
              return const SavedImagesScreen();
            },
          ),
          coffeeCubit: mockCoffeeCubit,
          savedImagesCubit: mockSavedImagesCubit,
        );

        expect(find.byType(ErrorRefreshWidget), findsOneWidget);
        expect(find.text(l10n.getSavedCoffeeImagesError), findsOneWidget);
      },
    );

    testWidgets(
      'Gets the locally saved images and emits a loaded state',
      (tester) async {
        when(() => mockSavedImagesCubit.state).thenReturn(
          SavedImagesLoaded(
            savedImages: [
              tCoffeeImage1,
              tCoffeeImage2,
            ],
          ),
        );

        await buildApp(tester);

        expect(find.byType(CoffeeImageIconWidget), findsExactly(2));
        expect(find.byType(Image), findsExactly(2));
        expect(find.byIcon(Icons.favorite), findsExactly(2));
      },
    );
  });
}
