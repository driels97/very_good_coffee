import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_coffee/features/coffee/domain/coffee_domain.dart';

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
      (_) {
        emit(
          SavedImagesError(),
        );
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
        (_) {
          emit(
            SavedImagesLoadedSaveError(
              savedImages: currentState.savedImages,
            ),
          );
        },
        (_) {
          emit(
            SavedImagesLoaded(
              savedImages: [...currentState.savedImages, coffeeImage],
            ),
          );
        },
      );
    }
  }

  Future<void> deleteCoffeeImage(CoffeeImageEntity coffeeImage) async {
    final currentState = state;

    if (currentState is SavedImagesLoaded) {
      final result = await _coffeeRepository.deleteCoffeeImage(
        fileName: coffeeImage.fileName,
      );

      await result.fold(
        (_) {
          emit(
            SavedImagesLoadedDeleteError(
              savedImages: currentState.savedImages,
            ),
          );
        },
        (_) {
          final newList = List<CoffeeImageEntity>.from(currentState.savedImages)
            ..remove(coffeeImage);

          emit(
            SavedImagesLoaded(
              savedImages: newList,
            ),
          );
        },
      );
    }
  }
}
