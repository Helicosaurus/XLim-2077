import java.util.HashMap;
import java.util.Set;
import java.util.LinkedList;
import java.util.Queue;

//Variables globales
final int   NUMBER_OF_LEVELS     = 10;
final int   MIN_BOARD_SIZE       = 10;
final int   MAX_BOARD_SIZE       = 20;
final int   NUMBER_OF_TOP_SCORES = 5;
final int   MAX_FONT_SIZE        = 128;

final color MENU_BUTTON_BG       = #0033EE;
final color MENU_BUTTON_FG       = #0077FF;
final color WIN_BUTTON_BG        = #00AA00;
final color WIN_BUTTON_FG        = #00CC33;
final color FAIL_BUTTON_BG       = #FF0000;
final color FAIL_BUTTON_FG       = #FF7700;
final color WHITE                = #FFFFFF;
final color BLACK                = #000000;

Utils       utils;
Textures    textures;
Textures    menuTextures;
Textures    editorTextures;

GameEngine  gameEngine;

PFont       digitalFont;
PFont       defaultFont;
PFont       titleFont;

boolean     easterEgg; // ;)

String      helpText;


void setup() {

  size(800, 600, P2D);
  surface.setTitle("XLim 2077");

  utils          = new Utils();
  textures       = new Textures();
  menuTextures   = new Textures("data/images/menus");
  editorTextures = new Textures("data/images/editor");
  gameEngine     = new GameEngine();

  digitalFont    = createFont("FakeHope.ttf",          MAX_FONT_SIZE);
  defaultFont    = createFont("CT ProLamina.ttf",      MAX_FONT_SIZE);
  titleFont      = createFont("Corporation Games.otf", MAX_FONT_SIZE);
  easterEgg      = false;


  //Création des menus
  Menu mainMenu = new Menu();
  //                                       x    y    w    h    ikey                  label           font                    bgColor         strokeColor
  mainMenu.addElement(new        MenuImage(400, 300, 300, 500, IKey.EMPTY,           "bg_main_menu.png"));
  mainMenu.addElement(new MenuGlitchedText(400, 100, 100, 100, IKey.EMPTY,           "XLim 2077",    WHITE, 48, titleFont));
  mainMenu.addElement(new       MenuButton(400, 180, 220,  60, IKey.ASK_PLAYER_NAME, "Jouer",        WHITE, 44, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  mainMenu.addElement(new       MenuButton(400, 260, 220,  60, IKey.TO_EDITOR,       "Editeur",      WHITE, 44, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  mainMenu.addElement(new       MenuButton(400, 340, 220,  60, IKey.TO_HELP_MENU,    "Aide",         WHITE, 44, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  mainMenu.addElement(new       MenuButton(400, 420, 220,  60, IKey.TO_HALL_MENU,    "Hall of Fame", WHITE, 44, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  mainMenu.addElement(new       MenuButton(400, 500, 220,  60, IKey.TO_EXIT,         "Quitter",      WHITE, 44, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));

  gameEngine.getMenuDisplay().addMenu("mainMenu", mainMenu);


  Menu askName = new Menu();

  askName.addElement(new        MenuImage(400, 300, 500, 400, IKey.EMPTY,         "bg_auth.png"));
  askName.addElement(new MenuGlitchedText(400, 150, 100, 100, IKey.EMPTY,         "Identification",                WHITE, 48, titleFont));
  askName.addElement(new         MenuText(400, 250, 100, 100, IKey.EMPTY,         "Veuillez entrer votre pseudo:", WHITE, 36, defaultFont));
  askName.addElement(new         MenuRect(400, 350, 450,  80, IKey.EMPTY, BLACK, #444444, 180));
  askName.addElement(new       MenuButton(300, 450, 100,  50, IKey.TO_MAIN_MENU,  "Retour",                        WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  askName.addElement(new       MenuButton(500, 450, 100,  50, IKey.TO_LEVEL_MENU, "Valider",                       WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));

  gameEngine.getMenuDisplay().addMenu("askName", askName);


  Menu levelMenu = new Menu();

  levelMenu.addElement(new        MenuImage(400, 300, 650, 500, IKey.EMPTY, "bg_fame.png"));
  levelMenu.addElement(new MenuGlitchedText(400, 100, 100, 100, IKey.EMPTY, "Choix du niveau", WHITE, 64));

  int    lv1Index = IKey.indexOf(IKey.TO_LEVEL_1);
  IKey[] tmpKeys  = IKey.values();
  
  //Génération des boutons des niveaux, avec disposition en grille
  for (int i = 0; i < 2; i++) {

    for (int j = 0; j < 5; j++) {

      int    tmpX     = 200 + 100 * j;
      int    tmpY     = 210 + 100 * i;
      int    tmpSize  = 100;
      IKey   tmpKey   = tmpKeys[lv1Index + 5 * i + j];
      String tmpLabel = nf(5 * i + j + 1);

      levelMenu.addElement(new MenuButton(tmpX, tmpY, tmpSize, tmpSize, tmpKey, tmpLabel, WHITE, 64, digitalFont, MENU_BUTTON_BG, MENU_BUTTON_FG));

    }

  }

  levelMenu.addElement(new MenuButton(400, 420, 250, 50, IKey.TO_CUSTOM_LEVEL, "Charger un niveau", WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  levelMenu.addElement(new MenuButton(400, 500, 100, 50, IKey.TO_MAIN_MENU, "Retour", WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));

  gameEngine.getMenuDisplay().addMenu("levelMenu", levelMenu);


  helpText = "Nous sommes en l'an 2077. L'informatique et la cybernétique ont révolutionné le monde; l'homme et la machine n'ont jamais été aussi proches. Dans ce monde aux couleurs néons, ce ne sont plus les gouvernements, mais les méga-corporations qui dominent le monde. La plus odieuse d'entre elles, Unilim Corp, a construit son empire sur l'héritier d'Internet: la Matrice. Grâce aux travaux du légendaire Dr. Neals Fournaise, Unilim Corp possède la main-mise sur les différentes Grilles de la Matrice, et l'anonymat n'est plus...sauf pour des hackeurs comme vous! Nous recherchons des talents comme vous pour rejoindre notre équipe d'élite, XLim 2077. Notre but? Révéler au monde entier les magouilles d'Unilim Corp.\n\nPour cela, vous allez devoir vous infiltrer, Grille après Grille, dans la sous-Matrice de leur QG. Atteignez le Core de la Grille, évitez les défenses du système, et, sans vous faire repérer, récupérez les Fragments de données le plus vite possible! Bonne chance, hacker.";

  Menu helpMenu = new Menu();

  helpMenu.addElement(new        MenuImage(395, 305, 610, 560, IKey.EMPTY,        "bg_help_menu.png"));
  helpMenu.addElement(new MenuGlitchedText(400,  50, 100, 100, IKey.EMPTY,        "Comment jouer", WHITE,   64));
  helpMenu.addElement(new     MenuTextArea(105,  70, 590, 400, IKey.EMPTY,        helpText,        WHITE,   26, defaultFont, LEFT, CENTER));
  helpMenu.addElement(new         MenuText(105, 490, 100, 100, IKey.EMPTY,        "Vous:",         #15892F, 36, defaultFont, LEFT, CENTER));
  helpMenu.addElement(new        MenuImage(205, 490,  60,  60, IKey.EMPTY,        "help_virus.png"));
  helpMenu.addElement(new         MenuText(305, 490, 100, 100, IKey.EMPTY,        "Core:",         #B356E4, 36, defaultFont, LEFT, CENTER));
  helpMenu.addElement(new        MenuImage(400, 490,  60,  60, IKey.EMPTY,        "help_exit.png"));
  helpMenu.addElement(new         MenuText(495, 490, 100, 100, IKey.EMPTY,        "Fragment:",     #56B7E4, 36, defaultFont, LEFT, CENTER));
  helpMenu.addElement(new        MenuImage(640, 490,  60,  60, IKey.EMPTY,        "help_data.png"));
  helpMenu.addElement(new        MenuImage(200, 550, 150,  50, IKey.EMPTY,        "help_keys.png"));
  helpMenu.addElement(new       MenuButton(400, 550, 100,  50, IKey.TO_MAIN_MENU, "Retour",        WHITE,   36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));

  gameEngine.getMenuDisplay().addMenu("helpMenu", helpMenu);


  Menu hallMenu = new Menu();

  hallMenu.addElement(new        MenuImage(400, 300, 650, 500, IKey.EMPTY, "bg_fame.png"));
  hallMenu.addElement(new         MenuRect(400, 300, 610, 310, IKey.EMPTY, BLACK, #444444, 220));
  hallMenu.addElement(new MenuGlitchedText(400, 100, 100, 100, IKey.EMPTY, "Hall of Fame", WHITE, 64));

  hallMenu.addElement(new MenuText(110, 170, 100, 100, IKey.EMPTY, "Hacker",      WHITE, 36, defaultFont, LEFT, CENTER));
  hallMenu.addElement(new MenuText(340, 170, 100, 100, IKey.EMPTY, "Hacks",       WHITE, 36, defaultFont));
  hallMenu.addElement(new MenuText(450, 170, 100, 100, IKey.EMPTY, "Fragments",   WHITE, 36, defaultFont));
  hallMenu.addElement(new MenuText(610, 170, 100, 100, IKey.EMPTY, "Temps total", WHITE, 36, defaultFont));

  color[] topColors = {#ED2143, #F04A65, #F58698, #FAC3CC, #FDEBEE};

  for (int i = 0; i < NUMBER_OF_TOP_SCORES; i++) {
    hallMenu.addElement(new MenuText(110, 220 + 50 * i, 100, 100, IKey.EMPTY, "", topColors[i], 36, defaultFont, LEFT, CENTER));
    hallMenu.addElement(new MenuText(340, 220 + 50 * i, 100, 100, IKey.EMPTY, "", topColors[i], 36, digitalFont));
    hallMenu.addElement(new MenuText(450, 220 + 50 * i, 100, 100, IKey.EMPTY, "", topColors[i], 36, digitalFont));
    hallMenu.addElement(new MenuText(610, 220 + 50 * i, 100, 100, IKey.EMPTY, "", topColors[i], 36, digitalFont));
  }

  hallMenu.addElement(new MenuButton(400, 500, 100, 50,  IKey.TO_MAIN_MENU, "Retour", WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));

  gameEngine.getMenuDisplay().addMenu("hallMenu", hallMenu);


  Menu ingameMenu = new Menu();

  ingameMenu.addElement(new  MenuImage(700, 300, 200, 600, IKey.EMPTY,         "bg_ingame.png"));
  ingameMenu.addElement(new   MenuText(700,  30, 100, 100, IKey.EMPTY,         "Niveau",         #9D16B5,   36));
  ingameMenu.addElement(new  MenuImage(700, 120, 100, 100, IKey.EMPTY,         "hoodGlitched.png"));
  ingameMenu.addElement(new   MenuText(700, 190, 100, 100, IKey.EMPTY,         "PlayerName",     #00AAAA, 36));
  ingameMenu.addElement(new   MenuText(700, 260, 100, 100, IKey.EMPTY,         "Fragments:",     WHITE,   32));
  ingameMenu.addElement(new   MenuText(700, 290, 100, 100, IKey.EMPTY,         "0",              WHITE,   36, digitalFont));
  ingameMenu.addElement(new   MenuText(700, 360, 100, 100, IKey.EMPTY,         "Durée du hack:", WHITE,   32));
  ingameMenu.addElement(new   MenuText(633, 390, 100, 100, IKey.EMPTY,         "00:00:000",      WHITE,   36, digitalFont, LEFT, CENTER));
  ingameMenu.addElement(new MenuButton(700, 475, 180,  50, IKey.RESET_LEVEL,   "Recommencer",    WHITE,   36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  ingameMenu.addElement(new MenuButton(700, 550, 180,  50, IKey.TO_LEVEL_MENU, "Quitter",        WHITE,   36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));

  gameEngine.getMenuDisplay().addMenu("ingameMenu", ingameMenu);


  Menu editorMenu = new Menu();

  editorMenu.addElement(new  MenuImage(700, 300, 200, 600, IKey.EMPTY,                 "bg_ingame.png"));
  editorMenu.addElement(new  MenuImage(665,  40,  60,  60, IKey.EDITOR_TILE_START,     "editor_virus.png"));
  editorMenu.addElement(new  MenuImage(735,  40,  60,  60, IKey.EDITOR_TILE_EXIT,      "editor_exit.png"));
  editorMenu.addElement(new  MenuImage(665, 110,  60,  60, IKey.EDITOR_TILE_EMPTY,     "editor_empty.png"));
  editorMenu.addElement(new  MenuImage(735, 110,  60,  60, IKey.EDITOR_TILE_WALL,      "editor_wall.png"));
  editorMenu.addElement(new  MenuImage(665, 180,  60,  60, IKey.EDITOR_TILE_DATA,      "editor_data.png"));
  editorMenu.addElement(new  MenuImage(735, 180,  60,  60, IKey.EDITOR_TILE_ANTIVIRUS, "editor_antivirus.png"));
  editorMenu.addElement(new  MenuImage(665, 250,  60,  60, IKey.EDITOR_TILE_DIR_DOWN,  "editor_direction_down.png"));
  editorMenu.addElement(new  MenuImage(735, 250,  60,  60, IKey.EDITOR_TILE_DIR_UP,    "editor_direction_up.png"));
  editorMenu.addElement(new  MenuImage(665, 320,  60,  60, IKey.EDITOR_TILE_DIR_RIGHT, "editor_direction_right.png"));
  editorMenu.addElement(new  MenuImage(735, 320,  60,  60, IKey.EDITOR_TILE_DIR_LEFT,  "editor_direction_left.png"));
  editorMenu.addElement(new  MenuImage(665, 390,  60,  60, IKey.EDITOR_TILE_FREEZE,    "editor_freeze.png"));
  editorMenu.addElement(new MenuButton(700, 450, 180,  36, IKey.EDITOR_SAVE,  "Sauvegarder", WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  editorMenu.addElement(new MenuButton(700, 490, 180,  36, IKey.EDITOR_LOAD,  "Charger",     WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  editorMenu.addElement(new MenuButton(700, 530, 180,  36, IKey.EDITOR_RESET, "Recommencer", WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));
  editorMenu.addElement(new MenuButton(700, 570, 180,  36, IKey.TO_MAIN_MENU, "Quitter",     WHITE, 36, defaultFont, MENU_BUTTON_BG, MENU_BUTTON_FG));

  gameEngine.getMenuDisplay().addMenu("editorMenu", editorMenu);


  Menu victoryPopup = new Menu();

  victoryPopup.addElement(new        MenuImage(300, 300, 400, 180, IKey.EMPTY,             "popup_win.png"));
  victoryPopup.addElement(new MenuGlitchedText(300, 250, 100, 100, IKey.EMPTY,             "Hack reussi",       WHITE, 48, titleFont));
  victoryPopup.addElement(new       MenuButton(180, 350, 100,  50, IKey.TO_PREVIOUS_LEVEL, "Niveau\nprécédent", WHITE, 24, defaultFont, WIN_BUTTON_BG, WIN_BUTTON_FG));
  victoryPopup.addElement(new       MenuButton(300, 350, 100,  50, IKey.HIDE_VICTORY,      "Fermer",            WHITE, 24, defaultFont, WIN_BUTTON_BG, WIN_BUTTON_FG));
  victoryPopup.addElement(new       MenuButton(420, 350, 100,  50, IKey.TO_NEXT_LEVEL,     "Niveau\nsuivant",   WHITE, 24, defaultFont, WIN_BUTTON_BG, WIN_BUTTON_FG));

  gameEngine.getMenuDisplay().addMenu("victoryPopup", victoryPopup);


  Menu failurePopup = new Menu();

  failurePopup.addElement(new        MenuImage(300, 300, 470, 180, IKey.EMPTY,       "popup_fail.png"));
  failurePopup.addElement(new MenuGlitchedText(300, 250, 100, 100, IKey.EMPTY,       "Alerte Systeme", WHITE, 48, titleFont));
  failurePopup.addElement(new       MenuButton(300, 350, 120,  50, IKey.RESET_LEVEL, "Recommencer",    WHITE, 24, defaultFont, FAIL_BUTTON_BG, FAIL_BUTTON_FG));
  
  gameEngine.getMenuDisplay().addMenu("failurePopup", failurePopup);


  Menu errorPopup = new Menu();

  errorPopup.addElement(new        MenuImage(400, 300, 470, 180, IKey.EMPTY,       "popup_fail.png"));
  errorPopup.addElement(new MenuGlitchedText(400, 250, 100, 100, IKey.EMPTY,       "Erreur",         WHITE, 48, titleFont));
  errorPopup.addElement(new     MenuTextArea(175, 280, 450, 100, IKey.EMPTY,       "Texte d'erreur", WHITE, 26, defaultFont, CENTER, TOP));
  errorPopup.addElement(new       MenuButton(400, 350, 120,  30, IKey.CLOSE_ERROR, "Fermer",         WHITE, 24, defaultFont, FAIL_BUTTON_BG, FAIL_BUTTON_FG));
  
  gameEngine.getMenuDisplay().addMenu("errorPopup", errorPopup);


  gameEngine.getMenuDisplay().showMenu("mainMenu");

}

void mouseClicked() {
  gameEngine.onClick();
}

void keyPressed() {
  gameEngine.onKeyPress();
  utils.easterEgg();
}

void draw() {

  //Avant tout dessin, on actualise l'état du jeu
  gameEngine.update();

  background(menuTextures.getTexture("background.png"));
  gameEngine.draw();
  
}
