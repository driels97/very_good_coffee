import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/app/injection_container.dart' as injection;
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';
import 'package:very_good_coffee/features/coffee/presentation/widgets/save_image_widget.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class SavedImagesScreen extends StatelessWidget {
  const SavedImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savedImagesAppBarTitle),
      ),
      body: CustomScrollView(
        slivers: [
          BlocProvider(
            create: (_) => injection.dependency<SavedImagesCubit>(),
            child: BlocBuilder<SavedImagesCubit, SavedImagesState>(
              builder: (context, state) {
                if (state is SavedImagesLoaded) {
                  if (state.savedImages.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text('No saved images yet.'),
                      ),
                    );
                  }

                  return SliverList.builder(
                    itemCount: state.savedImages.length,
                    itemBuilder: (context, index) {
                      final coffeeImage = state.savedImages[index];
                      final isMarkedAsSaved = state.savedImages.contains(
                        coffeeImage,
                      );

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
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
                                child: SaveImageWidget(
                                  coffeeImage: coffeeImage,
                                  isMarkedAsSaved: isMarkedAsSaved,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is SavedImagesError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('Error: ${state.errorDescription}'),
                    ),
                  );
                }

                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
