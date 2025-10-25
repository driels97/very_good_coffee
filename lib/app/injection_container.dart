import 'package:get_it/get_it.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';

final GetIt dependency = GetIt.instance;

Future<void> init() async {
  dependency
    ..registerFactory(
      () => CoffeeCubit(
        coffeeRepository: dependency(),
      ),
    )
    ..registerFactory(
      () => SavedImagesCubit(
        coffeeRepository: dependency(),
      ),
    )
    ..registerFactory(
      CoffeeRemoteDatasource.new,
    )
    ..registerFactory(
      CoffeeLocalDatasource.new,
    )
    ..registerFactory<ICoffeeRepository>(
      () => CoffeeRepository(
        coffeeRemoteDatasource: dependency(),
        coffeeLocalDatasource: dependency(),
      ),
    );
}
