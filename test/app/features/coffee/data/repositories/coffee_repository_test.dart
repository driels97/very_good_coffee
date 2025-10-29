import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late CoffeeRemoteDatasource mockCoffeeRemoteDatasource;
  late CoffeeLocalDatasource mockCoffeeLocalDatasource;
  late CoffeeRepository tRepository;
  late Uint8List tBytes;
  late String tFileName;
  late CoffeeImageEntity tCoffeeImage;

  setUp(() {
    mockCoffeeLocalDatasource = MockCoffeeLocalDataSource();
    mockCoffeeRemoteDatasource = MockCoffeeRemoteDataSource();
    tBytes = Uint8List.fromList([5, 6, 8, 2, 1, 2]);
    tFileName = 'test.png';
    tCoffeeImage = CoffeeImageModel(fileName: tFileName, bytes: tBytes);
    tRepository = CoffeeRepository(
      coffeeRemoteDatasource: mockCoffeeRemoteDatasource,
      coffeeLocalDatasource: mockCoffeeLocalDatasource,
    );
  });

  group('Coffee Respository tests', () {
    test('getNewCoffeeImage must return a CoffeeImageEntity', () async {
      when(
        () => mockCoffeeRemoteDatasource.fetchCoffeeImage(
          fileUrl: any(named: 'fileUrl'),
        ),
      ).thenAnswer(
        (_) async => Response.bytes(tBytes, 200),
      );

      when(
        () => mockCoffeeRemoteDatasource.fetchCoffeeJson(),
      ).thenAnswer(
        (_) async => Response('{"file":"$tFileName"}', 200),
      );

      CoffeeImageEntity? coffeeImageResult;

      final result = await tRepository.getNewCoffeeImage();

      result.fold((_) {}, (coffeeImage) {
        coffeeImageResult = coffeeImage;
      });

      verify(() => mockCoffeeRemoteDatasource.fetchCoffeeJson()).called(1);
      verify(
        () => mockCoffeeRemoteDatasource.fetchCoffeeImage(fileUrl: tFileName),
      ).called(1);
      expect(coffeeImageResult?.fileName, tFileName);
      expect(coffeeImageResult?.bytes, tBytes);
    });

    test(
      '''
        getNewCoffeeImage must return an Exception
        when fetchCoffeeImage throws it
        ''',
      () async {
        when(
          () => mockCoffeeRemoteDatasource.fetchCoffeeImage(
            fileUrl: any(named: 'fileUrl'),
          ),
        ).thenThrow(
          Exception(),
        );

        when(
          () => mockCoffeeRemoteDatasource.fetchCoffeeJson(),
        ).thenAnswer(
          (_) async => Response('{"file":"$tFileName"}', 200),
        );

        final result = await tRepository.getNewCoffeeImage();

        verify(
          () => mockCoffeeRemoteDatasource.fetchCoffeeJson(),
        ).called(1);
        verify(
          () => mockCoffeeRemoteDatasource.fetchCoffeeImage(fileUrl: tFileName),
        ).called(1);
        expect(result.isLeft(), true);
      },
    );

    test(
      '''
        getNewCoffeeImage must return an Exception
        when fetchCoffeeJson throws it
        ''',
      () async {
        when(
          () => mockCoffeeRemoteDatasource.fetchCoffeeImage(
            fileUrl: any(named: 'fileUrl'),
          ),
        ).thenAnswer(
          (_) async => Response.bytes(tBytes, 200),
        );

        when(
          () => mockCoffeeRemoteDatasource.fetchCoffeeJson(),
        ).thenThrow(
          Exception(),
        );

        final result = await tRepository.getNewCoffeeImage();

        verify(
          () => mockCoffeeRemoteDatasource.fetchCoffeeJson(),
        ).called(1);
        verifyNever(
          () => mockCoffeeRemoteDatasource.fetchCoffeeImage(fileUrl: tFileName),
        );
        expect(result.isLeft(), true);
      },
    );

    test(
      'getSavedCoffeeImages must return a list of CoffeeImageEntities',
      () async {
        when(
          () => mockCoffeeLocalDatasource.getSavedCoffeeImages(),
        ).thenAnswer(
          (_) async => [(fileName: tFileName, bytes: tBytes)],
        );

        List<CoffeeImageEntity>? coffeeImagesResult;

        final result = await tRepository.getSavedCoffeeImages();

        result.fold((_) {}, (coffeeImages) {
          coffeeImagesResult = coffeeImages;
        });

        verify(
          () => mockCoffeeLocalDatasource.getSavedCoffeeImages(),
        ).called(1);
        expect(coffeeImagesResult, [tCoffeeImage]);
      },
    );

    test(
      '''
        getSavedCoffeeImages must return an Exception
        when it is thrown
        ''',
      () async {
        when(
          () => mockCoffeeLocalDatasource.getSavedCoffeeImages(),
        ).thenThrow(
          Exception(),
        );

        final result = await tRepository.getSavedCoffeeImages();
        verify(
          () => mockCoffeeLocalDatasource.getSavedCoffeeImages(),
        ).called(1);
        expect(result.isLeft(), true);
      },
    );

    test('saveCoffeeImage must return unit', () async {
      when(
        () => mockCoffeeLocalDatasource.saveCoffeeImage(
          fileName: tFileName,
          imageBytes: tBytes,
        ),
      ).thenAnswer(
        (_) async {},
      );

      final result = await tRepository.saveCoffeeImage(
        fileName: tFileName,
        imageBytes: tBytes,
      );

      verify(
        () => mockCoffeeLocalDatasource.saveCoffeeImage(
          fileName: tFileName,
          imageBytes: tBytes,
        ),
      ).called(1);
      expect(result.isRight(), true);
    });

    test(
      'saveCoffeeImage must return an Exception when it is thrown',
      () async {
        when(
          () => mockCoffeeLocalDatasource.saveCoffeeImage(
            fileName: tFileName,
            imageBytes: tBytes,
          ),
        ).thenThrow(Exception());

        final result = await tRepository.saveCoffeeImage(
          fileName: tFileName,
          imageBytes: tBytes,
        );

        verify(
          () => mockCoffeeLocalDatasource.saveCoffeeImage(
            fileName: tFileName,
            imageBytes: tBytes,
          ),
        ).called(1);
        expect(result.isLeft(), true);
      },
    );

    test('deleteCoffeeImage must return unit', () async {
      when(
        () => mockCoffeeLocalDatasource.deleteCoffeeImage(
          fileName: tFileName,
        ),
      ).thenAnswer(
        (_) async {},
      );

      final result = await tRepository.deleteCoffeeImage(
        fileName: tFileName,
      );

      verify(
        () => mockCoffeeLocalDatasource.deleteCoffeeImage(
          fileName: tFileName,
        ),
      ).called(1);
      expect(result.isRight(), true);
    });

    test(
      'deleteCoffeeImage must return an Exception when it is thrown',
      () async {
        when(
          () => mockCoffeeLocalDatasource.deleteCoffeeImage(
            fileName: tFileName,
          ),
        ).thenThrow(Exception());

        final result = await tRepository.deleteCoffeeImage(
          fileName: tFileName,
        );

        verify(
          () => mockCoffeeLocalDatasource.deleteCoffeeImage(
            fileName: tFileName,
          ),
        ).called(1);
        expect(result.isLeft(), true);
      },
    );
  });
}
