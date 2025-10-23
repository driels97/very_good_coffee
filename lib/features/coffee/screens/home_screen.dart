import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => CoffeeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appBarTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(l10n.newCoffeeButton),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: Text(l10n.favoriteCoffeesButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
