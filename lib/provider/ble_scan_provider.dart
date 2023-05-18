import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final BleDiscoverDeviceProvider =
    StateNotifierProvider<BleDiscoverDeviceNotifier, List<DiscoveredDevice>>(
        (ref) => BleDiscoverDeviceNotifier());

final BleScanStateProvider = StateNotifierProvider<BleScanStateNotifier, bool>(
    (ref) => BleScanStateNotifier());

final flutterReactiveBle = FlutterReactiveBle();
StreamSubscription<DiscoveredDevice>? scanStream;

class BleDiscoverDeviceNotifier extends StateNotifier<List<DiscoveredDevice>> {
  BleDiscoverDeviceNotifier() : super([]);

  void startDiscoverDevice(String searchDevice) {
    scanStream = flutterReactiveBle
        .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen(
      (device) {
        if (device.name.contains(searchDevice)) {
          //검색된 디바이스중에 searchDevice가 있으면
          if (!state.map((e) => e.id).contains(device.id)) {
            //검색된 디바이스가 id가 중복이 아니면
            state = [
              ...state,
              DiscoveredDevice(
                  id: device.id,
                  name: device.name == '' ? 'Unnamed' : device.name,
                  serviceData: device.serviceData,
                  manufacturerData: device.manufacturerData,
                  rssi: device.rssi,
                  serviceUuids: device.serviceUuids)
            ];
          } else {
            //검색된 디바이스가 리스트에 존재할경우
            state = state
                .map((e) => e.id == device.id
                    ? DiscoveredDevice(
                        id: e.id,
                        name: e.name == '' ? 'Unnamed' : e.name,
                        serviceData: device.serviceData,
                        manufacturerData: device.manufacturerData,
                        rssi: device.rssi,
                        serviceUuids: device.serviceUuids)
                    : e)
                .toList();
          }
        }
        //code for handling results
      },
      onError: (Object error) {
        print(error);
        //code for handling error
      },
    );
  }
}

class BleScanStateNotifier extends StateNotifier<bool> {
  BleScanStateNotifier() : super(true);
  void startScan() {
    state = true;
    scanStream?.resume();
  }

  void stopScan() {
    state = false;
    scanStream?.cancel();
  }
}
