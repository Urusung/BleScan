import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final IconButton? leading;
  final bool isAppBar;
  final bool isSafeArea;
  final bool isOnWillPop;
  final bool isAutomaticallyImplyLeading;
  final Color backgroundColor;
  const DefaultLayout({
    required this.title,
    required this.body,
    required this.isAppBar,
    required this.isSafeArea,
    required this.isOnWillPop,
    required this.isAutomaticallyImplyLeading,
    required this.backgroundColor,
    this.actions,
    this.leading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: isAppBar == true
            ? AppBar(
                centerTitle: true,
                title: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppBar().preferredSize.height / 2.2),
                ),
                leading: leading,
                actions: actions,
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue[400],
                elevation: 0.0,
                automaticallyImplyLeading: isAutomaticallyImplyLeading,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              )
            : null,
        backgroundColor: backgroundColor,
        body: isSafeArea == true ? SafeArea(child: body) : body,
      ),
      onWillPop: () async {
        return isOnWillPop;
      },
    );
  }
}
