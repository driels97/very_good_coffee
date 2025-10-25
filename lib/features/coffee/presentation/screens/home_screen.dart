import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';
import 'package:very_good_coffee/features/coffee/presentation/screens/saved_images_screen.dart';
import 'package:very_good_coffee/features/coffee/presentation/widgets/save_image_widget.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeAppBarTitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<CoffeeCubit, CoffeeState>(
                  builder: (context, coffeeState) {
                    if (coffeeState is CoffeeLoaded) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image(
                            image: Image.memory(
                              coffeeState.fetchedCoffeeImage.bytes,
                            ).image,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child:
                                BlocBuilder<SavedImagesCubit, SavedImagesState>(
                                  builder: (context, savedImagesState) {
                                    final isMarkedAsSaved =
                                        savedImagesState is SavedImagesLoaded &&
                                        savedImagesState.savedImages.contains(
                                          coffeeState.fetchedCoffeeImage,
                                        );

                                    final isWidgetDisabled =
                                        savedImagesState is SavedImagesError;

                                    return SaveImageWidget(
                                      coffeeImage:
                                          coffeeState.fetchedCoffeeImage,
                                      isMarkedAsSaved: isMarkedAsSaved,
                                      isWidgetDisabled: isWidgetDisabled,
                                    );
                                  },
                                ),
                          ),
                        ],
                      );
                    } else if (coffeeState is CoffeeError) {
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
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            unawaited(
                              context.read<CoffeeCubit>().getNewCoffeeImage(),
                            );
                          },
                          child: Text(l10n.newCoffeeButton),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            unawaited(_goToSavedImagesScreen(context));
                          },
                          child: Text(l10n.favoriteCoffeesButton),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToSavedImagesScreen(
    BuildContext context,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<SavedImagesCubit>(),
          child: const SavedImagesScreen(),
        ),
      ),
    );

    if (context.mounted) {
      await context.read<SavedImagesCubit>().getSavedCoffeeImages();
    }
  }
}
