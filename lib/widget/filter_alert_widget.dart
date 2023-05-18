import 'package:flutter/material.dart';

class FilterAlertWidget {
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String defaultActionText,
    required String cancelActionText,
    required Color defaultActionColor,
    required Function(bool) onAction,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double alertWidth = MediaQuery.of(context).size.width;
        double alertHeight = MediaQuery.of(context).size.height;
        return Dialog(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(
                top: 24.0, right: 16.0, left: 16.0, bottom: 16.0),
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
                    // Text(
                    //   title,
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: alertHeight / 48),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     bottom: 16.0,
                    //   ),
                    // ),

                    Text('디바이스 이름을 입력하세요.',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: alertHeight / 48)),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 8.0, left: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(alertWidth / 26),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 24.0,
                      ),
                    ),
                    Text('RSSI값을 설정해주세요.',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: alertHeight / 48)),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                      ),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        overlayShape: SliderComponentShape.noOverlay,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12),
                        trackHeight: 8,
                        thumbColor: Colors.white,
                        activeTrackColor: Colors.blue[400],
                        inactiveTrackColor: Colors.blue,
                        overlayColor: Colors.green,
                        //showValueIndicator: ShowValueIndicator.never,
                      ),
                      child: Slider(
                        value: -30,
                        min: -100,
                        max: -30,
                        divisions: 70,
                        onChanged: (double value) {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.0),
                    ),
                    SizedBox(
                      width: alertWidth,
                      height: alertHeight / 16,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              alertWidth / 26,
                            ),
                          ),
                        ),
                        child: Text(
                          cancelActionText,
                          style: TextStyle(
                            fontSize: alertHeight / 52,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          onAction(false);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                      ),
                    ),
                    SizedBox(
                      width: alertWidth,
                      height: alertHeight / 16,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: defaultActionColor,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              alertWidth / 26,
                            ),
                          ),
                        ),
                        child: Text(
                          defaultActionText,
                          style: TextStyle(
                            fontSize: alertHeight / 52,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          onAction(true);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
