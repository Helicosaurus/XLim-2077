public class MenuButton extends MenuText {
  
  private color _bgColor;
  private color _strokeColor;

  public MenuButton() {
    super();
    _bgColor     = color(255);
    _strokeColor = color(0);
  }

  public MenuButton(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize, PFont font, color bgColor, color strokeColor) {
    super(x, y, w, h, iKey, label, labelColor, labelSize, font);
    _bgColor     = bgColor;
    _strokeColor = strokeColor;
  }
  //Pas de constructeur pour changer l'alignement du texte du bouton, car il doit toujours être centré

  public void setButtonColor(color newBg, color newFg) {
    _bgColor     = newBg;
    _strokeColor = newFg;
  }


  public void draw() {

    if (_display) {

      rectMode(CENTER);
      strokeWeight(2);

      //Inversion des couleurs lors du survol du bouton
      if (this.isHovered()) {
        fill(_strokeColor);
        stroke(_bgColor);
      }
      else {
        fill(_bgColor);
        stroke(_strokeColor);
      }

      rect(_pos.x, _pos.y, _w, _h); //Fond du bouton

      super.draw();

    }
    
  }

}
