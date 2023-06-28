import 'package:ble_scan/provider/ble_scan_provider.dart';
import 'package:ble_scan/provider/rssi_slider_provider.dart';
import 'package:ble_scan/provider/rssi_switch_button_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterWidget extends ConsumerWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rssiSliderValue = ref.watch(RssiSliderProvider);
    final rssiSwitchValue = ref.watch(RssiSwitchButtonProvider);

    double alertWidth = MediaQuery.of(context).size.width;
    double alertHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
          padding:
              EdgeInsets.only(top: 24.0, right: 16.0, left: 16.0, bottom: 16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(alertWidth / 26),
              color: Colors.white),
          width: alertWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RSSI 필터',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: alertHeight / 48),
                      ),
                      CupertinoSwitch(
                          activeColor: Colors.blue[400],
                          value: rssiSwitchValue,
                          onChanged: (value) {
                            ref
                                .read(RssiSwitchButtonProvider.notifier)
                                .update((state) => value);
                          }),
                    ],
                  ),
                  Visibility(
                    visible: rssiSwitchValue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 48,
                          child:
                              Divider(color: Colors.grey[200], thickness: 1.0),
                        ),
                        Text(
                          '최소 RSSI: ${rssiSliderValue.toString()}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: alertHeight / 48),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 8.0,
                          ),
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0),
                            trackShape: CustomTrackShape(),
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 12),
                            trackHeight: 8,
                            thumbColor: Colors.white,
                            activeTrackColor: Colors.blue[400],
                          ),
                          child: Slider(
                            value: rssiSliderValue.toDouble(),
                            min: -100,
                            max: -10,
                            divisions: 90,
                            onChanged: (value) {
                              ref
                                  .read(RssiSliderProvider.notifier)
                                  .update((state) => value.toInt());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                  ),
                  SizedBox(
                    width: alertWidth,
                    height: alertHeight / 18,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            alertWidth / 26,
                          ),
                        ),
                      ),
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontSize: alertHeight / 52,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(BleDiscoverDeviceProvider).clear();
                        ref.read(BleScanStateProvider.notifier).stopScan();
                        ref
                            .read(BleDiscoverDeviceProvider.notifier)
                            .startDiscoverDevice(
                                '',
                                rssiSwitchValue == true
                                    ? rssiSliderValue
                                    : -100);

                        ref.read(BleScanStateProvider.notifier).startScan();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
