import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:flutter/material.dart';

String getTrayImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.ico' : 'assets/$imageName.png';
}

String getImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.bmp' : 'assets/$imageName.png';
}

Future<void> initSystemTray(_soundPack, _setSoundPack) async {
  final soundPack = _soundPack;
  final setSoundPack = _setSoundPack;

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
      label: 'Disable',
      name: 'disable',
      checked: false,
      onClicked: (menuItem) async {
        MenuItemCheckbox? disable =
            menu.findItemByName<MenuItemCheckbox>("disable");
        await disable?.setCheck(!disable.checked);
      },
    ),
    MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
  ]);

  await systemTray.setContextMenu(menu);

  systemTray.registerSystemTrayEventHandler((eventName) {
    if (eventName == kSystemTrayEventClick) {
      Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventRightClick) {
      Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
    }
  });
}
