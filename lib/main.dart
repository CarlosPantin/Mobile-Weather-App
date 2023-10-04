import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = '696f7d5f01253999ec97f2696afa5a8d';
  String cityName = 'Helsinki';
  Map<String, dynamic> weatherData = {};

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  Future<void> fetchWeatherData() async {
    Uri uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: weatherData.isEmpty
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('City: $cityName'),
                  Text(
                      'Temperature: ${kelvinToCelsius(weatherData['main']['temp']).toStringAsFixed(2)}°C'),
                  Text(
                      'Description: ${weatherData['weather'][0]['description']}'),
                ],
              ),
      ),
    );
  }
}
