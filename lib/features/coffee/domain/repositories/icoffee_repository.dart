import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:very_good_coffee/features/coffee/domain/entities/coffee_image_entity.dart';

abstract class ICoffeeRepository {
  Future<Either<Exception, CoffeeImageEntity>> getNewCoffeeImage();
  Future<Either<Exception, List<CoffeeImageEntity>>> getSavedCoffeeImages();
  Future<Either<Exception, Unit>> saveCoffeeImage({
    required String fileName,
    required Uint8List imageBytes,
  });
  Future<Either<Exception, Unit>> deleteCoffeeImage({required String fileName});
}
