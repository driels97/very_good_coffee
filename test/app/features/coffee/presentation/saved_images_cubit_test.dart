import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';

class _MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  late CoffeeRepository mockCoffeeRepository;
  late Uint8List tBytes1;
  late String tFileName1;
  late CoffeeImageEntity tCoffeeImage1;
  late Uint8List tBytes2;
  late String tFileName2;
  late CoffeeImageEntity tCoffeeImage2;
  late SavedImagesCubit cubit;

  setUpAll(() {
    registerFallbackValue(Uint8List.fromList([]));
  });

  setUp(() {
    mockCoffeeRepository = _MockCoffeeRepository();

    tFileName1 = 'test.png';
    tBytes1 = Uint8List.fromList([5, 6, 8, 2, 1, 2]);
    tCoffeeImage1 = CoffeeImageModel(fileName: tFileName1, bytes: tBytes1);
    tFileName2 = 'test2.png';
    tBytes2 = Uint8List.fromList([7, 44, 56, 7, 82, 1]);
    tCoffeeImage2 = CoffeeImageModel(fileName: tFileName2, bytes: tBytes2);

    cubit = SavedImagesCubit(
      coffeeRepository: mockCoffeeRepository,
    );
  });

  group(
    'SavedImagesCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, SavedImagesInitial());
      });

      blocTest<SavedImagesCubit, SavedImagesState>(
        'Gets a new list of images and emits a loaded state',
        build: () {
          when(
            () => mockCoffeeRepository.getSavedCoffeeImages(),
          ).thenAnswer(
            (_) async => Right([tCoffeeImage1]),
          );

          return cubit;
        },
        act: (cubit) => cubit.getSavedCoffeeImages(),
        expect: () => [
          SavedImagesLoading(),
          SavedImagesLoaded(
            savedImages: [tCoffeeImage1],
          ),
        ],
      );

      blocTest<SavedImagesCubit, SavedImagesState>(
        'Fails to get a new list of images and emits an error state',
        build: () {
          when(
            () => mockCoffeeRepository.getSavedCoffeeImages(),
          ).thenAnswer(
            (_) async => Left(Exception()),
          );

          return cubit;
        },
        act: (cubit) => cubit.getSavedCoffeeImages(),
        expect: () => [
          SavedImagesLoading(),
          SavedImagesError(),
        ],
      );

      blocTest<SavedImagesCubit, SavedImagesState>(
        'Saves a coffee image emits a loaded state with it',
        build: () {
          when(
            () => mockCoffeeRepository.getSavedCoffeeImages(),
          ).thenAnswer(
            (_) async => Right([tCoffeeImage1]),
          );
          when(
            () => mockCoffeeRepository.saveCoffeeImage(
              fileName: any(named: 'fileName'),
              imageBytes: any(named: 'imageBytes'),
            ),
          ).thenAnswer(
            (_) async => const Right(unit),
          );

          return cubit;
        },
        act: (cubit) async {
          await cubit.getSavedCoffeeImages();
          await cubit.saveCoffeeImage(tCoffeeImage2);
        },
        expect: () => [
          SavedImagesLoading(),
          SavedImagesLoaded(
            savedImages: [tCoffeeImage1],
          ),
          SavedImagesLoaded(
            savedImages: [tCoffeeImage1, tCoffeeImage2],
          ),
        ],
      );

      blocTest<SavedImagesCubit, SavedImagesState>(
        'Fails to save a coffee image and emits an error state',
        build: () {
          when(
            () => mockCoffeeRepository.getSavedCoffeeImages(),
          ).thenAnswer(
            (_) async => Right([tCoffeeImage1]),
          );
          when(
            () => mockCoffeeRepository.saveCoffeeImage(
              fileName: any(named: 'fileName'),
              imageBytes: any(named: 'imageBytes'),
            ),
          ).thenAnswer(
            (_) async => Left(Exception()),
          );

          return cubit;
        },
        act: (cubit) async {
          await cubit.getSavedCoffeeImages();
          await cubit.saveCoffeeImage(tCoffeeImage2);
        },
        expect: () => [
          SavedImagesLoading(),
          SavedImagesLoaded(
            savedImages: [tCoffeeImage1],
          ),
          SavedImagesLoadedSaveError(
            savedImages: [tCoffeeImage1],
          ),
        ],
      );

      blocTest<SavedImagesCubit, SavedImagesState>(
        'Deletes a coffee image emits a loaded state without it',
        build: () {
          when(
            () => mockCoffeeRepository.getSavedCoffeeImages(),
          ).thenAnswer(
            (_) async => Right([tCoffeeImage1, tCoffeeImage2]),
          );
          when(
            () => mockCoffeeRepository.deleteCoffeeImage(
              fileName: any(named: 'fileName'),
            ),
          ).thenAnswer(
            (_) async => const Right(unit),
          );

          return cubit;
        },
        act: (cubit) async {
          await cubit.getSavedCoffeeImages();
          await cubit.deleteCoffeeImage(tCoffeeImage2);
        },
        expect: () => [
          SavedImagesLoading(),
          SavedImagesLoaded(
            savedImages: [tCoffeeImage1, tCoffeeImage2],
          ),
          SavedImagesLoaded(savedImages: [tCoffeeImage1]),
        ],
      );

      blocTest<SavedImagesCubit, SavedImagesState>(
        'Fails to delete a coffee image and emits an error state',
        build: () {
          when(
            () => mockCoffeeRepository.getSavedCoffeeImages(),
          ).thenAnswer(
            (_) async => Right([tCoffeeImage1, tCoffeeImage2]),
          );
          when(
            () => mockCoffeeRepository.deleteCoffeeImage(
              fileName: any(named: 'fileName'),
            ),
          ).thenAnswer(
            (_) async => Left(Exception()),
          );

          return cubit;
        },
        act: (cubit) async {
          await cubit.getSavedCoffeeImages();
          await cubit.deleteCoffeeImage(tCoffeeImage2);
        },
        expect: () => [
          SavedImagesLoading(),
          SavedImagesLoaded(
            savedImages: [tCoffeeImage1, tCoffeeImage2],
          ),
          SavedImagesLoadedDeleteError(
            savedImages: [tCoffeeImage1, tCoffeeImage2],
          ),
        ],
      );
    },
  );
}
