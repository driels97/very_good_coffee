part of 'saved_images_cubit.dart';

abstract class SavedImagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedImagesInitial extends SavedImagesState {}

class SavedImagesLoading extends SavedImagesState {}

class SavedImagesLoaded extends SavedImagesState {
  SavedImagesLoaded({
    required this.savedImages,
  });

  final List<CoffeeImageEntity> savedImages;

  @override
  List<Object?> get props => [savedImages];
}

class SavedImagesLoadedSavingOrDeleting extends SavedImagesLoaded {
  SavedImagesLoadedSavingOrDeleting({
    required super.savedImages,
  });
}

class SavedImagesLoadedSaveError extends SavedImagesLoaded {
  SavedImagesLoadedSaveError({
    required super.savedImages,
    required this.errorDescription,
  });

  final String errorDescription;

  @override
  List<Object?> get props => [savedImages, errorDescription];
}

class SavedImagesLoadedDeleteError extends SavedImagesLoaded {
  SavedImagesLoadedDeleteError({
    required super.savedImages,
    required this.errorDescription,
  });

  final String errorDescription;

  @override
  List<Object?> get props => [savedImages, errorDescription];
}

class SavedImagesError extends SavedImagesState {
  SavedImagesError({required this.errorDescription});

  final String errorDescription;

  @override
  List<Object?> get props => [errorDescription];
}
