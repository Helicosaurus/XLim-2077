public class TeleportSquare extends EmptySquare {

  private int     _teleportId;
  private PVector _teleportDest;


  public TeleportSquare() {
    super();
    _squareType   = "Teleport";
    _teleportId   = 0;
    _teleportDest = new PVector(0, 0);
  }

  public TeleportSquare(int id, int x, int y) {
    this();
    _teleportId   = id;
    _teleportDest = new PVector(x, y);
  }

  public PVector getTeleportDest() {
    return _teleportDest;
  }

  public int getTeleportId() {
    return _teleportId;
  }

  public void draw(float x, float y) {
     
    //Fond de la case
    int redTint = this.calcTint(int(y), 6, 256);
    tint(redTint, 255, 255);
    imageMode(CORNER);
    image(textures.getTexture("tile_empty.png"), x, y);
    noTint();

    colorMode(HSB, 360, 100, 100);
    int brightTint = this.calcTint(int(_teleportId), 24, 25);
    tint((36 * 3 * _teleportId) % 360, 100, 100 - brightTint); //On change la teinte selon l'id du téléporteur [0-9] -> [0-360], avec un effet de scintillement sur la luminosité
    image(textures.getTexture("tile_teleport.png"), x, y);
    colorMode(RGB, 255, 255, 255);
    noTint();

  }

}
