public class Textures {

  private HashMap<String, PImage> _origTextures;
  private HashMap<String, PImage> _preloadedTextures;


  public Textures() {
    this("data/images/textures");
  }

  public Textures(String path) {

    _origTextures = new HashMap<String, PImage>();
    _preloadedTextures = new HashMap<String, PImage>();
    File[] textureFiles = listFiles(path);

    for (File texture: textureFiles) {
      PImage tmpTexture = loadImage(path + "/" + texture.getName());
      _origTextures.put(texture.getName(), tmpTexture);
      _preloadedTextures.put(texture.getName(), tmpTexture);
    }

  }

  //Redimensionne les textures avant utilisation
  //Très important en termes d'optimisation: redimensionner à la volée affecte beaucoup le CPU
  public void preload(int size) {

    if (size > 0) {

      //Récupération des clés de la hashmap originelle
      //Récupération dans un objet Set, converti en String[] (grâce à toArray() et au cast en début de ligne)
      String[] keys = (String[])_origTextures.keySet().toArray(new String[0]);

      for (String k: keys) {

        //Image temporaire à la nouvelle taille, et avec le même format de couleurs (RGB ou ARGB)
        PImage tmpImage = createImage(size, size, _origTextures.get(k).format);

        //Copie et redimensionne en même temps
        tmpImage.copy(_origTextures.get(k), 0, 0, _origTextures.get(k).width, _origTextures.get(k).height, 0, 0, size, size);

        _preloadedTextures.put(k, tmpImage);
        
      }

    }

  }

  public PImage getTexture(String hash) {
    return _preloadedTextures.get(hash);
  }


}
