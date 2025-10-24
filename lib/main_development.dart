import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/app/injection_container.dart' as injection;
import 'package:very_good_coffee/bootstrap.dart';

Future<void> main() async {
  await injection.init();

  await bootstrap(() => const App());
}
