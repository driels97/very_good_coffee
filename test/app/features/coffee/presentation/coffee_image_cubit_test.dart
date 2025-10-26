import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';

class _MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  late CoffeeRepository mockCoffeeRepository;
  late Uint8List tBytes;
  late String tFileName;
  late CoffeeImageEntity tCoffeeImage;
  late CoffeeCubit cubit;

  setUp(() {
    mockCoffeeRepository = _MockCoffeeRepository();

    tFileName = 'test.png';
    tBytes = Uint8List.fromList([5, 6, 8, 2, 1, 2]);
    tCoffeeImage = CoffeeImageModel(fileName: tFileName, bytes: tBytes);

    cubit = CoffeeCubit(
      coffeeRepository: mockCoffeeRepository,
    );
  });

  group(
    'CoffeeImageCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, CoffeeInitial());
      });

      blocTest<CoffeeCubit, CoffeeState>(
        'Gets a new image and emits a loaded state',
        build: () {
          when(
            () => mockCoffeeRepository.getNewCoffeeImage(),
          ).thenAnswer(
            (_) async => Right(tCoffeeImage),
          );

          return cubit;
        },
        act: (cubit) => cubit.getNewCoffeeImage(),
        expect: () => [
          CoffeeLoading(),
          CoffeeLoaded(
            fetchedCoffeeImage: tCoffeeImage,
          ),
        ],
      );

      blocTest<CoffeeCubit, CoffeeState>(
        'Fails to get a new image and emits an error state',
        build: () {
          when(
            () => mockCoffeeRepository.getNewCoffeeImage(),
          ).thenAnswer(
            (_) async => Left(Exception()),
          );

          return cubit;
        },
        act: (cubit) => cubit.getNewCoffeeImage(),
        expect: () => [
          CoffeeLoading(),
          CoffeeError(),
        ],
      );
    },
  );
}
