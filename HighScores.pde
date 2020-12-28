public class HighScores {

  private JSONArray _scores;

  public HighScores() {
    _scores = loadJSONArray("data/scores.json");
  }

  public void update(int level, String name, int score, int time) {

    int playerIndex = _scores.size();

    //Recherche du joueur dans le JSONArray
    for (int i = 0; i < playerIndex; i++) {
      if (_scores.getJSONObject(i).getString("name").equals(name)) {
        playerIndex = i;
      }
    }

    //Si le joueur n'est pas dans le JSONArray, on l'y ajoute
    if (playerIndex == _scores.size()) {

      JSONObject playerJSON = new JSONObject();

      playerJSON.setString("name", name);

      JSONArray  scoreJSON  = new JSONArray();
      JSONArray  timeJSON   = new JSONArray();

      for (int i = 0; i < NUMBER_OF_LEVELS; i++) {
        scoreJSON.append(-1);
        timeJSON.append(-1);
      }

      playerJSON.setJSONArray("scores", scoreJSON); //Scores de chaque niveau
      playerJSON.setJSONArray("times", timeJSON);   //Temps de chaque niveau
      playerJSON.setInt("levelsCleared", 0);        //Nombre de niveaux terminés
      playerJSON.setInt("totalScore", 0);           //Score total
      playerJSON.setInt("totalTime", 0);            //Temps total

      _scores.append(playerJSON);

    }

    int bestScore = _scores.getJSONObject(playerIndex).getJSONArray("scores").getInt(level - 1);
    int bestTime  = _scores.getJSONObject(playerIndex).getJSONArray("times").getInt(level - 1);

    // Critères de record personnel pour un niveau:
    // - Aucun record enregistré (-1), ou
    // - Plus de bonus ramassés, ou
    // - Autant de bonus ramassés, meilleur temps 
    if (bestScore == -1 || score > bestScore || (score == bestScore && time < bestTime)) {
      _scores.getJSONObject(playerIndex).getJSONArray("scores").setInt(level - 1, score);
      _scores.getJSONObject(playerIndex).getJSONArray("times").setInt(level - 1, time);
    }

    //Calcul du nombre de niveaux finis et actualisation dans le JSON
    int levelsCleared = 0,
        totalScore    = 0,
        totalTime     = 0;

    for (int i = 0; i < NUMBER_OF_LEVELS; i++) {

      int tmpScore = _scores.getJSONObject(playerIndex).getJSONArray("scores").getInt(i);

      if (tmpScore > -1) {

        levelsCleared++;
        totalScore += tmpScore;
        totalTime  += _scores.getJSONObject(playerIndex).getJSONArray("times").getInt(i);

      }

    }

    _scores.getJSONObject(playerIndex).setInt("levelsCleared", levelsCleared);
    _scores.getJSONObject(playerIndex).setInt("totalScore", totalScore);
    _scores.getJSONObject(playerIndex).setInt("totalTime", totalTime);

    saveJSONArray(_scores, "data/scores.json");
    
  }

  public String[] getHighScores() {

    //Extraire les meilleurs joueurs
    JSONArray bestScores = new JSONArray();

    for (int i = 0; i < NUMBER_OF_TOP_SCORES; i++) {
      bestScores.setString(i, null); //Apparemment, seul setString() permet d'append null (initialisation)
    }

    for (int i = 0; i < _scores.size(); i++) {

      //Copie en dur nécessaire, sinon seulement la référence en mémoire est passée
      JSONObject tmpObj = new JSONObject();
      tmpObj.setString("name",       _scores.getJSONObject(i).getString("name"));
      tmpObj.setInt("levelsCleared", _scores.getJSONObject(i).getInt("levelsCleared"));
      tmpObj.setInt("totalScore",    _scores.getJSONObject(i).getInt("totalScore"));
      tmpObj.setInt("totalTime",     _scores.getJSONObject(i).getInt("totalTime"));

      for (int j = 0; j < bestScores.size(); j++) {

        if (bestScores.isNull(j)) {
          //Pas de score existant, on peut ajouter
          bestScores.setJSONObject(j, tmpObj);
          break;
        }

        //Si on bat le record parcouru, on le remplace. Il va ensuite descendre à la manière d'un bubble sort
        JSONObject curBest = new JSONObject();
        curBest.setString("name",       bestScores.getJSONObject(j).getString("name"));
        curBest.setInt("levelsCleared", bestScores.getJSONObject(j).getInt("levelsCleared"));
        curBest.setInt("totalScore",    bestScores.getJSONObject(j).getInt("totalScore"));
        curBest.setInt("totalTime",     bestScores.getJSONObject(j).getInt("totalTime"));

        if ( (tmpObj.getInt("levelsCleared") >  curBest.getInt("levelsCleared"))
        ||   (tmpObj.getInt("levelsCleared") == curBest.getInt("levelsCleared") && tmpObj.getInt("totalScore") >  curBest.getInt("totalScore"))
        ||   (tmpObj.getInt("levelsCleared") == curBest.getInt("levelsCleared") && tmpObj.getInt("totalScore") == curBest.getInt("totalScore") && tmpObj.getInt("totalTime") < curBest.getInt("totalTime")) ) {

          JSONObject tmp = new JSONObject();
          tmp.setString("name",       curBest.getString("name"));
          tmp.setInt("levelsCleared", curBest.getInt("levelsCleared"));
          tmp.setInt("totalScore",    curBest.getInt("totalScore"));
          tmp.setInt("totalTime",     curBest.getInt("totalTime"));

          bestScores.getJSONObject(j).setString("name",       tmpObj.getString("name"));
          bestScores.getJSONObject(j).setInt("levelsCleared", tmpObj.getInt("levelsCleared"));
          bestScores.getJSONObject(j).setInt("totalScore",    tmpObj.getInt("totalScore"));
          bestScores.getJSONObject(j).setInt("totalTime",     tmpObj.getInt("totalTime"));

          tmpObj.setString("name",       curBest.getString("name"));
          tmpObj.setInt("levelsCleared", curBest.getInt("levelsCleared"));
          tmpObj.setInt("totalScore",    curBest.getInt("totalScore"));
          tmpObj.setInt("totalTime",     curBest.getInt("totalTime"));

        }

      }

    }

    //Mise en forme des valeurs à retourner
    String[] formattedBest = new String[20];

    for (int i = 0; i < NUMBER_OF_TOP_SCORES; i++) {

      if (!bestScores.isNull(i)) {
        int tmp     = bestScores.getJSONObject(i).getInt("totalTime");
        int millis  = tmp % 1000;
        int seconds = (tmp / 1000) % 60;
        int minutes = tmp / 60000;

        formattedBest[4 * i]     =    bestScores.getJSONObject(i).getString("name");
        formattedBest[4 * i + 1] = nf(bestScores.getJSONObject(i).getInt("levelsCleared"), 2);
        formattedBest[4 * i + 2] = nf(bestScores.getJSONObject(i).getInt("totalScore")   , 2);
        formattedBest[4 * i + 3] = nf(minutes, 2) + ":" + nf(seconds, 2) + "." + nf(millis, 3);
      }
      else {
        formattedBest[4 * i]     = "N0N3";
        formattedBest[4 * i + 1] = "00";
        formattedBest[4 * i + 2] = "00";
        formattedBest[4 * i + 3] = "00:00.000";
      }
      
    }

    return formattedBest;

  }

  public boolean hasClearedLevel(String playerName, int level) {

    if (level > NUMBER_OF_LEVELS) {
      return false;
    }

    //Renvoie vrai si le joueur existe et s'il a un score différent de -1 (valeur par défaut)
    for (int i = 0; i < _scores.size(); i++) {
        if (_scores.getJSONObject(i).getString("name").equals(playerName)) {
          return _scores.getJSONObject(i).getJSONArray("scores").getInt(level - 1) != -1;
        }
    }

    //Joueur non trouvé, on renvoie faux
    return false;

  }

}
