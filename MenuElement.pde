public abstract class MenuElement {

  protected PVector _pos;
  protected int     _w;
  protected int     _h;
  protected IKey    _iKey;
  protected boolean _display;

  public MenuElement() {
    _pos     = new PVector(0, 0);
    _w       = 0;
    _h       = 0;
    _iKey    = IKey.EMPTY;
    _display = true;
  }

  public MenuElement(int x, int y, int w, int h, IKey iKey) {
    _pos     = new PVector(x, y);
    _w       = w;
    _h       = h;
    _iKey    = iKey;
    _display = true;
  }

  public boolean isHovered() {
    //Renvoie true si la souris est sur l'élément du menu, false sinon
    return (mouseX >= _pos.x - _w / 2
         && mouseX <= _pos.x + _w / 2
         && mouseY >= _pos.y - _h / 2
         && mouseY <= _pos.y + _h / 2);
  }

  public IKey getIKey() {
    return _iKey;
  }

  //Fonctions génériques pour polymorphisme d'héritage 
  public void setLabel(String newLabel) {
    println("Impossible de changer le texte en: " + newLabel + " car l'élément ciblé ne contient pas de texte.");
  }

  public void setLabelColor(color newColor) {
    println("Impossible de changer la couleur du texte en: " + newColor + " car l'élément ciblé ne contient pas de texte.");
  }

  public void setButtonColor(color newFg, color newBg) {
    println("Cet élément n'est pas un bouton, impossible de changer les couleurs en " + newFg + " et " + newBg + ".");
  }
  //Fin fonctions génériques

  public void hide() {
    _display = false;
  }

  public void show() {
    _display = true;
  }

  public boolean isDisplayed() {
    return _display;
  }

  public abstract void draw();

}
