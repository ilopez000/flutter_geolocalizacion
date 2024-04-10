import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GeoLocationPage(),
    );
  }
}

class GeoLocationPage extends StatefulWidget {
  @override
  _GeoLocationPageState createState() => _GeoLocationPageState();
}

class _GeoLocationPageState extends State<GeoLocationPage> {
  String _location = 'Ubicación no determinada';

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Comprueba si los servicios de ubicación están habilitados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Los servicios de ubicación no están habilitados, no continuamos
      // y notificamos al usuario.
      setState(() {
        _location = 'Los servicios de ubicación están deshabilitados.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos están denegados, no continuamos y notificamos al usuario.
        setState(() {
          _location = 'El permiso de ubicación fue denegado';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados para siempre, no podemos hacer nada.
      setState(() {
        _location = 'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.';
      });
      return;
    }

    // Cuando llegamos aquí, los permisos están otorgados y podemos
    // continuar accediendo a la posición del dispositivo.
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocalización'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_location),
            ElevatedButton(
              onPressed: _determinePosition,
              child: Text('Obtener ubicación'),
            ),
          ],
        ),
      ),
    );
  }
}
