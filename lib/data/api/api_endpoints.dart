abstract class WeatherApi {
  static const String baseUrl = "https://api.github.com";
}

abstract class ChatApi {
  static const String baseUrl = "https://api.github.com";

  static const String getOpenOrders = baseUrl + "/orders/open";
}
