import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class RouteService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://router.project-osrm.org',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
    try {
      // Validate coordinates
      _validateCoordinate(start, 'start');
      _validateCoordinate(end, 'end');

      final response = await _dio.get(
        '/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}',
        queryParameters: {'overview': 'full', 'geometries': 'polyline'},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['routes'] == null || data['routes'].isEmpty) {
          throw Exception('No routes found in OSRM response');
        }
        
        final coordinates = (data['routes'][0]['geometry']['coordinates'] as List)
            .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
            .toList();

        if (coordinates.isEmpty) {
          throw Exception('Route coordinates list is empty');
        }

        return coordinates;
      }
      throw Exception('OSRM API Error: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Route request failed: ${e.message}');
    }
  }

  void _validateCoordinate(LatLng coord, String name) {
    if (coord.latitude < -90 || coord.latitude > 90) {
      throw Exception('Invalid $name latitude: ${coord.latitude}');
    }
    if (coord.longitude < -180 || coord.longitude > 180) {
      throw Exception('Invalid $name longitude: ${coord.longitude}');
    }
  }
}