public class FreezeSquare extends EmptySquare {

  public FreezeSquare() {
    super();
    _squareType = "Freeze";
  }

  public FreezeSquare(boolean hasBonus) {
    this();
    _hasBonus = hasBonus;
  }

  public void draw(float x, float y) {

    int redTint = this.calcTint(int(y), 6, 256);
    tint(redTint, 255, 255);
    imageMode(CORNER);
    image(textures.getTexture("tile_empty.png"), x, y);
    noTint();
    
    image(textures.getTexture("tile_freeze.png"), x, y);

    if (_hasBonus) {
      image(textures.getTexture("tile_data.png"), x, y);
    }

  }

}
