import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:keyboard_event/keyboard_event.dart';
import 'package:get_storage/get_storage.dart';

KeyboardEvent keyboardEvent = KeyboardEvent();
List<int> keysPressed = [];
List<int> assignedKeySounds = [];
int playersIndex = 0;

// Generate a list with 10 audio players, instead of generating a new player
// everytime a key is pressed (prevents audio lagging)
final AudioPlayer audioPlayer0 = AudioPlayer();
final AudioPlayer audioPlayer1 = AudioPlayer();
final AudioPlayer audioPlayer2 = AudioPlayer();
final AudioPlayer audioPlayer3 = AudioPlayer();
final AudioPlayer audioPlayer4 = AudioPlayer();
final AudioPlayer audioPlayer5 = AudioPlayer();
final AudioPlayer audioPlayer6 = AudioPlayer();
final AudioPlayer audioPlayer7 = AudioPlayer();
final AudioPlayer audioPlayer8 = AudioPlayer();
final AudioPlayer audioPlayer9 = AudioPlayer();

List<AudioPlayer> players = [
  audioPlayer0,
  audioPlayer1,
  audioPlayer2,
  audioPlayer3,
  audioPlayer4,
  audioPlayer5,
  audioPlayer6,
  audioPlayer7,
  audioPlayer8,
  audioPlayer9
];

void updateVolume(double volume) {
  for (var player in players) {
    player.setVolume(volume);
  }
}

void setupKlack(soundPack, enabled, [double volume = 1.0]) {
  updateVolume(volume);
  
  // Generate list: assign a sound file per key
  // Spacebar (scanCode 57) gets audio file 0
  int? index;
  int max = 11;
  assignedKeySounds.clear(); // reset list (on theme switch)

  if (enabled) {
    for (var i = 0; i < 300; i++) {
      index = Random().nextInt(max) + 1;
      if (i == 57) {
        index = 0;
      }
      assignedKeySounds.add(index);
    }

    keyboardEvent.cancelListening();

    keyboardEvent.startListening((keyEvent) {
      if (keyEvent.isKeyDown) {
        if (keysPressed.contains(keyEvent.scanCode)) {
          return;
        }

        playersIndex = playersIndex < 9 ? playersIndex += 1 : 0;

        keysPressed.add(keyEvent.scanCode);
        print(keyEvent.scanCode);

        final AudioPlayer player = players[playersIndex];
        player.play(AssetSource(
            'sounds/$soundPack/$soundPack${assignedKeySounds[keyEvent.scanCode].toString()}a.wav'));
      }
      if (keyEvent.isKeyUP) {
        keysPressed.remove(keyEvent.scanCode);
        print(keyEvent.scanCode);

        final AudioPlayer player = players[playersIndex];
        player.play(AssetSource(
            'sounds/$soundPack/$soundPack${assignedKeySounds[keyEvent.scanCode].toString()}b.wav'));
      }
    });
  }
}
