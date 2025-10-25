import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/coffee/domain/entities/coffee_image_entity.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';

class SaveImageWidget extends StatelessWidget {
  const SaveImageWidget({
    required this.coffeeImage,
    required this.isMarkedAsSaved,
    this.isWidgetDisabled = false,
    super.key,
  });

  final CoffeeImageEntity coffeeImage;
  final bool isMarkedAsSaved;
  final bool isWidgetDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final saveImagesCubit = context.read<SavedImagesCubit>();

        if (!isWidgetDisabled) {
          if (isMarkedAsSaved) {
            await saveImagesCubit.deleteCoffeeImage(coffeeImage);
          } else {
            await saveImagesCubit.saveCoffeeImage(coffeeImage);
          }
        }
      },
      child: AnimatedOpacity(
        opacity: isWidgetDisabled ? 0.5 : 1.0,
        duration: Durations.medium1,
        child: isMarkedAsSaved
            ? Icon(
                Icons.favorite,
                color: Colors.red,
                size: 32,
                shadows: List.generate(
                  50,
                  (index) => const Shadow(
                    blurRadius: 2,
                  ),
                ),
              )
            : Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 32,
                shadows: List.generate(
                  50,
                  (index) => const Shadow(
                    blurRadius: 2,
                  ),
                ),
              ),
      ),
    );
  }
}
