public class MenuText extends MenuElement {
  
  protected String _label;
  protected color  _labelColor;
  protected int    _labelSize;
  protected PFont  _labelFont;
  protected int    _labelAlignX;
  protected int    _labelAlignY;

  public MenuText() {
    super();
    _label       = "";
    _labelColor  = color(255);
    _labelSize   = 12;
    _labelFont   = defaultFont;
    _labelAlignX = CENTER;
    _labelAlignY = CENTER;
  }

  public MenuText(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize) {
    super(x, y, w, h, iKey);
    _label       = label;
    _labelColor  = labelColor;
    _labelSize   = labelSize;
    _labelFont   = defaultFont;
    _labelAlignX = CENTER;
    _labelAlignY = CENTER;
  }

  public MenuText(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize, PFont font) {
    this(x, y, w, h, iKey, label, labelColor, labelSize);
    _labelFont   = font;
  }

  public MenuText(int x, int y, int w, int h, IKey iKey, String label, color labelColor, int labelSize, PFont font, int alignX, int alignY) {
    this(x, y, w, h, iKey, label, labelColor, labelSize, font);
    _labelAlignX = alignX;
    _labelAlignY = alignY;
  }

  public void setLabel(String newLabel) {
    _label = newLabel;
  }

  public void setLabelColor(color newColor) {
    _labelColor = newColor;
  }

  public void draw() {

    if (_display) {

      rectMode(CENTER);
      fill(_labelColor);
      textAlign(_labelAlignX, _labelAlignY);
      textFont(_labelFont);
      textSize(_labelSize);

      text(_label, _pos.x, _pos.y);
      
    }
    
  }

}
