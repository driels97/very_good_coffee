import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/coffee/domain/entities/coffee_image_entity.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';

class SaveImageWidget extends StatelessWidget {
  const SaveImageWidget({required this.coffeeImage, super.key});

  final CoffeeImageEntity coffeeImage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedImagesCubit, SavedImagesState>(
      builder: (context, state) {
        final isWidgetDisabled = state is SavedImagesLoadedSavingOrDeleting;

        return GestureDetector(
          onTap: () async {
            final saveImagesCubit = context.read<SavedImagesCubit>();

            if (!isWidgetDisabled && state is SavedImagesLoaded) {
              if (state.savedImages.contains(coffeeImage)) {
                await saveImagesCubit.deleteCoffeeImage(coffeeImage);
              } else {
                await saveImagesCubit.saveCoffeeImage(coffeeImage);
              }
            }
          },
          child: AnimatedOpacity(
            opacity: isWidgetDisabled ? 0.5 : 1.0,
            duration: Durations.medium1,
            child:
                state is SavedImagesLoaded &&
                    state.savedImages.contains(coffeeImage)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 32,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
        );
      },
    );
  }
}
