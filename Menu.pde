public class Menu {

  private MenuElement[] _elements;

  public Menu() {
    _elements = new MenuElement[0];
  }

  //Le fait de stacker ainsi permet de définir un ordre des éléments dans le menu.
  //Les éléments en arrière-plan doivent donc être ajoutés en premier.
  public void addElement(MenuElement el) {
    _elements = (MenuElement[])append(_elements, el);
  }

  public void editElementLabel(int index, String newLabel) {
    if (index < _elements.length && index > -1) {
      _elements[index].setLabel(newLabel);
    }
  }

  public void editElementLabelColor(int index, color newColor) {
    if (index < _elements.length && index > -1) {
      _elements[index].setLabelColor(newColor);
    }
  }

  public void editElementColors(int index, color newBg, color newFg) {
    if (index < _elements.length && index > -1) {
      _elements[index].setButtonColor(newBg, newFg);
    }
  }

  public void hideElement(int index) {
    _elements[index].hide();
  }

  public void showElement(int index) {
    _elements[index].show();
  }

  //Récupère la clé d'interaction de l'élément survolé le plus au premier plan.
  public IKey getIKeyOnHover() {

    IKey tmpKey = IKey.EMPTY;

    for (MenuElement el: _elements) {
      if (el.isHovered() && el.isDisplayed()) {
        tmpKey = el.getIKey();
      }
    }

    return tmpKey;

  }

  //Dessin du menu (donc de ses éléments)
  public void draw() {
    for (MenuElement el: _elements) {
      el.draw();
    }
  }

}
