import 'dart:async';
import 'dart:io';
import 'package:system_tray/system_tray.dart';

String getTrayImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.ico' : 'assets/$imageName.png';
}

String getImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.bmp' : 'assets/$imageName.png';
}

Future<void> initSystemTray(
    soundPack, setSoundPack, enabled, setEnabled, volume, setVolume) async {

  String path =
      Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png';

  final AppWindow appWindow = AppWindow();
  final SystemTray systemTray = SystemTray();

  await systemTray.initSystemTray(
    title: "system tray",
    iconPath: path,
  );

  final Menu menu = Menu();
  await menu.buildFrom([
    SubMenu(
      label: "Sound Theme",
      image: getImagePath('darts_icon'),
      children: [
        MenuItemCheckbox(
          label: 'Theme 1',
          name: 'theme1',
          checked: soundPack == 'klack',
          onClicked: (menuItem) async {
            setSoundPack('klack');

            MenuItemCheckbox? theme1 =
                menu.findItemByName<MenuItemCheckbox>("theme1");
            await theme1?.setCheck(true);

            MenuItemCheckbox? theme2 =
                menu.findItemByName<MenuItemCheckbox>("theme2");
            await theme2?.setCheck(false);
          },
        ),
        MenuItemCheckbox(
          label: 'Theme 2',
          name: 'theme2',
          checked: soundPack == 'cream',
          onClicked: (menuItem) async {
            setSoundPack('cream');

            MenuItemCheckbox? theme1 =
                menu.findItemByName<MenuItemCheckbox>("theme1");
            await theme1?.setCheck(false);

            MenuItemCheckbox? theme2 =
                menu.findItemByName<MenuItemCheckbox>("theme2");
            await theme2?.setCheck(true);
          },
        ),
      ],
    ),
    MenuSeparator(),
    MenuItemCheckbox(
      label: 'Play Sounds',
      name: 'enabled',
      checked: enabled,
      onClicked: (menuItem) async {
        MenuItemCheckbox? enabled =
            menu.findItemByName<MenuItemCheckbox>("enabled");
        await enabled?.setCheck(!enabled.checked);

        setEnabled(enabled?.checked);
      },
    ),
    MenuSeparator(),
    SubMenu(
      label: "Volume",
      image: getImagePath('volume_icon'),
      children: [
        MenuItemCheckbox(
          label: 'Mute',
          name: 'mute',
          checked: volume == 0.0,
          onClicked: (menuItem) async {
            if (volume == 0.0) {
              setVolume(1.0);
              await menuItem.setCheck(false);
            } else {
              setVolume(0.0);
              await menuItem.setCheck(true);
            }
          },
        ),
        MenuItemLabel(
          label: '25%',
          onClicked: (menuItem) {
            setVolume(0.25);
          },
        ),
        MenuItemLabel(
          label: '50%',
          onClicked: (menuItem) {
            setVolume(0.5);
          },
        ),
        MenuItemLabel(
          label: '75%',
          onClicked: (menuItem) {
            setVolume(0.75);
          },
        ),
        MenuItemLabel(
          label: '100%',
          onClicked: (menuItem) {
            setVolume(1.0);
          },
        ),
      ],
    ),
    MenuSeparator(),
    MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
  ]);

  await systemTray.setContextMenu(menu);

  systemTray.registerSystemTrayEventHandler((eventName) {
    if (eventName == kSystemTrayEventClick) {
      //Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
      systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventRightClick) {
      //Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
      systemTray.popUpContextMenu();
    }
  });
}
