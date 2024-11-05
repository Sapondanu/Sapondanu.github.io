import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("9b27a669ee5cbaf39bcc87bde08b62ec");
  Weather? _weather;
  String? _cityOrPostalCode;
  String _temperatureUnit = "metric";

  static TextStyle textStyle = GoogleFonts.montserrat(
    fontSize: 20,
    color: Colors.white70,
  );

  _fetchWeather() async {
    try {
      final weather = await _weatherService.getWeather(
        cityOrPostalCode: _cityOrPostalCode,
        unit: _temperatureUnit,
      );
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/animations/loading.json";
    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "fog":
      case "mist":
      case "smoke":
      case "dust":
      case "haze":
        return "assets/animations/cloudy.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/animations/rainy.json";
      case "thunderstorm":
        return "assets/animations/thunder.json";
      default:
        return "assets/animations/sunny.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Input field for city or postal code
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    labelText: "Enter City or Postal Code",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _cityOrPostalCode = value;
                    });
                  },
                ),
              ),
              // Dropdown for temperature unit
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[850],
                  style: TextStyle(color: Colors.white),
                  value: _temperatureUnit,
                  items: [
                    DropdownMenuItem(value: "metric", child: Text("Celsius")),
                    DropdownMenuItem(value: "imperial", child: Text("Fahrenheit")),
                    DropdownMenuItem(value: "standard", child: Text("Kelvin")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _temperatureUnit = value!;
                    });
                  },
                ),
              ),
              // Button to fetch weather data
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: const Color.fromARGB(255, 25, 94, 129),
                ),
                onPressed: _fetchWeather,
                child: Text("Get Weather"),
              ),
              const SizedBox(height: 20),
              // Display weather data
              Text(
                _weather?.cityName ?? "Loading City...",
                style: textStyle,
              ),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition), width: 300, height: 300),
              Text(
                "${_weather?.temperature.round()} °${_temperatureUnit == 'metric' ? 'C' : _temperatureUnit == 'imperial' ? 'F' : 'K'}",
                style: textStyle,
              ),
              Text(
                _weather?.mainCondition ?? "",
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
