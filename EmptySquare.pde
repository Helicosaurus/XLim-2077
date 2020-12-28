public class EmptySquare {

  protected String  _squareType;

  protected boolean _topIsSolid,
                    _bottomIsSolid,
                    _leftIsSolid,
                    _rightIsSolid;

  protected boolean _hasBonus;

  public EmptySquare() {
    _squareType    = "Empty";

    _topIsSolid    = false;
    _bottomIsSolid = false;
    _leftIsSolid   = false;
    _rightIsSolid  = false;

    _hasBonus      = false;
  }

  public EmptySquare(boolean hasBonus) {
    this();
    _hasBonus = hasBonus;
  }


  public boolean isTopSolid() {
    return _topIsSolid;
  }

  public boolean isBottomSolid() {
    return _bottomIsSolid;
  }

  public boolean isLeftSolid() {
    return _leftIsSolid;
  }

  public boolean isRightSolid() {
    return _rightIsSolid;
  }

  public boolean hasBonus() {
    return _hasBonus;
  }

  public void removeBonus() {
    _hasBonus = false;
  }

  public String getSquareType() {
    return _squareType;
  }

  public PVector getTeleportDest() {
    return new PVector(0, 0);
  }

  public int getTeleportId() {
    return 0;
  }

  //Calcule une oscillation de teinte selon la hauteur de la case, sur une taille d'intervalle et avec une vitesse définies
  protected int calcTint(int y, int slowFactor, int spread) {

    int tmpTime   = max(millis() / slowFactor - y, 0);
    int tmpPeriod = tmpTime / spread; //Permet de déterminer si partie ascendante ou descendante de la période de l'oscillation

    if (tmpPeriod % 2 == 0) {
      tmpTime = spread - 1 - (tmpTime % spread);
    }
    else {
      tmpTime %= spread;
    }

    return tmpTime;

  }

  public void draw(float x, float y) {

    int redTint = this.calcTint(int(y), 6, 256);
    tint(redTint, 255, 255);

    imageMode(CORNER);
    image(textures.getTexture("tile_empty.png"), x, y);

    noTint();

    if (_hasBonus) {
      image(textures.getTexture("tile_data.png"), x, y);
    }

  }

}
