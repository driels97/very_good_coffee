import 'package:http/http.dart';

class CoffeeRemoteDatasource {
  final _coffeeUrl = 'https://coffee.alexflipnote.dev/random.json';

  Future<Response> fetchCoffeeJson() {
    return get(Uri.parse(_coffeeUrl));
  }

  Future<Response> fetchCoffeeImage({required String fileUrl}) async {
    return get(Uri.parse(fileUrl));
  }
}
