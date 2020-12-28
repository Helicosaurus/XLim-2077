public class DirectionSquare extends WallSquare {

  private Direction _drawOrientation;

  //Constructeur par défaut: ne peut passer que depuis en haut
  public DirectionSquare() {
    super();
    _squareType      = "Direction";
    _topIsSolid      = false;
    _drawOrientation = Direction.UP;
  }

  public DirectionSquare(boolean hasBonus, Direction allowedDir) {
    _squareType      = "Direction";
    _hasBonus        = hasBonus;
    _drawOrientation = allowedDir;

    switch (allowedDir) {
      case NONE:
      case UP:
        _topIsSolid    = false;
      break;

      case DOWN:
        _bottomIsSolid = false;
      break;

      case LEFT:
        _leftIsSolid   = false;
      break;

      case RIGHT:
        _rightIsSolid  = false;
      break;
    }

  }

  public void draw(float x, float y) {
    
    imageMode(CORNER);

    String tmpPath = "tile_direction_up.png";

    switch (_drawOrientation) {
      case NONE:
      case UP:
        tmpPath = "tile_direction_up.png";
      break;

      case DOWN:
        tmpPath = "tile_direction_down.png";
      break;

      case LEFT:
        tmpPath = "tile_direction_left.png";
      break;

      case RIGHT:
        tmpPath = "tile_direction_right.png";
      break;
    }

    image(textures.getTexture(tmpPath), x, y);

    if (_hasBonus) {
      image(textures.getTexture("tile_data.png"), x, y);
    }

  }

}
