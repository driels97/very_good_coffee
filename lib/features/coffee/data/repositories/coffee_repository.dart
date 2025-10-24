import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:very_good_coffee/features/coffee/data/datasources/coffee_remote_datasource.dart';
import 'package:very_good_coffee/features/coffee/domain/repositories/icoffee_repository.dart';

class CoffeeRepository implements ICoffeeRepository {
  CoffeeRepository({
    required CoffeeRemoteDatasource coffeeRemoteDatasource,
  }) : _coffeeRemoteDatasource = coffeeRemoteDatasource;

  final CoffeeRemoteDatasource _coffeeRemoteDatasource;

  @override
  Future<Either<Exception, Uint8List>> getNewCoffeeImage() async {
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
        return Right(response.bodyBytes);
      } else {
        return Left(Exception('Failed to request coffee image'));
      }
    } on Exception catch (_) {
      return Left(
        Exception('Unknown error occurred while requesting new coffee image'),
      );
    }
  }
}
