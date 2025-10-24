import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/app/injection_container.dart' as injection;
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/features/coffee/domain/entities/coffee_image_entity.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => injection.dependency<CoffeeCubit>(),
        ),
        BlocProvider(
          create: (_) => injection.dependency<SavedImagesCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appBarTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<CoffeeCubit, CoffeeState>(
              builder: (context, state) {
                if (state is CoffeeLoading) {
                  return const CircularProgressIndicator();
                } else if (state is CoffeeLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image(
                              image: Image.memory(
                                state.fetchedCoffeeImage.bytes,
                              ).image,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: saveImageWidget(
                                context,
                                coffeeImage: state.fetchedCoffeeImage,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await context
                                    .read<CoffeeCubit>()
                                    .getNewCoffeeImage();
                              },
                              child: Text(l10n.newCoffeeButton),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {},
                              child: Text(l10n.favoriteCoffeesButton),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return InkWell(
                    onTap: () async {
                      await context.read<CoffeeCubit>().getNewCoffeeImage();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          size: 48,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Try again',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget saveImageWidget(
    BuildContext context, {
    required CoffeeImageEntity coffeeImage,
  }) {
    return BlocBuilder<SavedImagesCubit, SavedImagesState>(
      buildWhen: (previous, current) {
        if (previous is SavedImagesLoaded && current is SavedImagesLoaded) {
          final wasSaved = previous.savedImages.contains(coffeeImage);
          final isSaved = current.savedImages.contains(coffeeImage);
          return !(wasSaved == isSaved);
        }

        return true;
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            final saveImagesCubit = context.read<SavedImagesCubit>();

            if (state is SavedImagesLoaded) {
              if (state.savedImages.contains(coffeeImage)) {
                await saveImagesCubit.deleteCoffeeImage(coffeeImage);
              } else {
                await saveImagesCubit.saveCoffeeImage(coffeeImage);
              }
            }
          },
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
        );
      },
    );
  }
}
