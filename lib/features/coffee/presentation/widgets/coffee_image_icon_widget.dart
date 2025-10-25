import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/coffee/domain/entities/coffee_image_entity.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';

class CoffeeImageIconWidget extends StatelessWidget {
  const CoffeeImageIconWidget({
    required this.coffeeImage,
    required this.isMarkedAsSaved,
    super.key,
    this.isWidgetDisabled = false,
  });

  final CoffeeImageEntity coffeeImage;
  final bool isMarkedAsSaved;
  final bool isWidgetDisabled;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: Image(
            image: Image.memory(
              coffeeImage.bytes,
            ).image,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
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
                child: Icon(
                  isMarkedAsSaved ? Icons.favorite : Icons.favorite_border,
                  color: isMarkedAsSaved ? Colors.red : Colors.white,
                  size: 32,
                  shadows: List.generate(
                    50,
                    (index) => const Shadow(
                      blurRadius: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
