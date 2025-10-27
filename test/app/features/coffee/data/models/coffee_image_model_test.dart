import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';

void main() {
  late CoffeeImageModel tCoffeeImage;

  setUp(() {
    tCoffeeImage = CoffeeImageModel(
      fileName: 'test.png',
      bytes: Uint8List.fromList([5, 6, 8, 2, 1, 2]),
    );
  });

  test('CoffeeImageModel must be a subtype of CoffeeImageEntity', () async {
    expect(tCoffeeImage, isA<CoffeeImageEntity>());
  });
}
