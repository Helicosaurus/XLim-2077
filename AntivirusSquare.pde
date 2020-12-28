public class AntivirusSquare extends EmptySquare {

  public AntivirusSquare() {
    super();
    _squareType = "Antivirus";
  }

  public void draw(float x, float y) {

    //Dessin du fond
    int redTint = this.calcTint(int(y), 6, 256);
    tint(redTint, 255, 255);
    imageMode(CORNER);
    image(textures.getTexture("tile_antivirus1.png"), x, y);
    noTint();

    //Dessin du logo
    //Le changement de teinte est plus modéré, les valeurs sont choisies pour rester synchronisé avec le fond
    redTint = this.calcTint(int(y), 24, 32);
    tint(255 - redTint, 255, 255);
    imageMode(CORNER);
    image(textures.getTexture("tile_antivirus2.png"), x, y);
    noTint();

  }

}
