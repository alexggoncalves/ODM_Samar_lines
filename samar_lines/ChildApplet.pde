class ChildApplet extends PApplet {
  int id, vx, vy, vw, vh;
  int bckColor;

  ChildApplet(int id, int vx, int vy, int vw, int vh) {
    super();
    this.id = id;
    this.vx = vx;
    this.vy = vy;
    this.vw = vw;
    this.vh = vh;

    PApplet.runSketch(new String[] { this.getClass().getName() }, this);
  }

  void settings() {
    size(vw, vh, P2D);
    smooth(0);
    println("Creating window "+ id);
  }

  void setup() {
    windowMove(vx, vy);
    windowResizable(true);
  }

  void draw() {
    background(bckColor);
    textAlign(CENTER, CENTER);
    text("CHILD window "+ id, width/2, height/2);

    String txt = String.format("Window %d   %6.2fps", id, frameRate);
    windowTitle(txt);
  }
}
