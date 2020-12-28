public class Utils {

  private String         specialChars   = " àâéèêîôùû";
  private Queue<Integer> surprise;
  private int[]          surpriseValues = {38, 38, 40, 40, 37, 39, 37, 39, 66, 81, 10};


	public Utils() {
    surprise = new LinkedList<Integer>();
	}

  //Fusionner une image à la frame en cours, mode de fusion: couleur
	public void blendColor(PImage blendImg, int xBlend, int yBlend) {

		colorMode(HSB, 360, 100, 100, 1);

		loadPixels();
		blendImg.loadPixels();
		
		for (int x = 0; x < blendImg.width && x + xBlend < width; x++) {

      if (x + xBlend < 0) continue;

			for (int y = 0; y < blendImg.height && y + yBlend < height; y++) {

        if (y + yBlend < 0) continue;

        color srcPixel = blendImg.pixels[x + y * blendImg.width];
        color dstPixel = pixels[x + xBlend + (y + yBlend) * width];

        float srcAlp =      alpha(srcPixel);
        float srcHue =        hue(srcPixel);
        float srcSat = saturation(srcPixel);
        float dstHue =        hue(dstPixel);
        float dstSat = saturation(dstPixel);

				float tmpHue = lerp(dstHue, srcHue, srcAlp); //Pondéré par la transparence de l'image à fusionner
				float tmpSat = lerp(dstSat, srcSat, srcAlp); //Idem
				float tmpBri = brightness(dstPixel);

        pixels[x + xBlend + (y + yBlend) * width] = color(tmpHue, tmpSat, tmpBri);

			}

		}

		updatePixels();

		colorMode(RGB, 255, 255, 255, 255);
	}

  public boolean isAlphaNumWithAccents(char c) {
    return (c >= 'a' && c <= 'z')
        || (c >= 'A' && c <= 'Z')
        || (c >= '0' && c <= '9')
        || specialChars.indexOf(c) > -1;
  }

  //Volontairement non commenté. ;)
  public void easterEgg() {

    surprise.add(keyCode);

    if (surprise.size() > surpriseValues.length) {
      surprise.poll();
    }

    boolean        flag = true;
    Queue<Integer>  tmp = new LinkedList<Integer>(surprise);

    for (int i = 0; i < surpriseValues.length && tmp.size() > 0; i++) {
      if (surpriseValues[i] != tmp.poll()) {
        flag = false;
      }
    }

    if (flag && surprise.size() == 11) {
      easterEgg = !easterEgg;
    }

  }

}
