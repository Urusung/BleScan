import 'dart:async';
import 'dart:io';

import 'package:ble_scan/layout/default_layout.dart';
import 'package:ble_scan/provider/ble_scan_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BleScanScreen extends ConsumerStatefulWidget {
  const BleScanScreen({super.key});

  @override
  ConsumerState<BleScanScreen> createState() => _BleScanScreenState();
}

class _BleScanScreenState extends ConsumerState<BleScanScreen> {
  late Timer scanTimer;
  late Timer connectingTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startScan('');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoverDeviceList = ref.watch(BleDiscoverDeviceProvider);
    final isScanState = ref.watch(BleScanStateProvider);
    double deviceListWidth = MediaQuery.of(context).size.width - 16;
    double deviceListHeight = MediaQuery.of(context).size.width / 6;
    double rssiContainerWidth =
        (MediaQuery.of(context).size.width - 16) * 0.008;
    double rssiContainerHeight = (MediaQuery.of(context).size.width / 6) * 0.1;

    return DefaultLayout(
      isAppBar: true,
      isSafeArea: false,
      isOnWillPop: false,
      isAutomaticallyImplyLeading: false,
      backgroundColor: Colors.grey[200]!,
      title: 'Bluetooth Scan',
      leading: IconButton(
        icon: Icon(
          Icons.refresh_rounded,
          size: AppBar().preferredSize.height / 2,
          color: Colors.white,
        ),
        onPressed: () {
          discoverDeviceList.clear();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.filter_alt_rounded,
            size: AppBar().preferredSize.height / 2,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
      body: discoverDeviceList.isEmpty
          ? isScanState == true
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                    ),
                    Text('주변 장비 검색 중...'),
                  ],
                )
              : Padding(
                  padding:
                      EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                        Text(
                          '디바이스를 찾을 수 없습니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )
          : Padding(
              padding: EdgeInsets.only(top: 8.0, right: 8, left: 8),
              child: ListView(
                children: discoverDeviceList
                    .map(
                      (e) => Container(
                        width: deviceListWidth,
                        height: deviceListHeight,
                        margin: EdgeInsets.only(bottom: 8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(12.0),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(deviceListWidth / 30),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: deviceListHeight * 0.64,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                rssiContainerWidth / 2),
                                            color: e.rssi > -90
                                                ? Colors.blue[400]
                                                : Colors.grey[400],
                                          ),
                                          margin: EdgeInsets.all(1.0),
                                          width: rssiContainerWidth,
                                          height: rssiContainerHeight,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                rssiContainerWidth / 2),
                                            color: e.rssi > -80
                                                ? Colors.blue[400]
                                                : Colors.grey[400],
                                          ),
                                          margin: EdgeInsets.all(1.0),
                                          width: rssiContainerWidth,
                                          height: rssiContainerHeight * 1.8,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                rssiContainerWidth / 2),
                                            color: e.rssi > -70
                                                ? Colors.blue[400]
                                                : Colors.grey[400],
                                          ),
                                          margin: EdgeInsets.all(1.0),
                                          width: rssiContainerWidth,
                                          height: rssiContainerHeight * 2.8,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                rssiContainerWidth / 2),
                                            color: e.rssi > -60
                                                ? Colors.blue[400]
                                                : Colors.grey[400],
                                          ),
                                          margin: EdgeInsets.all(1.0),
                                          width: rssiContainerWidth,
                                          height: rssiContainerHeight * 3.6,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${e.rssi}db',
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                          fontSize: deviceListHeight * 0.18),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: deviceListHeight * 0.26,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    e.id,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: deviceListHeight * 0.18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  size: deviceListHeight * 0.34,
                                  color: Colors.grey[400])
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }

  void startScan(String deviceName) {
    print('startscan');
    ref
        .read(BleDiscoverDeviceProvider.notifier)
        .startDiscoverDevice(deviceName);

    ref.read(BleScanStateProvider.notifier).startScan();

    // scanTimer = Timer(Duration(seconds: 30), () {
    //   stopScan();
    // });
  }

  void stopScan() {
    print('stopscan');
    if (ref.read(BleScanStateProvider) == true) {
      ref.read(BleScanStateProvider.notifier).stopScan();
      scanTimer.cancel();
    } else {
      scanTimer.cancel();
    }
  }
}
