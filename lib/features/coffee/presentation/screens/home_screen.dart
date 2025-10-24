import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/app/injection_container.dart' as injection;
import 'package:very_good_coffee/features/coffee/coffee.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => injection.dependency<CoffeeCubit>(),
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
                            Image(image: state.coffeeImage),
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 32,
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
}
