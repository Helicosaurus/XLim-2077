public class ObjectiveSquare extends EmptySquare {

  private float _xGlitch;
  private float _yGlitch;

  public ObjectiveSquare() {
    super();
    _squareType = "Objective";
    this.refreshGlitch();
  }

  private void refreshGlitch() {
    _xGlitch = constrain(randomGaussian(), -2, 2);
    _yGlitch = constrain(randomGaussian(), -2, 2);
  }

  public void draw(float x, float y) {

    int redTint = this.calcTint(int(y), 6, 256);
    tint(redTint, 255, 255);
    imageMode(CORNER);
    image(textures.getTexture("tile_empty.png"), x, y);
    noTint();

    if (frameCount % 4 == 0) {
      this.refreshGlitch();
    }

    image(textures.getTexture("tile_exit1.png"), int(x + _xGlitch), int(y + _yGlitch));
    image(textures.getTexture("tile_exit2.png"), int(x), int(y));

  }

}
