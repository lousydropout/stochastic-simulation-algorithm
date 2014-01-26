BufferedReader reader;
String fline;
int x1 = 0;
int x2 = 0;
int y1 = 0;
int y2 = 0;

boolean started = false, ready = false;

void setup() {
  size(700, 700);
  background(0);
  stroke(255);
  reader = createReader("../data.out");
  frameRate(240);
}

void draw() {
  try {
    fline = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    fline = null;
  }
  
  if (fline == null) {
    noLoop();
    println("Simulation has ended.");
  } else {
    String[] pieces = split(fline, ", ");
    x1 = x2;
    y1 = y2;
    x2 = int(pieces[1]) / 10;
    y2 = height - int(pieces[2]) / 10;
    if (ready == true) {
      line(x1, y1, x2, y2);
    } else if (started == true) {
      ready = true;
    } else {
      started = true;
    }
  }
}
