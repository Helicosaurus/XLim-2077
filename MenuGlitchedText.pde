public class MenuGlitchedText extends MenuText {

  private float _xGlitch;
  private float _yGlitch;

  public MenuGlitchedText() {
    super();
  }

  public MenuGlitchedText(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize) {
    super(x, y, w, h, iKey, label, labelColor, labelSize);
  }

  public MenuGlitchedText(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize, PFont font) {
    super(x, y, w, h, iKey, label, labelColor, labelSize, font);
  }

  public MenuGlitchedText(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize, PFont font, int alignX, int alignY) {
    super(x, y, w, h, iKey, label, labelColor, labelSize, font, alignX, alignY);
  }

  public void setLabel(String newLabel) {
    _label = newLabel;
  }

  public void setLabelColor(color newColor) {
    _labelColor = newColor;
  }

  private void refreshGlitch() {
    //Décalage d'un maximum de 2 pixels depuis la position originelle, selon une répartition gaussienne
    _xGlitch = constrain(randomGaussian(), -2, 2);
    _yGlitch = constrain(randomGaussian(), -2, 2);
  }

  public void draw() {

    if (_display) {

      rectMode(CENTER);
      textAlign(_labelAlignX, _labelAlignY);
      textFont(_labelFont);
      textSize(_labelSize);

      if (frameCount % 4 == 0) {
        //On rafraîchit la position 1/4 frames pour ralentir l'animation
        this.refreshGlitch();
      }
      
      //Effet de décalage des rouges
      fill(red(_labelColor), 0, 0);
      text(_label, _pos.x + _xGlitch, _pos.y + _yGlitch);

      if (frameCount % 4 == 0) {
        this.refreshGlitch();
      }

      //Effet de décalage des cyans (vert + bleu)
      fill(0, green(_labelColor), blue(_labelColor));
      text(_label, _pos.x - _xGlitch, _pos.y - _yGlitch);

      fill(_labelColor);
      text(_label, _pos.x, _pos.y);
      
    }
    
  }

}
