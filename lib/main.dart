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
  String apiKey =
      '696f7d5f01253999ec97f2696afa5a8d'; // Replace with your actual API key
  String cityName = 'New York'; // Default city
  Map<String, dynamic> weatherData = {};
  bool isLoading = false;

  TextEditingController cityController = TextEditingController();

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  Future<void> fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    Uri uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: 'Enter City Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cityName = cityController.text;
                    });
                    fetchWeatherData();
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : weatherData.isEmpty
                      ? Text('Enter a city and submit to fetch weather data.')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              cityName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${kelvinToCelsius(weatherData['main']['temp']).toStringAsFixed(2)}°C',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              weatherData['weather'][0]['description'],
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
