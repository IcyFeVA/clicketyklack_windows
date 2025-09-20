import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'setup_klack.dart';
import 'init_system_tray.dart';
import 'package:get_storage/get_storage.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
  );
  await launchAtStartup.enable();

  runApp(
    const MyApp(),
  );

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(600, 450);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "ClicketyKlack";
    win.hide();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final store = GetStorage();
  late String? _soundPack = store.read('soundPack');
  late bool? _enabled = store.read('enabled');
  late double? _volume = store.read('volume');

  void _setSoundPack(String soundPack) {
    setState(() {
      _soundPack = soundPack;
    });

    setupKlack(_soundPack, _enabled, _volume ?? 1.0);

    store.write('soundPack', _soundPack);
  }

  void _setEnabled(bool enabled) {
    setState(() {
      _enabled = enabled;
    });

    setupKlack(_soundPack, _enabled, _volume ?? 1.0);

    store.write('enabled', _enabled);
  }

  void _setVolume(double volume) {
    setState(() {
      _volume = volume;
    });

    setupKlack(_soundPack, _enabled, _volume ?? 1.0);

    store.write('volume', _volume);
  }

  @override
  void initState() {
    super.initState();

    initSystemTray(_soundPack ?? 'klack', _setSoundPack, _enabled ?? true, _setEnabled, _volume ?? 1.0, _setVolume);

    setupKlack(_soundPack ?? 'klack', _enabled ?? true, _volume ?? 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Text("This window should never be visible. How did you do that?"),
      ),
    );
  }
}
