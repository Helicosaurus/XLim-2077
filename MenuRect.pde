public class MenuRect extends MenuElement {

  private color _bgColor;
  private color _strokeColor;
  private int   _alpha;

  public MenuRect() {
    super();
    _bgColor     = color(255);
    _strokeColor = color(0);
  }

  public MenuRect(int x, int y, int w, int h, IKey iKey, color bgColor, color strokeColor) {
    super(x, y, w, h, iKey);
    _bgColor     = bgColor;
    _strokeColor = strokeColor;
    _alpha       = 1;
  }

  public MenuRect(int x, int y, int w, int h, IKey iKey, color bgColor, color strokeColor, int alpha) {
    this(x, y, w, h, iKey, bgColor, strokeColor);
    _alpha = alpha;
  }

  public void setButtonColor(color newBg, color newFg) {
    _bgColor     = newBg;
    _strokeColor = newFg;
  }


  public void draw() {

    if (_display) {

      rectMode(CENTER);
      strokeWeight(2);
      fill(_bgColor, _alpha);
      stroke(_strokeColor, _alpha);
      rect(_pos.x, _pos.y, _w, _h); //Fond du bouton

    }
    
  }

}
