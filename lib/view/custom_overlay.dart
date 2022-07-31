import 'package:flutter/material.dart';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class CustomOverlay extends StatefulWidget {
  const CustomOverlay({Key? key}) : super(key: key);

  @override
  State<CustomOverlay> createState() => _CustomOverlayState();
}

class _CustomOverlayState extends State<CustomOverlay> {
  Color color = const Color.fromARGB(88, 0, 0, 0);
  BoxShape shape = BoxShape.rectangle;
  int height = 100;
  int width = 100;
  bool drag = true;
  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) async {
      if (event['width'] != null) {
        width = event['width'];
        await FlutterOverlayWindow.resizeOverlay(width * 3, height * 3, drag);
      } else if (event['height'] != null) {
        height = event['height'];
        await FlutterOverlayWindow.resizeOverlay(width * 3, height * 3, drag);
      } else if (event['drag'] != null) {
        drag = event['drag'];
        setState(() {
          if (drag) {
            color = const Color.fromARGB(88, 0, 0, 0);
          } else {
            color = Colors.transparent;
          }
        });

        await FlutterOverlayWindow.resizeOverlay(width * 3, height * 3, drag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: Container(
        height: height.toDouble(),
        decoration: BoxDecoration(color: color, shape: shape),
        child: Center(
          child: Text(drag ? 'Cover' : ''),
        ),
      ),
    );
  }
}
