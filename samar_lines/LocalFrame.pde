class LocalFrame extends PApplet {
  int id, x, y, w, h;
  int bckColor;
  
  int hOffset = 0;
  int vOffset = 0;
  
  
  PImage frame;

  LocalFrame(int id, int x, int y, int w, int h) {
    super();
    this.id = id;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    frame = new PImage(w,h);

    PApplet.runSketch(new String[] { this.getClass().getName() }, this);
  }

  void settings() {
    size(w, h, P2D);
    smooth(0);
  }

  void setup() {
    windowMove(x, y);
    windowResizable(true);
  }

  void draw() {
    background(bckColor);
    
    image(frame,0,0,w,h);
    
    String txt = String.format("Frame   %6.2fps", frameRate);
    windowTitle(txt);
  }
  
  void setFrame(PGraphics canvas, PVector position){
    int x1 = floor(position.x - w/2);
    int y1 = floor(position.y - h/2);
    
    hOffset = max(0, width/2 - x1);
    vOffset = max(0, height/2 - y1);
    
    int x2 = floor(position.x + w/2);
    int y2 = floor(position.y + h/2);
    
  frame = canvas.get(max(0, x1), max(0, y1), min(canvas.width, x2), min(canvas.height, y2));
  }
  
}
