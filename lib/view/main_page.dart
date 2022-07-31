import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool hasPremission = false;
  bool drag = true;
  int overlayWidth = 100;
  int overlayHeight = 100;

  void checkPermission() async {
    hasPremission = await FlutterOverlayWindow.isPermissionGranted();
    if (!hasPremission) {
      hasPremission = await FlutterOverlayWindow.requestPermission() ?? false;
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    FlutterOverlayWindow.overlayListener.listen((event) {
      debugPrint("$event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Width'),
            Slider(
              max: MediaQuery.of(context).size.width,
              value: overlayWidth.toDouble(),
              onChanged: (value) async {
                setState(() {
                  overlayWidth = value.toInt();
                });

                await FlutterOverlayWindow.shareData({'width': value.toInt()});
              },
            ),
            const Text('Height'),
            Slider(
              max: MediaQuery.of(context).size.height,
              value: overlayHeight.toDouble(),
              onChanged: (value) async {
                setState(() {
                  overlayHeight = value.toInt();
                });
                await FlutterOverlayWindow.shareData({'height': value.toInt()});
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () {
                    FlutterOverlayWindow.closeOverlay();
                  },
                  color: Colors.blue,
                  child: const Text('Kill overlay'),
                ),
                MaterialButton(
                  onPressed: () async {
                    drag = !drag;
                    await FlutterOverlayWindow.shareData({'drag': drag});
                    setState(() {});
                  },
                  color: Colors.blue,
                  child: Text(drag ? 'Lock Overlay' : "unlock Overlay"),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await FlutterOverlayWindow.isActive()) return;
          if (hasPremission) {
            await FlutterOverlayWindow.showOverlay(
              enableDrag: true,
              flag: OverlayFlag.defaultFlag,
              alignment: OverlayAlignment.centerLeft,
              visibility: NotificationVisibility.visibilityPrivate,
              positionGravity: PositionGravity.none,
              height: 20,
              width: 20,
            );
          } else {
            checkPermission();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
