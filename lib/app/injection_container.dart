import 'package:get_it/get_it.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/features/coffee/data/datasources/coffee_local_datasource.dart';
import 'package:very_good_coffee/features/coffee/data/datasources/coffee_remote_datasource.dart';
import 'package:very_good_coffee/features/coffee/data/repositories/coffee_repository.dart';
import 'package:very_good_coffee/features/coffee/domain/repositories/icoffee_repository.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';

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
