import 'package:bloc/bloc.dart';

class CoffeeCubit extends Cubit<int> {
  CoffeeCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
