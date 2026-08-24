import 'package:flutter_test/flutter_test.dart';
import 'package:softverse_kds/core/services/main_station_client.dart';

void main() {
  test('normalizes Softverse main station URLs', () {
    expect(
      MainStationClient.normalize('192.168.0.104'),
      'http://192.168.0.104:8787',
    );
    expect(
      MainStationClient.normalize('http://192.168.0.104:9000/path'),
      'http://192.168.0.104:9000',
    );
  });
}
