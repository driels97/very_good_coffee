import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_coffee/features/coffee/domain/entities/coffee_image_entity.dart';
import 'package:very_good_coffee/features/coffee/domain/repositories/icoffee_repository.dart';

part 'saved_images_state.dart';

class SavedImagesCubit extends Cubit<SavedImagesState> {
  SavedImagesCubit({required ICoffeeRepository coffeeRepository})
    : _coffeeRepository = coffeeRepository,
      super(SavedImagesInitial()) {
    unawaited(getSavedCoffeeImages());
  }

  final ICoffeeRepository _coffeeRepository;

  Future<void> getSavedCoffeeImages() async {
    emit(SavedImagesLoading());

    final result = await _coffeeRepository.getSavedCoffeeImages();

    await result.fold(
      (exception) {
        emit(SavedImagesError(description: exception.toString()));
      },
      (savedImages) {
        emit(SavedImagesLoaded(savedImages: savedImages));
      },
    );
  }

  Future<void> saveCoffeeImage(CoffeeImageEntity coffeeImage) async {
    final currentState = state;

    if (currentState is SavedImagesLoaded) {
      final result = await _coffeeRepository.saveCoffeeImage(
        fileName: coffeeImage.fileName,
        imageBytes: coffeeImage.bytes,
      );
      await result.fold(
        (_) {},
        (savedImages) {
          emit(
            SavedImagesLoaded(
              savedImages: currentState.savedImages..add(coffeeImage),
            ),
          );
        },
      );
    }

    unawaited(getSavedCoffeeImages());
  }

  Future<void> deleteCoffeeImage(CoffeeImageEntity coffeeImage) async {
    final currentState = state;

    if (currentState is SavedImagesLoaded) {
      final result = await _coffeeRepository.deleteCoffeeImage(
        fileName: coffeeImage.fileName,
      );

      await result.fold(
        (_) {},
        (savedImages) {
          emit(
            SavedImagesLoaded(
              savedImages: currentState.savedImages..remove(coffeeImage),
            ),
          );
        },
      );
    }

    unawaited(getSavedCoffeeImages());
  }
}
