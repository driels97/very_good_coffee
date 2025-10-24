import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class CoffeeImageEntity extends Equatable {
  const CoffeeImageEntity({
    required this.fileName,
    required this.bytes,
  });

  final String fileName;
  final Uint8List bytes;

  @override
  List<Object?> get props => [
    fileName,
    bytes,
  ];
}
