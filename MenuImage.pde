public class MenuImage extends MenuElement {

  private PImage _img;
  private String _path;

  public MenuImage() {
    super();
    _img  = createImage(1, 1, RGB);
    _path = "";
  }

  public MenuImage(int x, int y, int w, int h, IKey iKey, String path) {
    super(x, y, w, h, iKey);
    _img  = menuTextures.getTexture(path);
    _path = path;
  }

  private void setSource(String path) {
    _img  = menuTextures.getTexture(path);
    _path = path;
  }

  public void draw() {

    // ;)
    if (_path.equals("hoodGlitched.png") && easterEgg) {
      this.setSource("chevre.png");
    }
    else if (_path.equals("chevre.png") && !easterEgg) {
      this.setSource("hoodGlitched.png");
    }

    if (_display) { 
      imageMode(CENTER);
      image(_img, _pos.x, _pos.y, _w, _h);
    }

  }

}
