public class WallSquare extends EmptySquare {

  public WallSquare() {
    _squareType    = "Wall";
    _topIsSolid    = true;
    _bottomIsSolid = true;
    _leftIsSolid   = true;
    _rightIsSolid  = true;
    _hasBonus      = false;
  }

  public void draw(float x, float y) {

    imageMode(CORNER);
    image(textures.getTexture("tile_wall.png"), x, y);

  }

}