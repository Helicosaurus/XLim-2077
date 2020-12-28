public class MenuDisplay {

  private HashMap<String, Menu> _menus;
  private String[]              _displayedMenuKeys;


  public MenuDisplay() {
    _menus             = new HashMap<String, Menu>();
    _displayedMenuKeys = new String[0];
  }

  //Ajouter un menu dans le tableau de menus
  //Un menu est référencé par une clé (String)
  public void addMenu(String hashKey, Menu menu) {
    _menus.put(hashKey, menu);
  }

  //Afficher un menu en plus de ceux déjà présents
  public void showMenu(String hashKey) {
    _displayedMenuKeys = append(_displayedMenuKeys, hashKey);
  }

  //Afficher une liste de menus
  public void showMenus(String[] hashKeys) {
    _displayedMenuKeys = hashKeys;
  }

  //Cacher un menu en particulier
  public void hideMenu(String hashKey) {

    String[] tmpArray = new String[0];
    
    for (String k: _displayedMenuKeys) {
      if (k != hashKey) {
        tmpArray = append(tmpArray, k);
      }
    }
    
    _displayedMenuKeys = tmpArray;

  }

  //Cacher tous les menus
  public void hideAllMenus() {
    _displayedMenuKeys = new String[0];
  }

  //Renvoie l'IKey de l'élément cliqué le plus en avant
  public IKey getForegroundHoveredIKey() {

    IKey iKey = IKey.EMPTY;

    for (String k: _displayedMenuKeys) {

      IKey tmpKey = _menus.get(k).getIKeyOnHover();
      
      if (tmpKey != null) {
        iKey = tmpKey;
      }

    }

    return iKey;

  }

  public Menu getMenu(String hashKey) {
    return _menus.getOrDefault(hashKey, new Menu());
  }

  //Dessin des menus
  public void draw() {

    for(String hashKey: _displayedMenuKeys) {
      //Dessiner tous les menus dont les clés sont enregistrées comme à afficher
      if (_menus.containsKey(hashKey) && hashKey != "") {
        _menus.get(hashKey).draw();
      }
    }

  }

}
