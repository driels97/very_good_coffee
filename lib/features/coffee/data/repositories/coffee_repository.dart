import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:very_good_coffee/features/coffee/data/coffee_data.dart';
import 'package:very_good_coffee/features/coffee/domain/coffee_domain.dart';

class CoffeeRepository implements ICoffeeRepository {
  CoffeeRepository({
    required CoffeeRemoteDatasource coffeeRemoteDatasource,
    required CoffeeLocalDatasource coffeeLocalDatasource,
  }) : _coffeeRemoteDatasource = coffeeRemoteDatasource,
       _coffeeLocalDatasource = coffeeLocalDatasource;

  final CoffeeRemoteDatasource _coffeeRemoteDatasource;
  final CoffeeLocalDatasource _coffeeLocalDatasource;

  @override
  Future<Either<Exception, CoffeeImageEntity>> getNewCoffeeImage() async {
    final String fileUrl;

    try {
      final jsonResponse = await _coffeeRemoteDatasource.fetchCoffeeJson();

      if (jsonResponse.statusCode == 200) {
        final jsonData = jsonDecode(jsonResponse.body) as Map<String, dynamic>;
        fileUrl = jsonData['file'] as String;
      } else {
        return Left(Exception('Failed to request coffee json'));
      }

      final response = await _coffeeRemoteDatasource.fetchCoffeeImage(
        fileUrl: fileUrl,
      );

      if (response.statusCode == 200) {
        return Right(
          CoffeeImageModel(
            fileName: fileUrl.split('/').last,
            bytes: response.bodyBytes,
          ),
        );
      } else {
        return Left(Exception('Failed to request coffee image'));
      }
    } on Exception catch (_) {
      return Left(
        Exception('Unknown error occurred while requesting new coffee image'),
      );
    }
  }

  @override
  Future<Either<Exception, List<CoffeeImageEntity>>>
  getSavedCoffeeImages() async {
    try {
      final savedImages = await _coffeeLocalDatasource.getSavedCoffeeImages();
      final imagesList = savedImages
          .map(
            (image) => CoffeeImageModel(
              fileName: image.$1,
              bytes: image.$2,
            ),
          )
          .toList();

      return Right(imagesList);
    } on Exception catch (_) {
      return Left(
        Exception('Unknown error occurred while getting saved coffee images'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> saveCoffeeImage({
    required String fileName,
    required Uint8List imageBytes,
  }) async {
    try {
      await _coffeeLocalDatasource.saveCoffeeImage(
        fileName: fileName,
        imageBytes: imageBytes,
      );
      return const Right(unit);
    } on Exception catch (_) {
      return Left(
        Exception('Unknown error occurred while saving the coffee image'),
      );
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteCoffeeImage({
    required String fileName,
  }) async {
    try {
      await _coffeeLocalDatasource.deleteCoffeeImage(fileName: fileName);
      return const Right(unit);
    } on Exception catch (_) {
      return Left(
        Exception('Unknown error occurred while deleting the coffee image'),
      );
    }
  }
}
