public class GameEngine {

  private Player      _player;
  private MenuDisplay _menuDisplay;
  private HighScores  _highScores;
  private NameInput   _nameInput;
  private Board       _gameBoard;
  private boolean     _gameRunning;
  private boolean     _editingMode;
  private String      _editorPick;
  private String      _currentLevel;
  private boolean     _customLevel;

  //Nécessité d'un attribut global respectant le même ordre que les IKeys respectives
  private final String[]  _editorTextureNames = {"editor_virus.png",
                                                 "editor_exit.png",
                                                 "editor_empty.png",
                                                 "editor_wall.png",
                                                 "editor_data.png",
                                                 "editor_antivirus.png",
                                                 "editor_direction_up.png",
                                                 "editor_direction_down.png",
                                                 "editor_direction_left.png",
                                                 "editor_direction_right.png",
                                                 "editor_freeze.png"};

  public GameEngine() {
    _player       = new Player();
    _menuDisplay  = new MenuDisplay();
    _highScores   = new HighScores();
    _nameInput    = new NameInput();
    _gameBoard    = new Board();
    _gameRunning  = false;
    _editingMode  = false;
    _editorPick   = "editor_empty.png";
    _currentLevel = "";
    _customLevel  = false;
  }

  public MenuDisplay getMenuDisplay() {
    return _menuDisplay;
  }

