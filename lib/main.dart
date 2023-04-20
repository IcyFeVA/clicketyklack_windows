import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'setup_klack.dart';
import 'init_system_tray.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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

  void _setSoundPack(String soundPack) {
    setState(() {
      _soundPack = soundPack;
    });

    setupKlack(_soundPack, _enabled);

    store.write('soundPack', _soundPack);
  }

  void _setEnabled(bool enabled) {
    setState(() {
      _enabled = enabled;
    });

    setupKlack(_soundPack, _enabled);

    store.write('enabled', _enabled);
  }

  @override
  void initState() {
    super.initState();

    initSystemTray(
        _soundPack ?? 'klack', _setSoundPack, _enabled ?? true, _setEnabled);

    setupKlack(_soundPack ?? 'klack', _enabled ?? true);
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
