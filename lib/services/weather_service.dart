import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather({String? cityOrPostalCode, String unit = "metric"}) async {
    String url;

    if (cityOrPostalCode != null) {
      url = "https://api.openweathermap.org/data/2.5/weather?q=$cityOrPostalCode,TH&appid=$apiKey&units=$unit";
    } else {
      // Default to current location
      List pos = await getCurrentLocation();
      url = "https://api.openweathermap.org/data/2.5/weather?lat=${pos[0]}&lon=${pos[1]}&appid=$apiKey&units=$unit";
    }

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return Weather.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<List> getCurrentLocation() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return [pos.latitude, pos.longitude];
  }
}
