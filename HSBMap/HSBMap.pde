

Table mouseTable;
int index = 0;
void setup() {
  size(896, 560);
  mouseTable = loadTable("mouse1618158957199.csv");
  background(0);
}

void draw() {
  for (int i = 0; i < 100; i++) {
    TableRow row = mouseTable.getRow(index);
    float x = row.getInt(0)*0.5;
    float y = row.getInt(1)*0.5;
    index++;
    stroke(255,100);
    strokeWeight(8);
    point(x, y);


    if (index == mouseTable.getRowCount()) {
      filter(BLUR,2);
      save("mousemap.png");
      noLoop();
      break;
    }
  }
}
