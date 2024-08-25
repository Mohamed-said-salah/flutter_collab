import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';

import '../data/models/weather_model.dart';
import '../data/repos/weath_repo.dart';

part "get_weather_at_location_state.dart";

class GetWeatherAtLocationCubit extends Cubit<GetWeatherAtLocationState> {
  GetWeatherAtLocationCubit() : super(GetWeatherAtLocationInitial());

  Future<void> getWeatherAtLocation() async {
    emit(GetWeatherAtLocationLoading());

    final result = await WeatherRepo.getWeatherAtLocation();

    result.fold((left) {
      emit(GetWeatherAtLocationState.error());
    }, (right) {
      final data = right['data'];

      emit(const GetWeatherAtLocationSuccess(WeatherModel(id: "5")));
    });
  }
}
