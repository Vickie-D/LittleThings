import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:little_things_game/components/level.dart';
import 'package:little_things_game/components/npc.dart';
import 'package:little_things_game/components/player.dart';
import 'package:little_things_game/components/dialog_manager.dart';


class littleThings extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection{
  littleThings();

  late Level level;
  late final CameraComponent cam;
  late Player player;
  late Npc npc;
  late DialogManager dialogManager;

  int selectedIndex = 0;
  bool isTransitioning = false;
  List<String> hotbarItems = List.filled(10, "");
  String textOverlayed = "";
  String speaker = "";

  bool rockObtained = false;


  @override
  FutureOr<void> onLoad() async {
    player = Player();
    dialogManager = DialogManager();
    overlays.add('HealthDisplay');

    await images.loadAllImages();

    // SPAWNPOINT
    _loadLevel("start-spawn", "town-biome");

    debugMode = true;
  }

  void updateHealth(){
    overlays.remove('HealthDisplay');
    overlays.add('HealthDisplay');
  }

// hotbars
  void selectSlot(int index) {
    selectedIndex = index;
    player.itemPath = "${hotbarItems[index]}";
    overlays.remove('Hotbar');
    overlays.add('Hotbar');
  }

  void addToHotbar(String itemName) {
    for (int i = 0; i < hotbarItems.length; i++) {
      if (hotbarItems[i] == "") {
        hotbarItems[i] = itemName;
        overlays.remove('Hotbar');
        overlays.add('Hotbar');
        break;
      }
    }
  }



// Text
  void npcGetMessage(String npc) {
    final text = dialogManager.getDialog(npc);

    if (text.isEmpty) {
      overlays.remove('TextOverlay');
      return;
    }

    Future.delayed(const Duration(seconds: 5), () { 
      overlays.remove('TextOverlay'); }
    );
    
    speaker = npc;
    textOverlayed = text;
    overlays.add('TextOverlay');
  }

  void showTextOverlay(String npc, String text) {
    speaker = npc;
    textOverlayed = text;
    overlays.add('TextOverlay');
  }

  void hideTextOverlay() {
    overlays.remove('TextOverlay');
  }



// Map
  void reset() {
    final nextLevel = Level(previousMap: "start-spawn", mapName: "town-biome", player: player);
    level.removeFromParent();
    level = nextLevel;
    cam.world = level;
    add(level);

    isTransitioning = false;  }

  void loadMap(String nextMap) {
    if (isTransitioning) return;
    isTransitioning = true;

    final nextLevel = Level(previousMap: level.mapName, mapName: nextMap, player: player);
    level.removeFromParent();
    level = nextLevel;
    cam.world = level;
    add(level);

    isTransitioning = false;
  }

  void _loadLevel(String previousMap, String mapName) {
    level = Level(previousMap: previousMap, mapName: mapName, player: player);


    final windowWidth = size.x;
    final windowHeight = size.y;

    cam = CameraComponent(
      world: level,
      // viewport: FixedSizeViewport(
      //   windowWidth,
      //   windowHeight
      // ),
    );


    cam.viewfinder.anchor = Anchor.center;
    cam.viewfinder.zoom = 3;

    final x = (size.x - windowWidth) / 2;
    final y = (size.y - windowHeight) / 2;
    cam.viewport.position = Vector2(x, y);

    cam.follow(player);

    addAll([cam, level]);
  }
}