  private void tryToLoadLevel(String level, boolean isCustom, boolean inEditor) {

    try {

      _currentLevel = new String(level);
      _customLevel  = isCustom;

      if (!isCustom) {
        level = "data/levels/" + level + ".txt";
      }

      _gameBoard.loadLevel(level);
      _gameBoard.show();
      _gameRunning = true;

      PVector tmp = _gameBoard.getStartPos();
      _player.init(int(tmp.x), int(tmp.y));
      _player.show();

      _menuDisplay.hideAllMenus();

      if (inEditor) {
        _editingMode = true;
        _editorPick  = "editor_empty.png";
        _menuDisplay.showMenu("editorMenu");
        editorTextures.preload(int(float(height) / float(_gameBoard.getSize()))); //Préchargement des textures selon la taille des cases
      }
      else {
        _menuDisplay.showMenu("ingameMenu");
        _menuDisplay.getMenu("ingameMenu").editElementLabelColor(5, #FFFFFF);
        _menuDisplay.getMenu("ingameMenu").editElementLabelColor(7, #FFFFFF);

        String tmpName = level.replaceAll("(.+)[\\/\\\\]([^\\/\\\\]+)\\.txt", "$2");
        //Le regex récupère uniquement le nom du niveau depuis le chemin complet du fichier

        if (!isCustom) {
          tmpName = "NIVEAU " + tmpName;
        }
        else if(tmpName.length() > 15) {
          tmpName = tmpName.substring(0, 15);
        }
        
        _menuDisplay.getMenu("ingameMenu").editElementLabel(1, tmpName);
      }

    }
    catch (RuntimeException e) {
      _gameBoard.hide();
      _gameRunning = false;
      _currentLevel = "";
      _customLevel  = false;
      _player.init(0, 0);
      _player.hide();
      _menuDisplay.hideAllMenus();
      _menuDisplay.showMenu("mainMenu");
      _menuDisplay.getMenu("errorPopup").editElementLabel(2, e.getMessage());
      _menuDisplay.showMenu("errorPopup");
    }

  }

  //CALLBACKS
  //Fonctions appelées à la résolution de SelectInput() et SelectOutput()
  public void editorSaveLevel(File selection) {

    if (selection != null) {
      
      String   txtPath  = selection.getPath();
      String[] txtBoard = _gameBoard.getAsTextFile();

      if(!txtPath.endsWith(".txt")) {
        txtPath += ".txt";
      }

      saveStrings(txtPath, txtBoard);

    }

  }

  public void editorLoadLevel(File selection) {

    if (selection != null) {
      tryToLoadLevel(selection.getPath(), true, true);
    }

  }

  public void loadCustomLevel(File selection) {

    if (selection != null) {
      tryToLoadLevel(selection.getPath(), true, false);
    }

  }
  //FIN CALLBACKS

  public void onClick() {

    IKey clickedIKey = _menuDisplay.getForegroundHoveredIKey(); //Récupère l'IKey de l'élément cliqué le plus en avant

    switch(clickedIKey) {
      
      case TO_EXIT:
        exit();
      break;

      case TO_MAIN_MENU:
        _gameRunning = false;
        _gameBoard.hide();
        _editingMode = false;
        _player.hide();
        _player.setName(_nameInput.getName());
        _nameInput.disable();
        _menuDisplay.hideAllMenus();
        _menuDisplay.showMenu("mainMenu");
      break;

      case TO_LEVEL_MENU:
        _gameRunning = false;
        _gameBoard.hide();
        _player.hide();
        _player.setName(_nameInput.getName());
        _nameInput.disable();

        for (int i = 1; i <= NUMBER_OF_LEVELS; i++) {
          if (_highScores.hasClearedLevel(_player.getName(), i)) {
            _menuDisplay.getMenu("levelMenu").editElementColors(i+1, WIN_BUTTON_BG, WIN_BUTTON_FG);
          }
          else {
            _menuDisplay.getMenu("levelMenu").editElementColors(i+1, MENU_BUTTON_BG, MENU_BUTTON_FG);
          }
        }

        _menuDisplay.hideAllMenus();
        _menuDisplay.showMenu("levelMenu");
        _menuDisplay.getMenu("ingameMenu").editElementLabel(3, _player.getName());
      break;

      case TO_HELP_MENU:
        _menuDisplay.hideAllMenus();
        _menuDisplay.showMenu("helpMenu");
      break;

      case TO_HALL_MENU:
        String[] formattedBest = _highScores.getHighScores();

        for (int i = 0; i < 4 * NUMBER_OF_TOP_SCORES; i++) {
           _menuDisplay.getMenu("hallMenu").editElementLabel(i + 7, formattedBest[i]);
        }

        _menuDisplay.hideAllMenus();
        _menuDisplay.showMenu("hallMenu");
      break;

      case ASK_PLAYER_NAME:
        _menuDisplay.hideAllMenus();
        _menuDisplay.showMenu("askName");
        _nameInput.setName(_player.getName());
        _nameInput.enable();
      break;

      case RESET_LEVEL:
        this.tryToLoadLevel(_currentLevel, _customLevel, false);
      break;

      case TO_PREVIOUS_LEVEL:
        this.tryToLoadLevel(nf(max(1, int(_currentLevel) - 1)), false, false);
      break;

      case HIDE_VICTORY:
        _menuDisplay.hideMenu("victoryPopup");
      break;

      case TO_NEXT_LEVEL:
        this.tryToLoadLevel(nf(min(int(_currentLevel) + 1, NUMBER_OF_LEVELS)), false, false);
      break;

      case TO_EDITOR:
        this.tryToLoadLevel("data/levels/template.txt", true, true);
      break;

      case EDITOR_SAVE:
        selectOutput("XLim 2077 - Sauvegarder le niveau", "editorSaveLevel", null, this);
      break;

      case EDITOR_LOAD:
        selectInput("XLim 2077 - Charger un niveau", "editorLoadLevel", null, this);
      break;

      case EDITOR_RESET:
        PVector tmp = _gameBoard.getStartPos();
        _player.init(int(tmp.x), int(tmp.y));
      break;

      case TO_CUSTOM_LEVEL:
        selectInput("XLim 2077 - Charger un niveau", "loadCustomLevel", null, this);
      break;

      case CLOSE_ERROR:
        _menuDisplay.hideMenu("errorPopup");
      break;

      default:
        
    }

    //Equivalent du switch, mais refactoré pour l'éditeur
    if (IKey.indexOf(clickedIKey) >= IKey.indexOf(IKey.EDITOR_TILE_START)
     && IKey.indexOf(clickedIKey) <  IKey.indexOf(IKey.EDITOR_TILE_START) + _editorTextureNames.length) {

      int tmp     = IKey.indexOf(clickedIKey) - IKey.indexOf(IKey.EDITOR_TILE_START);
      _editorPick = _editorTextureNames[tmp];
    
    }

    //Equivalent du switch, mais refactoré pour les niveaux
    if (IKey.indexOf(clickedIKey) >= IKey.indexOf(IKey.TO_LEVEL_1)
     && IKey.indexOf(clickedIKey) <  IKey.indexOf(IKey.TO_LEVEL_1) + NUMBER_OF_LEVELS) {

      int level = IKey.indexOf(clickedIKey) - IKey.indexOf(IKey.TO_LEVEL_1) + 1;
      this.tryToLoadLevel(nf(level), false, false);
    
    }

  }

  public void onKeyPress() {

    _nameInput.onKeyPress();
    
    //Si le joueur n'est pas en mouvement, on peut lui donner une direction
    if (!_player.isMoving()) {

      if (keyCode == UP || keyCode == 'Z') {  
        _player.setDirection(Direction.UP);
      }
      else if (keyCode == DOWN || keyCode == 'S') {
        _player.setDirection(Direction.DOWN);
      }
      else if (keyCode == LEFT || keyCode == 'Q') {
        _player.setDirection(Direction.LEFT);
      }
      else if (keyCode == RIGHT || keyCode == 'D') {
        _player.setDirection(Direction.RIGHT);
      }

    }

  }

  public void update() {

    if (_gameRunning) {

      int       px   = _player.getPosX();
      int       py   = _player.getPosY();
      Direction pdir = _player.getDirection();

      if (!_player.busyMoving()) {
        
        //Le joueur est en train de bouger
        if (_player.isMoving()) {

          if (_gameBoard.areValidCoords(px, py)) {

            if (_gameBoard.getSquareType(px, py).equals("Teleport") && _player.canTeleport()) {
              PVector tmp = _gameBoard.getTeleportDest(px, py);
              _player.teleportTo(int(tmp.x), int(tmp.y));
              px = _player.getPosX();
              py = _player.getPosY();
            }

            if (_gameBoard.getSquareType(px, py).equals("Freeze") && _player.canTeleport()) {
              _player.teleportTo(px, py); //On téléporte le joueur sur la case où il est, ce qui lui donne le mal de téléportation
              _player.setAsIdle();
            }

            if (_gameBoard.getSquareType(px, py).equals("Objective") || _gameBoard.getSquareType(px, py).equals("Antivirus")) {
              _player.setAsIdle(); //Respectivement victoire ou échec
            }

          }

          //Si le joueur est sorti de l'écran, on arrête de le faire se déplacer, il a perdu.
          if (!_gameBoard.areValidCoords(px, py)) {
            _player.setAsIdle();
          }

          //Si le joueur fait face à un obstacle, il doit arrêter de se déplacer
          //Les quatres directions sont testées
          //Si le joueur est au bord du plateau (0, boardSize-1), rien ne peut l'arrêter de continuer dans cette direction
          else if
          (  ( pdir == Direction.UP    && _gameBoard.areValidCoords(px, py - 1) && _gameBoard.isBottomSolid(px, py - 1) ) 
          || ( pdir == Direction.DOWN  && _gameBoard.areValidCoords(px, py + 1) &&    _gameBoard.isTopSolid(px, py + 1) )
          || ( pdir == Direction.LEFT  && _gameBoard.areValidCoords(px - 1, py) &&  _gameBoard.isRightSolid(px - 1, py) )
          || ( pdir == Direction.RIGHT && _gameBoard.areValidCoords(px + 1, py) &&   _gameBoard.isLeftSolid(px + 1, py) ) )
          {
            _player.setAsIdle();
          }

        }

        //Pas de else, car si on vient de définir le joueur comme idle, on veut pouvoir redéfinir l'état du jeu immédiatement
        if(!_player.isMoving() && !_editingMode) {

          //Vérifier les conditions d'échec et de victoire
          if (!_gameBoard.areValidCoords(px, py) || _gameBoard.getSquareType(px, py).equals("Antivirus")) {

            _gameRunning = false;
            _player.setAsIdle();

            _menuDisplay.showMenu("failurePopup");
            _menuDisplay.getMenu("ingameMenu").editElementLabelColor(5, #FF0000);
            _menuDisplay.getMenu("ingameMenu").editElementLabelColor(7, #FF0000);

            return; //Le jeu n'est plus actif, d'où le return

          }
          else if (_gameBoard.getSquareType(px, py).equals("Objective")) {

            _gameRunning = false;
            _player.setAsIdle();

            if (!_customLevel) {
              //Gestion de l'affichage des boutons "niveau précédent" et "niveau suivant"
              _menuDisplay.getMenu("victoryPopup").showElement(2);
              _menuDisplay.getMenu("victoryPopup").showElement(4);

              switch (int(_currentLevel)) {
                case 1:
                  _menuDisplay.getMenu("victoryPopup").hideElement(2);
                break;
                case NUMBER_OF_LEVELS:
                  _menuDisplay.getMenu("victoryPopup").hideElement(4);
                break;
              }
            }
            else {
              _menuDisplay.getMenu("victoryPopup").hideElement(2);
              _menuDisplay.getMenu("victoryPopup").hideElement(4);
            }

            _menuDisplay.showMenu("victoryPopup");
            _menuDisplay.getMenu("ingameMenu").editElementLabelColor(5, #00CC00);
            _menuDisplay.getMenu("ingameMenu").editElementLabelColor(7, #00CC00);

            this.refreshLevelTimeDisplay();

            if (!_customLevel) {
              _highScores.update(int(_currentLevel), _player.getName(), _player.getScore(), _player.refreshLevelTime());
            }

            return; //Le jeu n'est plus actif, d'où le return

          }
          
        }

        //Si le joueur récolte un bonus, monter son score
        //Les bonus ne sont pas récupérés dans la simulation de l'éditeur
        if (_gameBoard.areValidCoords(px, py) && _gameBoard.hasBonus(px, py) && !_editingMode) {
          _player.incScore();
          _gameBoard.removeBonus(px, py);
        }

      }

      //Déplacement du joueur
      _player.move();

      if (!_editingMode) {
        this.refreshLevelTimeDisplay();
      }

      //Edition des cases en mode éditeur
      if(_editingMode && !_player.busyMoving() && mousePressed && mouseX >= 0 && mouseY >= 0 && mouseX < 600 && mouseY < 600) {

        float squareSize = float(height) / float(_gameBoard.getSize());
        int mX = mouseX / int(squareSize);
        int mY = mouseY / int(squareSize);
        
        if (mX != _player.getPosX() || mY != _player.getPosY()) {
          switch (_editorPick) {

            case "editor_virus.png":
              if (!_gameBoard.getSquareType(mX, mY).equals("Start")) {
                _gameBoard.setStart(mX, mY);
                _player.init(mX, mY);
              }
            break;

            case "editor_exit.png":
              if (!_gameBoard.getSquareType(mX, mY).equals("Objective")) {
                _gameBoard.setSquare(mX, mY, new ObjectiveSquare());
              }
            break;
          
            case "editor_empty.png":
              if (!(_gameBoard.getSquareType(mX, mY).equals("Empty") && !_gameBoard.hasBonus(mX, mY))) {
                _gameBoard.setSquare(mX, mY, new EmptySquare());
              }
            break;

            case "editor_wall.png":
              if (!_gameBoard.getSquareType(mX, mY).equals("Wall")) {
                _gameBoard.setSquare(mX, mY, new WallSquare());
              }
            break;

            case "editor_data.png":
              _gameBoard.setSquare(mX, mY, new EmptySquare(true));
            break;

            case "editor_antivirus.png":
              if (!_gameBoard.getSquareType(mX, mY).equals("Antivirus")) {
                _gameBoard.setSquare(mX, mY, new AntivirusSquare());
              }
            break;

            case "editor_direction_up.png":
              _gameBoard.setSquare(mX, mY, new DirectionSquare(false, Direction.UP));
            break;

            case "editor_direction_down.png":
              _gameBoard.setSquare(mX, mY, new DirectionSquare(false, Direction.DOWN));
            break;

            case "editor_direction_left.png":
              _gameBoard.setSquare(mX, mY, new DirectionSquare(false, Direction.LEFT));
            break;

            case "editor_direction_right.png":
              _gameBoard.setSquare(mX, mY, new DirectionSquare(false, Direction.RIGHT));
            break;

            case "editor_freeze.png":
              if (!_gameBoard.getSquareType(mX, mY).equals("Freeze")) {
                _gameBoard.setSquare(mX, mY, new FreezeSquare());
              }
            break;

            default:

          }

        }

      }

    }

  }

  private void refreshLevelTimeDisplay() {
    //Actualisation du menu qui sert de HUD
    _menuDisplay.getMenu("ingameMenu").editElementLabel(5, nf(_player.getScore()));

    int playerTime = _player.refreshLevelTime();
    int millis     = playerTime % 1000;
    int seconds    = (playerTime / 1000) % 60;
    int minutes    = min(99, playerTime / 60000);

    _menuDisplay.getMenu("ingameMenu").editElementLabel(7, nf(minutes, 2) + ":" + nf(seconds, 2) + "." + nf(millis, 3));
  }

  public void draw() {
   
    float squareSize = float(height) / float(_gameBoard.getSize());
    _gameBoard.draw(squareSize);
    _player.draw(squareSize);


    if(_editingMode) {

      if (mouseX < 600) {
        int mX = mouseX / int(squareSize);
        int mY = mouseY / int(squareSize);
        imageMode(CORNER);
        image(editorTextures.getTexture(_editorPick), mX * squareSize, mY * squareSize);
      }

    }

    /* Tentative de filtre: finalement non utilisée, mais laissée en exemple
       Au final, l'effet est appliqué case par case
       Mode de fusion de couleur: Teinte et Saturation de l'image à appliquer, Luminosité de l'image de base
       Décommenter la ligne suivante pour voir le rendu */
    //utils.blendColor(menuTextures.getTexture("cyanFilter.png"), 0, (millis()/4) % (height + 200) - 200);

    _menuDisplay.draw();
    _nameInput.draw();

  }

}
