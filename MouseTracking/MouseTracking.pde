import java.awt.*;
import java.util.Date;

Robot robot;
MousePoint mouse, pmouse;
float scl = 0.25;
ArrayList<MousePoint> history = new ArrayList<MousePoint>();
boolean hold = false;

int[][] visits;
PImage heatmap;

class MousePoint {

  int x;
  int y;
  long time;

  MousePoint(int x, int y, long time) {
    this.x = x;
    this.y = y;
    this.time = time;
  }
}

void settings() {
  size(floor(displayWidth * scl), floor(displayHeight * scl));
}

void startRobot() {
  try { 
    robot = new Robot();
  } 
  catch(Exception e) {
    println(e);
  }
  int buttons = MouseInfo.getNumberOfButtons();
  if (buttons < 0) {
    println("no mouse");
    exit();
  }
}
void setup() {
  background(0);
  //frameRate(30);
  startRobot();
  visits = new int[width][height];
  heatmap = createImage(width, height, RGB);
}

void saveData() {
  hold = true;
  String[] rows = new String[history.size()];
  int index = 0;
  for (MousePoint p : history) {
    rows[index] = p.x + "," + p.y + "," + p.time;
    index++;
  }
  saveStrings("data/mouse" + new Date().getTime() + ".csv", rows);
  history.clear();
  hold = false;
}

void draw() {
  scale(scl);
  //blendMode(ADD);

  if (mouse != null && pmouse != null && pmouse != mouse) {
    int x = int(mouse.x * scl);
    int y = int(mouse.y * scl);
    if (x > -1 && y > -1) {
      //visits[x][y]++;
      // println(visits[x][y], x, y);
    }
    stroke(255, 100);
    strokeWeight(2);
    line(mouse.x, mouse.y, pmouse.x, pmouse.y);
    //noStroke();
    //fill(2, 1, 1);
    //circle(mouse.x, mouse.y, 16);
  }
  pmouse = mouse;

  // once per minute
  if (history.size() > 100000) {
    saveData();
  }
  trackMouse();
  //image(heatmap, 0, 0);
  //println(frameRate);
}

void mousePressed() {
  saveData();
  //heatmap.loadPixels();
  //colorMode(HSB);

  //int maxVisits = 0;
  //for (int i = 0; i < heatmap.width; i++) {
  //  for (int j = 0; j < heatmap.height; j++) {
  //    maxVisits = max(maxVisits, visits[i][j]);
  //  }
  //}

  //if (maxVisits > 500) {
  //  maxVisits = 500;
  //}
  // println(maxVisits);

  //for (int i = 0; i < heatmap.width; i++) {
  //  for (int j = 0; j < heatmap.height; j++) {
  //    float total = max(500, getNeighborhood(i, j, 3));
  //    float maxHue = 100;
  //    float hue = map(total, 0, maxVisits, maxHue, 0);
  //    int pindex = i+j*heatmap.width;
  //    heatmap.pixels[pindex] = color(hue, 255, 255);
  //  }
  //}
  //heatmap.updatePixels();
}

float getNeighborhood(int x, int y, int offset) {
  int sum = 0;
  int count = 0;
  for (int i = x-offset; i < x + offset; i++) {
    for (int j = y-offset; j < y + offset; j++) {
      if (i > -1 && i < width && j > -1 && j < height) {
        sum += visits[i][j];
        count++;
      }
    }
  }
  return float(sum) / float(count);
}




void trackMouse() {
  try {
    PointerInfo pInfo = MouseInfo.getPointerInfo();
    Point point = pInfo.getLocation();
    int x = (int) point.getX();
    int y = (int) point.getY();
    mouse = new MousePoint(x, y, new Date().getTime());
    if (!hold) {
      history.add(mouse);
    }
    //int wait = 33;//robot.getAutoDelay();
    //robot.delay(wait);
    // delay(wait);
  } 
  catch(Exception e) {
    println(e);
  }
}
