import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final String id;

  const WeatherModel({required this.id});

  WeatherModel.fromJson(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;

    return data;
  }

  @override
  List<Object?> get props => [id];
}
