part of "get_weather_at_location_cubit.dart";

sealed class GetWeatherAtLocationState extends Equatable {
  const GetWeatherAtLocationState();

  factory GetWeatherAtLocationState.initial() => GetWeatherAtLocationInitial();

  factory GetWeatherAtLocationState.loading() => GetWeatherAtLocationLoading();

  factory GetWeatherAtLocationState.success(WeatherModel weatherModel) =>
      GetWeatherAtLocationSuccess(weatherModel);

  factory GetWeatherAtLocationState.error() => GetWeatherAtLocationError();

  @override
  List<Object?> get props => [];
}

final class GetWeatherAtLocationInitial extends GetWeatherAtLocationState {}

final class GetWeatherAtLocationLoading extends GetWeatherAtLocationState {}

final class GetWeatherAtLocationSuccess extends GetWeatherAtLocationState {
  final WeatherModel weatherModel;
  const GetWeatherAtLocationSuccess(this.weatherModel);

  @override
  List<Object?> get props => [weatherModel];
}

final class GetWeatherAtLocationError extends GetWeatherAtLocationState {}
