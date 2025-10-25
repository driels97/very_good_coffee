import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/coffee/domain/entities/coffee_image_entity.dart';
import 'package:very_good_coffee/features/coffee/presentation/coffee_presentation.dart';
import 'package:very_good_coffee/features/coffee/presentation/widgets/coffee_image_icon_widget.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

part '../widgets/saved_images_list_widget.dart';

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
          BlocBuilder<SavedImagesCubit, SavedImagesState>(
            builder: (context, state) {
              if (state is SavedImagesLoaded) {
                return _SavedImagesListWidget(savedImages: state.savedImages);
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
        ],
      ),
    );
  }
}
