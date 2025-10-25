part of '../screens/saved_images_screen.dart';

class _SavedImagesListWidget extends StatelessWidget {
  const _SavedImagesListWidget({required this.savedImages});

  final List<CoffeeImageEntity> savedImages;

  @override
  Widget build(BuildContext context) {
    if (savedImages.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No saved images yet.'),
        ),
      );
    }

    return SliverList.builder(
      itemCount: savedImages.length,
      itemBuilder: (context, index) {
        final coffeeImage = savedImages[index];

        return Padding(
          padding: const EdgeInsets.all(8),
          child: CoffeeImageIconWidget(
            coffeeImage: coffeeImage,
            isMarkedAsSaved: true,
          ),
        );
      },
    );
  }
}
