import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';

class MockCoffeeRemoteDataSource extends Mock
    implements CoffeeRemoteDatasource {}

class MockCoffeeLocalDataSource extends Mock implements CoffeeLocalDatasource {}

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockCoffeeCubit extends MockCubit<CoffeeState> implements CoffeeCubit {}

class MockSavedImagesCubit extends MockCubit<SavedImagesState>
    implements SavedImagesCubit {}
