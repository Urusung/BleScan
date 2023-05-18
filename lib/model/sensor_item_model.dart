import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SensorItemModel {
  final String id;
  final String name;
  final Map<Uuid, Uint8List> serviceData;
  final List<Uuid> serviceUuids;
  final Uint8List manufacturerData;
  final int rssi;

  SensorItemModel({
    required this.id,
    required this.name,
    required this.serviceData,
    required this.manufacturerData,
    required this.rssi,
    required this.serviceUuids,
  });
}
