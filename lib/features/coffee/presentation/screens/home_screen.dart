import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/coffee/presentation/coffee_presentation.dart';
import 'package:very_good_coffee/features/coffee/presentation/widgets/coffee_image_icon_widget.dart';
import 'package:very_good_coffee/app/widgets/error_refresh_widget.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeAppBarTitle),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: BlocBuilder<CoffeeCubit, CoffeeState>(
              builder: (context, coffeeState) {
                if (coffeeState is CoffeeLoaded) {
                  return Column(
                    children: [
                      BlocBuilder<SavedImagesCubit, SavedImagesState>(
                        builder: (context, savedImagesState) {
                          final isMarkedAsSaved =
                              savedImagesState is SavedImagesLoaded &&
                              savedImagesState.savedImages.contains(
                                coffeeState.fetchedCoffeeImage,
                              );

                          final isWidgetDisabled =
                              savedImagesState is SavedImagesError;

                          return CoffeeImageIconWidget(
                            coffeeImage: coffeeState.fetchedCoffeeImage,
                            isMarkedAsSaved: isMarkedAsSaved,
                            isWidgetDisabled: isWidgetDisabled,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: context
                            .read<CoffeeCubit>()
                            .getNewCoffeeImage,
                        child: Text(l10n.newCoffeeButton),
                      ),
                    ],
                  );
                } else if (coffeeState is CoffeeError) {
                  return ErrorRefreshWidget(
                    errorMessage: l10n.newCoffeeImageError,
                    onRefresh: context.read<CoffeeCubit>().getNewCoffeeImage,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _goToSavedImagesScreen(context),
        child: const Icon(Icons.image_rounded),
      ),
    );
  }

  Future<void> _goToSavedImagesScreen(
    BuildContext context,
  ) async {
    unawaited(
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: context.read<SavedImagesCubit>(),
            child: const SavedImagesScreen(),
          ),
        ),
      ),
    );
  }
}
