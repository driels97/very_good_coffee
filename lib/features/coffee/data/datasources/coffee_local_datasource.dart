import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class CoffeeLocalDatasource {
  Future<void> saveCoffeeImage({
    required String fileName,
    required Uint8List imageBytes,
  }) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final imagesDirectory = Directory('$path/images');

    if (!imagesDirectory.existsSync()) {
      await imagesDirectory.create(recursive: true);
    }

    final file = File('$path/images/$fileName');

    if (!file.existsSync()) {
      await file.writeAsBytes(imageBytes);
    }
  }

  Future<void> deleteCoffeeImage({required String fileName}) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File('$path/images/$fileName');

    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  Future<List<(String, Uint8List)>> getSavedCoffeeImages() async {
    final directory = Directory(
      (await getApplicationDocumentsDirectory()).path,
    );
    final files = directory.listSync(recursive: true);

    return files
        .whereType<File>()
        .where(
          (file) =>
              file.path.contains('/images/') && file.path.contains('_coffee'),
        )
        .map((file) => (file.path.split('/').last, file.readAsBytesSync()))
        .toList();
  }
}
