import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_coffee/features/coffee/domain/entities/coffee_image_entity.dart';
import 'package:very_good_coffee/features/coffee/domain/repositories/icoffee_repository.dart';

part 'coffee_state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit({required ICoffeeRepository coffeeRepository})
    : _coffeeRepository = coffeeRepository,
      super(CoffeeInitial()) {
    unawaited(getNewCoffeeImage());
  }

  final ICoffeeRepository _coffeeRepository;

  Future<void> getNewCoffeeImage() async {
    emit(CoffeeLoading());

    final result = await _coffeeRepository.getNewCoffeeImage();

    await result.fold(
      (error) {
        emit(CoffeeError(errorDescription: error.toString()));
      },
      (coffeeImage) async {
        emit(CoffeeLoaded(fetchedCoffeeImage: coffeeImage));
      },
    );
  }
}
