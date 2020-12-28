public class Player {

  private String    _name;
  private int       _score;
  private int       _startingTimeStamp;
  private int       _levelTime;
  private PVector   _pos;
  private PVector   _oldPos;
  private Direction _currentDirection;
  private int       _lastMoveTimeStamp;
  private boolean   _teleportIllness;
  private boolean   _display;

  private final int _millisBetweenMoves = 40;
  
  public Player() {
    _name              = "";
    _score             = 0;
    _levelTime         = 0;
    _startingTimeStamp = 0;
    _pos               = new PVector(0, 0);
    _oldPos            = new PVector(0, 0);
    _currentDirection  = Direction.NONE;
    _lastMoveTimeStamp = 0;
    _teleportIllness   = false;
    _display           = false;
  }

  public void init(int x, int y) {
    _pos.set(x, y);
    _oldPos.set(_pos);
    _currentDirection  = Direction.NONE;
    _teleportIllness   = false;
    _score             = 0;
    _startingTimeStamp = millis();
    _levelTime         = 0;
  }

  public String getName() {
    return _name;
  }

  public void setName(String str) {
    _name = str;
  }

  public int getScore() {
    return _score;
  }

  public void incScore() {
    _score++;
  }

  //Agit à la fois comme setter et getter (retourne le temps)
  public int refreshLevelTime() {
    _levelTime = millis() - _startingTimeStamp;
    return _levelTime;
  }

  public int getPosX() {
    return int(_pos.x);
  }

  public int getPosY() {
    return int(_pos.y);
  }

  public Direction getDirection() {
    return _currentDirection;
  }

  public void setDirection(Direction dir) {
    _currentDirection = dir;
  }

  public boolean isMoving() {
    return _currentDirection != Direction.NONE;
  }

  public boolean busyMoving() {
    //Retourne true si le joueur est en train de se déplacer
    //Le joueur se déplace d'une case par intervalle de temps "millisBetweenMoves"
    return millis() - _millisBetweenMoves < _lastMoveTimeStamp;
  }

  public void setAsIdle() {
    _currentDirection  = Direction.NONE;
  }

  public boolean canTeleport() {
    return !_teleportIllness;
  }

  public void teleportTo(int x, int y) {
      _pos.set(x, y);
      _oldPos.set(_pos);
      _teleportIllness = true; //Le joueur ne peut plus se téléporter tant qu'il n'a pas bougé d'une case.
  }

  public void move() {

    if (!this.busyMoving()) {

      _oldPos.set(_pos);

      if (_currentDirection == Direction.UP)
        _pos.y--;
      else if (_currentDirection == Direction.DOWN)
        _pos.y++;
      else if (_currentDirection == Direction.LEFT)
        _pos.x--;
      else if (_currentDirection == Direction.RIGHT)
        _pos.x++;
      
      if (_currentDirection != Direction.NONE) {
        _lastMoveTimeStamp = millis();
        _teleportIllness   = false;
      }
      
    }
    
  }

  public void hide() {
    _display = false;
  }

  public void show() {
    _display = true;
  }

  public void draw(float size) {

    if (_display) {
      //Avancement de l'interpolation dans _shift, ce qui permet des mouvements fluides
      float shift = 1.0 - min(float(millis() - _lastMoveTimeStamp) / _millisBetweenMoves, 1.0);
      float xMov  = 0.0;
      float yMov  = 0.0;

      if (_pos.x > _oldPos.x) {
        xMov = - shift;
      }
      else if (_pos.x < _oldPos.x) {
        xMov = shift;
      }

      if (_pos.y > _oldPos.y) {
        yMov = - shift;
      }
      else if (_pos.y < _oldPos.y) {
        yMov = shift;
      }

      imageMode(CORNER);
      image(textures.getTexture("virus.png"), (_pos.x + xMov) * size, (_pos.y + yMov) * size);
    }

  }

}
