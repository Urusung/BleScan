import 'dart:async';

import 'package:ble_scan/layout/default_layout.dart';
import 'package:ble_scan/provider/ble_scan_provider.dart';
import 'package:ble_scan/provider/rssi_slider_provider.dart';
import 'package:ble_scan/provider/sort_button_state_provider.dart';
import 'package:ble_scan/widget/filter_widget.dart';
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
    final isSortButtonState = ref.watch(SortButtonStateProvider);

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
          Icons.filter_alt_rounded,
          size: AppBar().preferredSize.height / 2,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return FilterWidget();
              });
        },
      ),
      actions: [
        TextButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isSortButtonState == true
                    ? CupertinoIcons.sort_up
                    : CupertinoIcons.sort_down,
                size: AppBar().preferredSize.height / 2,
                color: Colors.white,
              ),
              Text(
                'RSSI',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: AppBar().preferredSize.height / 6,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          onPressed: () {
            final discoverDeviceList = ref.read(BleDiscoverDeviceProvider);

            ref
                .read(SortButtonStateProvider.notifier)
                .update((state) => !isSortButtonState);

            isSortButtonState == true
                ? discoverDeviceList.sort((a, b) => a.rssi.compareTo(b.rssi))
                : discoverDeviceList.sort((a, b) => b.rssi.compareTo(a.rssi));
          },
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
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: '검색하고 싶은 장비 이름',
                      hintStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(deviceListWidth / 30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.blue[400],
                      onRefresh: () {
                        discoverDeviceList.clear();
                        return Future.delayed(Duration(seconds: 1));
                      },
                      child: ListView(
                        children: discoverDeviceList
                            .map(
                              (e) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      deviceListWidth / 30),
                                  color: Colors.white,
                                ),
                                width: deviceListWidth,
                                height: deviceListHeight,
                                padding: EdgeInsets.all(deviceListHeight / 10),
                                margin: EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: deviceListHeight * 0.64,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          rssiContainerWidth /
                                                              2),
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          rssiContainerWidth /
                                                              2),
                                                  color: e.rssi > -80
                                                      ? Colors.blue[400]
                                                      : Colors.grey[400],
                                                ),
                                                margin: EdgeInsets.all(1.0),
                                                width: rssiContainerWidth,
                                                height:
                                                    rssiContainerHeight * 1.8,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          rssiContainerWidth /
                                                              2),
                                                  color: e.rssi > -70
                                                      ? Colors.blue[400]
                                                      : Colors.grey[400],
                                                ),
                                                margin: EdgeInsets.all(1.0),
                                                width: rssiContainerWidth,
                                                height:
                                                    rssiContainerHeight * 2.8,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          rssiContainerWidth /
                                                              2),
                                                  color: e.rssi > -60
                                                      ? Colors.blue[400]
                                                      : Colors.grey[400],
                                                ),
                                                margin: EdgeInsets.all(1.0),
                                                width: rssiContainerWidth,
                                                height:
                                                    rssiContainerHeight * 3.6,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${e.rssi}db',
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    deviceListHeight * 0.18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: deviceListWidth / 20),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
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
