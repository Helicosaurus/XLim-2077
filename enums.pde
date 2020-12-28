//Contient les énumérations et constantes

public enum IKey {

  EMPTY,
  ASK_PLAYER_NAME,
  TO_LEVEL_MENU,
  TO_HELP_MENU,
  TO_HALL_MENU,
  TO_EXIT,
  TO_LEVEL_1,
  TO_LEVEL_2,
  TO_LEVEL_3,
  TO_LEVEL_4,
  TO_LEVEL_5,
  TO_LEVEL_6,
  TO_LEVEL_7,
  TO_LEVEL_8,
  TO_LEVEL_9,
  TO_LEVEL_10,
  TO_CUSTOM_LEVEL,
  TO_PREVIOUS_LEVEL,
  HIDE_VICTORY,
  TO_NEXT_LEVEL,
  TO_MAIN_MENU,
  RESET_LEVEL,
  TO_EDITOR,
  EDITOR_TILE_START,
  EDITOR_TILE_EXIT,
  EDITOR_TILE_EMPTY,
  EDITOR_TILE_WALL,
  EDITOR_TILE_DATA,
  EDITOR_TILE_ANTIVIRUS,
  EDITOR_TILE_DIR_UP,
  EDITOR_TILE_DIR_DOWN,
  EDITOR_TILE_DIR_LEFT,
  EDITOR_TILE_DIR_RIGHT,
  EDITOR_TILE_FREEZE,
  EDITOR_SAVE,
  EDITOR_LOAD,
  EDITOR_RESET,
  CLOSE_ERROR;

  public static int indexOf(IKey _iKey) {
    
    IKey[] _keys = IKey.values();

    for (int i = 0; i < _keys.length; i++) {
      if (_keys[i] == _iKey) {
        return i;
      }
    }

    return -1;

  }

}


public enum Direction {
  NONE,
  UP,
  DOWN,
  LEFT,
  RIGHT;
}
