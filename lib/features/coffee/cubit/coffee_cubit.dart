import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'coffee_state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit() : super(CoffeeInitial());

  final _coffeeUrl = 'https://coffee.alexflipnote.dev/random.json';

  Future<void> getNewCoffeeImage() async {
    final String fileUrl;

    emit(CoffeeLoading());

    try {
      final jsonResponse = await http.get(Uri.parse(_coffeeUrl));

      if (jsonResponse.statusCode == 200) {
        final jsonData = jsonDecode(jsonResponse.body) as Map<String, dynamic>;
        fileUrl = jsonData['file'] as String;
      } else {
        throw Exception();
      }

      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        final image = Image.memory(response.bodyBytes).image;

        emit(CoffeeLoaded(coffeeImage: image));

        return;
      } else {
        throw Exception();
      }
    } on Exception catch (_) {
      throw Exception();
    }
  }
}
