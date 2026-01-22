import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modern_animated_loader/flutter_animated_loader.dart';
import 'package:http/http.dart' as http;

import 'package:herodex3000/core/services/location_service.dart';

class SimpleWeatherBox extends StatefulWidget {
  final LocationService locationService;

  const SimpleWeatherBox({super.key, required this.locationService});

  @override
  State<SimpleWeatherBox> createState() => _SimpleWeatherBoxState();
}

class _SimpleWeatherBoxState extends State<SimpleWeatherBox> {
  late Future<_WeatherNow> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  Future<_WeatherNow> _load() async {
    final pos = await widget.locationService.getCurrentPosition();

    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': pos.latitude.toString(),
      'longitude': pos.longitude.toString(),
      'current': 'temperature_2m,weather_code',
      'timezone': 'auto',
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Open-Meteo error: ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>;

    final temp = (current['temperature_2m'] as num).toDouble();
    final code = (current['weather_code'] as num).toInt();

    return _WeatherNow(tempC: temp, code: code);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _refresh,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder<_WeatherNow>(
            future: _future,
            builder: (context, snap) {
              // Laddar
              if (snap.connectionState != ConnectionState.done) {
                return Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: FlutterAnimatedLoader.arcTrio(
                        color: cs.primary,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Text(
                    //   'Hämtar väder… ',
                    //   style: TextStyle(color: cs.onSurface.withValues(alpha:0.8)),
                    // ),
                  ],
                );
              }

              // Fel
              if (snap.hasError) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kunde inte hämta väder',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.85),
                      ),
                    ),
                    Icon(Icons.refresh, color: cs.primary),
                  ],
                );
              }

              // Data
              final w = snap.data!;
              final desc = weatherCodeToSv(w.code);
              final tempText = w.tempC.isFinite
                  ? '${w.tempC.toStringAsFixed(0)}°C'
                  : '—°C';

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Väder just nu',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$tempText • $desc',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.refresh, size: 18, color: cs.primary),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  //https://open-meteo.com/en/docs#weathercode
  String weatherCodeToSv(int code) {
    switch (code) {
      case 0:
        return 'Klart';

      case 1:
        return 'Mestadels klart';
      case 2:
        return 'Delvis molnigt';
      case 3:
        return 'Mulet';

      case 45:
        return 'Dimma';
      case 48:
        return 'Rimfrost-dimma';

      case 51:
        return 'Lätt duggregn';
      case 53:
        return 'Måttligt duggregn';
      case 55:
        return 'Kraftigt duggregn';

      case 56:
        return 'Lätt underkylt duggregn';
      case 57:
        return 'Kraftigt underkylt duggregn';

      case 61:
        return 'Lätt regn';
      case 63:
        return 'Måttligt regn';
      case 65:
        return 'Kraftigt regn';

      case 66:
        return 'Lätt underkylt regn';
      case 67:
        return 'Kraftigt underkylt regn';

      case 71:
        return 'Lätt snöfall';
      case 73:
        return 'Måttligt snöfall';
      case 75:
        return 'Kraftigt snöfall';

      case 77:
        return 'Snökorn';

      case 80:
        return 'Lätta regnskurar';
      case 81:
        return 'Måttliga regnskurar';
      case 82:
        return 'Kraftiga regnskurar';

      case 85:
        return 'Lätta snöbyar';
      case 86:
        return 'Kraftiga snöbyar';

      case 95:
        return 'Åska';

      case 96:
        return 'Åska med lätt hagel';
      case 99:
        return 'Åska med kraftigt hagel';

      default:
        return 'Okänt väder';
    }
  }
}

class _WeatherNow {
  final double tempC;
  final int code;
  _WeatherNow({required this.tempC, required this.code});
}
