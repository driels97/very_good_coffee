import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/app/injection_container.dart' as injection;
import 'package:very_good_coffee/app/ui/app_colors.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/features/coffee/presentation/cubit/saved_images_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.kBrownCoffee);

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.inversePrimary,
        ),
        useMaterial3: true,
        colorScheme: colorScheme,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => injection.dependency<CoffeeCubit>(),
          ),
          BlocProvider(
            create: (_) => injection.dependency<SavedImagesCubit>(),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
