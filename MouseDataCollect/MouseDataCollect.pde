import java.awt.*;
import java.util.Date;

Robot robot;
MousePoint mouse, pmouse;
ArrayList<MousePoint> history = new ArrayList<MousePoint>();
float scl   = 0.25;
boolean hold = false;

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
  startRobot();
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

  if (mouse != null && pmouse != null && pmouse != mouse) {
    stroke(255, 100);
    strokeWeight(2);
    line(mouse.x, mouse.y, pmouse.x, pmouse.y);
  }
  // save every 100,000 datapoints
  if (history.size() > 100000) {
    saveData();
  }
  trackMouse();
}

void mousePressed() {
  // Force save
  saveData();
}

boolean same(MousePoint m1, MousePoint m2) {
  return (m1.x == m2.x && m1.y == m2.y);
}

void trackMouse() {
  try {
    PointerInfo pInfo = MouseInfo.getPointerInfo();
    Point point = pInfo.getLocation();
    int x = (int) point.getX();
    int y = (int) point.getY();
    pmouse = mouse;
    mouse = new MousePoint(x, y, new Date().getTime());
    if (!hold && !same(pmouse, mouse)) {
      history.add(mouse);
    }
    // int wait = 33;//robot.getAutoDelay();
    // robot.delay(wait);
    // delay(wait);
  } 
  catch(Exception e) {
    println(e);
  }
}
