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

class SavedImagesLoadedSaveError extends SavedImagesLoaded {
  SavedImagesLoadedSaveError({
    required super.savedImages,
  });
}

class SavedImagesLoadedDeleteError extends SavedImagesLoaded {
  SavedImagesLoadedDeleteError({
    required super.savedImages,
  });
}

class SavedImagesError extends SavedImagesState {}
