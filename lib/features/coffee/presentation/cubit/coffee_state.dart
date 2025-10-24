part of 'coffee_cubit.dart';

abstract class CoffeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeLoaded extends CoffeeState {
  CoffeeLoaded({
    required this.fetchedCoffeeImage,
  });

  final CoffeeImageEntity fetchedCoffeeImage;

  @override
  List<Object?> get props => [
    fetchedCoffeeImage,
  ];
}

class CoffeeError extends CoffeeState {
  CoffeeError({required this.errorDescription});

  final String errorDescription;

  @override
  List<Object?> get props => [errorDescription];
}
