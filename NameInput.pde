public class NameInput {

  private boolean _isEnabled;
  private String  _name;

	public NameInput() {
    _isEnabled = false;
    _name      = "";
	}

  public void enable() {
    _isEnabled = true;
  }

  public void disable() {
    _isEnabled = false;
  }

  public void setName(String name) {
    _name = name.trim(); //Enlève les espaces indésirables et permet de copier en mémoire plutôt que par référence
  }

  public String getName() {
    return _name;
  }

  public void onKeyPress() {

    if (_isEnabled) {

      if (key == BACKSPACE) {
        if (_name.length() > 0) {
          _name = _name.substring(0, _name.length() - 1);
        }
      }
      else if (_name.length() < 15) {
        if (utils.isAlphaNumWithAccents(key)) {
          String k = "" + key; //Cast char -> String
          _name = _name.concat(k);
        }
      }

    }

  }

  public void draw() {

    if (_isEnabled) {
      
      rectMode(CENTER);
      fill(#00AAAA);
      textAlign(LEFT, CENTER);
      textFont(defaultFont);
      textSize(64);

      //Afficher l'underscore uniquement si le nom n'est pas à sa taille maximale
      //Et ajout d'une condition sur le frameCount pour le faire clignoter (affichage sur 30 frames par 60 frames)
      String inputCursor = (_name.length() < 15 && frameCount % 60 < 30) ? "_": "";

      text("> " + _name + inputCursor, 200, 350);

    }

  }

}
