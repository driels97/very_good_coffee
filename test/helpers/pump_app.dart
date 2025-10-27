import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/features/coffee/presentation/coffee_presentation.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class MockCoffeeCubit extends MockCubit<CoffeeState>
    implements CoffeeCubit {}

class MockSavedImagesCubit extends MockCubit<SavedImagesState>
    implements SavedImagesCubit {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp({
    required Widget widget,
    CoffeeCubit? coffeeCubit,
    SavedImagesCubit? savedImagesCubit,
  }) {
    return pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: coffeeCubit ?? MockCoffeeCubit(),
          ),
          BlocProvider.value(
            value: savedImagesCubit ?? MockSavedImagesCubit(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}