part of 'coffee_cubit.dart';

abstract class CoffeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeLoaded extends CoffeeState {
  CoffeeLoaded({
    required this.coffeeImage,
  });

  final ImageProvider<Object> coffeeImage;

  @override
  List<Object> get props => [
    coffeeImage,
  ];
}

class CoffeeError extends CoffeeState {}
