import 'package:flame/components.dart';
import 'track.dart';
import 'environment.dart';

class GameWorld extends Component {
  final Track track = Track();
  final Environment environment = Environment();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(track);
    await add(environment);
  }


  void updateSize(Vector2 size) {
    track.size = size;
    environment.size = size;
  }

  void setSpeed(double speed) {
    track.speed = speed;
  }
}
