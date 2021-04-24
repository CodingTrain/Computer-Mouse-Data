


float[][] map;
void setup() {
  size(896, 560);
  map = new float[width][height];
  background(0);
  Table t = loadTable("mouse-896-560.csv");
  float maxCount = 0;
  for (TableRow row : t.rows()) {
    int count = row.getInt(2);
    int y = row.getInt(0);
    int x = row.getInt(1);
    map[x][y] = float(count);
  }


  // Gaussian blur over and over
  for (int i = 0; i < 10; i++) {
    map = blur(map, 25);
  }


  for (int i = 1; i < 20; i++) {
    maxCount = i;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        colorMode(HSB);
        float h = map(map[x][y], 0, maxCount, 255, 0);
        //h = constrain(h, 0, 100);
        stroke(h, 255, 255 - h/2);
        point(x, y);
      }
    }
    save("timelapse"+i+".png");
  }
}

float[][] blur(float[][] map, int matrix) {
  float kernel[][] = new float[matrix][matrix];
  float sigma = 1;
  float mean = matrix / 2;
  float sum = 0.0; 
  for (int x = 0; x < matrix; x++) {
    for (int y = 0; y < matrix; y++) {
      kernel[x][y] = exp(-0.5 * (pow((x - mean) / sigma, 2) + 
        pow((y - mean) / sigma, 2)))
        / (TWO_PI * sigma * sigma);
      sum += kernel[x][y];
    }
  }
  printArray(kernel[0]);

  for (int x = 0; x < matrix; x++) {
    for (int y = 0; y < matrix; y++) {
      kernel[x][y] /= sum;
    }
  }

  float[][] blurred = new float[width][height];

  int offset = matrix/2;
  for (int x = offset; x < width-offset; x++) {
    for (int y = offset; y < height-offset; y++) {
      float val = 0;
      for (int i = -offset; i <= offset; i++) {
        for (int j = -offset; j <= offset; j++) {
          val += map[x+i][y+j] * kernel[i+offset][j+offset];
        }
      }
      blurred[x][y] = val;
    }
  }
  return blurred;
}
