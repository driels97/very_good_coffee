import 'dart:typed_data';

import 'package:dartz/dartz.dart';

// TODO(driels97): Add methods for getting local coffee images,
// add local image and remove local image`
// ignore: one_member_abstracts
abstract class ICoffeeRepository {
  Future<Either<Exception, Uint8List>> getNewCoffeeImage();
}
