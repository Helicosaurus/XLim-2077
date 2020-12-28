//Similaire à MenuText
//Permet de définir un rectangle dans lequel le texte est contenu

public class MenuTextArea extends MenuText {

  public MenuTextArea() {
    super();
  }

  public MenuTextArea(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize) {
    super(x, y, w, h, iKey, label, labelColor, labelSize);
  }

  public MenuTextArea(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize, PFont font) {
    super(x, y, w, h, iKey, label, labelColor, labelSize, font);
  }

  public MenuTextArea(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize, PFont font, int alignX, int alignY) {
    super(x, y, w, h, iKey, label, labelColor, labelSize, font, alignX, alignY);
  }

  public void draw() {

    if (_display) {

      rectMode(CORNER);
      fill(_labelColor);
      textAlign(_labelAlignX, _labelAlignY);
      textFont(_labelFont);
      textSize(_labelSize);

      text(_label, _pos.x, _pos.y, _w, _h);
      
    }
    
  }

}
