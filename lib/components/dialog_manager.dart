import 'package:little_things_game/littleThings.dart';

class DialogLine {
  final String text;
  final bool Function() condition;

  DialogLine({
    required this.text,
    required this.condition,
  });
}

class DialogManager{
  final littleThings game;

  late final Map<String, List<DialogLine>> _dialogs;

  final Map<String, int> _indexes = {};

  DialogManager(this.game) {
    _initDialogs();
  }

  void _initDialogs() {
    _dialogs = {
      "Event": [
        DialogLine(
          text: "You unlocked the Deep Forest!",
          condition: () => game.unlockedDeepForest,
        ),
      ],
      "Master": [
        DialogLine(
          text: "Hi!!",
          condition: () => true,
        ),
        DialogLine(
          text: "Welcome to Little Town!",
          condition: () => true,
        ),
        DialogLine(
          text: "We have beautiful things around the town! We have the beautiful forest and if you're lucky enough... you can find things around.",
          condition: () => true,
        ),
        DialogLine(
          text: "Anyway! Go ahead and introduce yourself around town!",
          condition: () => true,
        ),
      ],
      "Boy": [
        DialogLine(
          text: "Ribbit!",
          condition: () => true,
        ),
        DialogLine(
          text: "Beware for trouble!",
          condition: () => true,
        ),
        DialogLine(
          text: "Give me some supplies and I might can make you something good!",
          condition: () => true,
        ),
        DialogLine(
          text: "Scavenge the forest for a stick and I will make a pickaxe with that rock of yours.",
          condition: () => game.rockObtained && !game.stickObtained,
        ),
        DialogLine(
          text: "You survived the forest?!",
          condition: () => game.unlockedDeepForest,
        ),
      ],
      "Caveman": [
      DialogLine(
        text: "I made these with my own two hands",
        condition: () => true,
      ),
      DialogLine(
        text: "Do you want a rock?",
        condition: () => !game.rockObtained,
      ),
      DialogLine(
        text: "Who knows.. that rock can do you well.",
        condition: () => true,
      ),
      DialogLine(
        text: "Goodluck on your journey soldier.",
        condition: () => true,
      ),
      ],
    };
  }


  String getDialog(String npcName) {
    if (!_dialogs.containsKey(npcName)) return "";

    _indexes[npcName] ??= 0;

    final availableDialogs = _dialogs[npcName]!
        .where((dialog) => dialog.condition())
        .toList();

    if (availableDialogs.isEmpty) return "";

    final index = _indexes[npcName]! % availableDialogs.length;

    return availableDialogs[index].text;
  }


  String nextDialog(String npcName) {
    if (!_dialogs.containsKey(npcName)) return "";

    final availableDialogs = _dialogs[npcName]!
        .where((dialog) => dialog.condition())
        .toList();

    if (availableDialogs.isEmpty) return "";

    _indexes[npcName] ??= 0;
    _indexes[npcName] = (_indexes[npcName]! + 1) % availableDialogs.length;

    return getDialog(npcName);
  }


  void resetDialog(String npcName) {
    _indexes[npcName] = 0;
  }
}