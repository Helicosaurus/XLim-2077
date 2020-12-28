public class Board {

  private int             _boardSize;
  private EmptySquare[][] _board;
  private boolean         _display;
  private PVector         _startPos;

  public Board() {
    _boardSize       = 0;
    _board           = new EmptySquare[0][0];
    _display         = false;
    _startPos        = new PVector(0, 0);
  }

  //Private car throw des exceptions: à toujours invoquer par loadLevel()
  public void loadLevel(String lvl) {

    String[] lines = loadStrings(lvl);
    
    
    if (lines == null) {
      throw new RuntimeException("Erreur: le fichier du niveau est introuvable.");
    }

    //La première ligne du fichier correspond à la taille du plateau
    int boardSize = int(lines[0]);

    if (boardSize != lines.length - 1 || boardSize < MIN_BOARD_SIZE || boardSize > MAX_BOARD_SIZE) {
      throw new RuntimeException("Erreur: le fichier de niveau est invalide - taille de niveau erronée. (Min " + MIN_BOARD_SIZE + ", max " + MAX_BOARD_SIZE + ")");
    }

    //Les autres lignes représentent les cases du plateau
    _board = new EmptySquare[boardSize][boardSize];
    boolean hasStartingPoint = false;

    //Chaque case est instanciée selon le fichier texte
    for (int j = 0; j < boardSize; j++) {

      if (lines[j+1].length() < boardSize) {

        //Reset du tableau
        _boardSize    = 0;
        _board        = new EmptySquare[0][0];

        throw new RuntimeException("Erreur: le fichier de niveau est invalide - symboles manquants.");

      }

      for (int i = 0; i < boardSize; i++) {

        switch (lines[j+1].charAt(i)) {

          case ' ':
            _board[i][j] = new EmptySquare();
          break;

          case 'P':
            _board[i][j] = new EmptySquare(true); //Contient un bonus
          break;

          case 'X':
            _board[i][j] = new WallSquare();
          break;

          case 'V':
            _board[i][j] = new DirectionSquare(false, Direction.UP);
          break;

          case '^':
            _board[i][j] = new DirectionSquare(false, Direction.DOWN);
          break;

          case '>':
            _board[i][j] = new DirectionSquare(false, Direction.LEFT);
          break;

          case '<':
            _board[i][j] = new DirectionSquare(false, Direction.RIGHT);
          break;

          case 'O':
            _board[i][j] = new ObjectiveSquare();
          break;

          case 'F':
            _board[i][j] = new FreezeSquare();
          break;

          case 'A':
            _board[i][j] = new AntivirusSquare();
          break;

          case 'S':
            this.setStart(i, j);
            hasStartingPoint = true;
          break;

          default:
            _board[i][j] = new EmptySquare();

        }

        //Gestion des téléporteurs
        if (lines[j+1].charAt(i) >= '0' && lines[j+1].charAt(i) <= '9') {

          int tmpId = int(lines[j+1].charAt(i) - '0');
          int count = 0; //Compte autres les téléporteurs de même ID

          //Recherche des coordonnées de l'autre téléporteur
          //On en profite pour voir s'il y a bien strictement deux téléporteurs
          for (int l = 0; l < boardSize; l++) {
            for (int k = 0; k < boardSize; k++) {
              if ((i != k || j != l) && lines[j+1].charAt(i) == lines[l+1].charAt(k)) {
                count++;
                _board[i][j] = new TeleportSquare(tmpId, k, l);
              }
            }
          }

          if (count != 1) {
            throw new RuntimeException("Erreur: les téléporteurs " + tmpId + " sont au nombre de " + (count + 1) + " au lieu de 2. (Niveau " + lvl + ")");
          }

        }

      }

    }

    if (!hasStartingPoint) {
      throw new RuntimeException("Erreur: le joueur n'a pas de point de départ.");
    }

    //On ne modifie les attributs que lorsque l'on est sûr d'avoir évité les exceptions
    _boardSize = boardSize;

    //Enfin, on précharge les textures selon la taille du tableau
    textures.preload(int(float(height) / float(_boardSize)));
    
  }

  public String[] getAsTextFile() {
    
    String[] lines = new String[_boardSize + 1];

    lines[0] = nf(_boardSize);

    for (int i = 0; i < _boardSize; i++) {

      String tmp = "";

      for (int j = 0; j < _boardSize; j++) {

        char c = ' ';

        switch (_board[j][i].getSquareType()) {
            
          case "Empty":
            if(_board[j][i].hasBonus()) {
              c = 'P';
            }
            else {
              c = ' ';
            }
          break;

          case "Wall":
            c = 'X';
          break;

          case "Start":
            c = 'S';
          break;

          case "Objective":
            c = 'O';
          break;

          case "Freeze":
            c = 'F';
          break;

          case "Antivirus":
            c = 'A';
          break;

          case "Direction":
            if (!_board[j][i].isTopSolid()) {
              c = 'V';
            }
            else if (!_board[j][i].isBottomSolid()) {
              c = '^';
            }
            else if (!_board[j][i].isLeftSolid()) {
              c = '>';
            }
            else {
              c = '<';
            }
          break;

          case "Teleport":
            c = char('0' + _board[j][i].getTeleportId());
          break;

          default:
            c = ' ';

        }

        tmp += c;

      }

      lines[i+1] = tmp;

    }

    return lines;

  }

  public void setStart(int x, int y) {

    //S'il existe un précédent point de départ, on l'efface
    int tmpX = int(_startPos.x);
    int tmpY = int(_startPos.y);
    if (_board[tmpX][tmpY] != null && _board[tmpX][tmpY].getSquareType().equals("Start")) {
      _board[tmpX][tmpY] = new EmptySquare();
    }

    _board[x][y] = new StartSquare();
    _startPos    = new PVector(x, y);

  }

  //GETTERS ET SETTERS
  public int getSize() {
    return _boardSize;
  }

  public PVector getStartPos() {
    return _startPos;
  }

  public String getSquareType(int x, int y) {
    return _board[x][y].getSquareType();
  }

  public void setSquare(int x, int y, EmptySquare sq) {
    _board[x][y] = sq;
  }

  public boolean isTopSolid(int x, int y) {
    return _board[x][y].isTopSolid();
  }

  public boolean isBottomSolid(int x, int y) {
    return _board[x][y].isBottomSolid();
  }

  public boolean isLeftSolid(int x, int y) {
    return _board[x][y].isLeftSolid();
  }

  public boolean isRightSolid(int x, int y) {
    return _board[x][y].isRightSolid();
  }

  public PVector getTeleportDest(int x, int y) {
    return _board[x][y].getTeleportDest();
  }

  //Vérifie si _x et _y sont des coordonnées existantes dans board, pour éviter OutOfBoundsArrayException
  public boolean areValidCoords(int x, int y) {
    return x >= 0 && x < _boardSize && y >= 0 && y < _boardSize;
  }

  public boolean hasBonus(int x, int y) {
    return _board[x][y].hasBonus();
  }

  public void removeBonus(int x, int y) {
    _board[x][y].removeBonus();
  }

  public void hide() {
    _display = false;
  }

  public void show() {
    _display = true;
  }
  //FIN GETTERS ET SETTERS

  public void draw(float squareSize) {

    if(_display) {
      for (int i = 0; i < _boardSize; i++) {
        for (int j = 0; j < _boardSize; j++) {
          _board[i][j].draw(i * squareSize, j * squareSize);
        }
      }
    }

  }

}
