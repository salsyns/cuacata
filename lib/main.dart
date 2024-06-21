import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'weather_service.dart';

void main() {
  Intl.defaultLocale = 'id_ID';
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Cuaca Kelompok 4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 92, 69, 72)),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _hourlyWeatherData;
  double? _uvIndex;

  Future<void> _searchWeather(BuildContext context) async {
  final location = _controller.text;
  if (location.isNotEmpty) {
    try {
      final data = await _weatherService.fetchWeather(location);
      final hourlyData = await _weatherService.fetchHourlyWeather(
        data['coord']['lat'],
        data['coord']['lon'],
      );
      final uvData = await _weatherService.fetchUVIndex(
        data['coord']['lat'],
        data['coord']['lon'],
      );

      // Memperbarui UI menggunakan setState
      setState(() {
        _weatherData = data;
        _hourlyWeatherData = hourlyData;
        _uvIndex = uvData['value'];
      });
    } catch (e) {
      // Menangani kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat menemukan lokasi.')),
      );
    }
  }
}


  String _getWeatherIconUrl(String iconCode) {
    return 'http://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  String _translateWeatherDescription(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return 'Cerah';
      case 'few clouds':
        return 'Sedikit Berawan';
      case 'scattered clouds':
        return 'Berawan Sebagian';
      case 'broken clouds':
        return 'Berawan';
      case 'overcast clouds':
        return 'Awan Mendung';
      case 'shower rain':
        return 'Hujan Gerimis';
      case 'rain':
        return 'Hujan';
      case 'thunderstorm':
        return 'Badai Petir';
      case 'snow':
        return 'Salju';
      case 'mist':
        return 'Berkabut';
      case 'light rain':
        return 'Hujan Ringan';
      case 'moderate rain':
        return 'Hujan Sedang';
      case 'heavy intensity rain':
        return 'Hujan Lebat';
      case 'very heavy rain':
        return 'Hujan Sangat Lebat';
      case 'extreme rain':
        return 'Hujan Ekstrem';
      case 'freezing rain':
        return 'Hujan Beku';
      case 'light intensity shower rain':
        return 'Hujan Gerimis Ringan';
      case 'heavy intensity shower rain':
        return 'Hujan Gerimis Lebat';
      case 'ragged shower rain':
        return 'Hujan Gerimis Acak';
      case 'light snow':
        return 'Salju Ringan';
      case 'heavy snow':
        return 'Salju Lebat';
      case 'sleet':
        return 'Hujan Es';
      case 'light shower sleet':
        return 'Hujan Es Ringan';
      case 'shower sleet':
        return 'Hujan Es';
      case 'light rain and snow':
        return 'Hujan dan Salju Ringan';
      case 'rain and snow':
        return 'Hujan dan Salju';
      case 'light shower snow':
        return 'Hujan Salju Ringan';
      case 'shower snow':
        return 'Hujan Salju';
      case 'heavy shower snow':
        return 'Hujan Salju Lebat';
      case 'smoke':
        return 'Asap';
      case 'haze':
        return 'Kabut';
      case 'sand/ dust whirls':
        return 'Puting Beliung Pasir/Debu';
      case 'fog':
        return 'Kabut Tebal';
      case 'sand':
        return 'Berpasir';
      case 'dust':
        return 'Berdebu';
      case 'volcanic ash':
        return 'Abu Vulkanikk';
      case 'squalls':
        return 'Angin Kencang';
      case 'tornado':
        return 'Tornado';
      case 'clear':
        return 'Cerah';
      case 'clouds':
        return 'Berawan';
      default:
        return description;
    }
  }

  String _getUVIndexCategory(double uvIndex) {
    if (uvIndex < 3) {
      return 'Low';
    } else if (uvIndex < 6) {
      return 'Moderate';
    } else if (uvIndex < 8) {
      return 'High';
    } else if (uvIndex < 11) {
      return 'Very High';
    } else {
      return 'Extreme';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Lokasi',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _searchWeather,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _weatherData != null
                          ? Column(
                              key: ValueKey(_weatherData),
                              children: [
                                Text(
                                  _weatherData!['name'],
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now().toLocal()), // Ubah locale disini
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Image.network(
                                  _getWeatherIconUrl(_weatherData!['weather'][0]['icon']),
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_weatherData!['main']['temp'].toStringAsFixed(0)}°C',
                                  style: TextStyle(
                                    fontSize: 64,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _translateWeatherDescription(_weatherData!['weather'][0]['description']),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Precipitation',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          '${_weatherData!['main']['humidity']}%',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'UV Index',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          _uvIndex != null
                                              ? _getUVIndexCategory(_uvIndex!)
                                              : 'Loading...', // Menampilkan kategori UV Index atau teks 'Loading...' jika data belum tersedia
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'List PerJam:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: _hourlyWeatherData != null
                                              ? _hourlyWeatherData!.take(4).map((hourly) {
                                                  return WeatherHourlyWidget(
                                                    time: DateFormat('h a ', 'id_ID').format(DateTime.parse(hourly['dt_txt']).toLocal()), // Ubah locale disini
                                                    temp: '${hourly['main']['temp'].toStringAsFixed(0)}°C   ',
                                                    iconUrl: _getWeatherIconUrl(hourly['weather'][0]['icon']),
                                                  );
                                                }).toList()
                                              : [],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherHourlyWidget extends StatelessWidget {
  final String time;
  final String temp;
  final String iconUrl;

  const WeatherHourlyWidget({
    super.key,
    required this.time,
    required this.temp,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Image.network(
          iconUrl,
          width: 50,
          height: 50,
        ),
        Text(
          temp,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
