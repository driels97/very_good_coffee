import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/coffee/data/datasources/coffee_local_datasource.dart';
import 'package:very_good_coffee/features/coffee/data/datasources/coffee_remote_datasource.dart';
import 'package:very_good_coffee/features/coffee/data/repositories/coffee_repository.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/coffee_cubit.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';

class MockCoffeeRemoteDataSource extends Mock
    implements CoffeeRemoteDatasource {}

class MockCoffeeLocalDataSource extends Mock implements CoffeeLocalDatasource {}

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockCoffeeCubit extends MockCubit<CoffeeState> implements CoffeeCubit {}

class MockSavedImagesCubit extends MockCubit<SavedImagesState>
    implements SavedImagesCubit {}
