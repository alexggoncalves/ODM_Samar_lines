import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;

class LocalFrame extends PApplet {
  PApplet parent;
  int id, x, y, w, h;
  float frameScale;
  int displayW;
  int displayH;
  int bckColor = color(0, 0,0); // Set a default background color
  
  PImage frame;
  HandVisualizer handVisualizer;
  static final int SCREEN_INDEX = 2; // Define the secondary screen index

  LocalFrame(PApplet parent, int id, int x, int y, float frameScale) {
    super();
    this.id = id;
    this.x = x;
    this.y = y;
    this.frameScale = frameScale;
    this.parent = parent;
    
    PApplet.runSketch(new String[] { this.getClass().getName() }, this);
    
    GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
    GraphicsDevice[] screens = ge.getScreenDevices();
    
    if (screens.length >= SCREEN_INDEX) {
      displayW = screens[SCREEN_INDEX - 1].getDisplayMode().getWidth();
      displayH = screens[SCREEN_INDEX - 1].getDisplayMode().getHeight();
      w  = int(displayW * frameScale);
      h  = int(displayH * frameScale);
    }
    
    frame = createImage(w, h, ARGB); // Initialize with the correct size and type
    handVisualizer = new HandVisualizer(displayW, displayH, frameScale);
  }

  void settings() {
    if (FULLSCREEN) {
      fullScreen(SCREEN_INDEX);
      
    } else {
      size(displayW / 2, displayH / 2);
    }
    smooth(0);
  }


  void draw() {
    background(bckColor);
    fill(0, 255, 0);
    synchronized (frame) { // Synchronize to avoid concurrent access issues
      image(frame, 0, 0, displayW, displayH);
      handVisualizer.drawHandVisualizer(this);
    }
    String txt = String.format("Frame %6.2f fps", frameRate);
    surface.setTitle(txt);
  }

  void setFrame(PGraphics canvas, PVector position) {
    int x1 = floor(position.x - w / 2);
    int y1 = floor(position.y - h / 2);
    int x2 = floor(position.x + w / 2);
    int y2 = floor(position.y + h / 2);
    
    int xOffset1 = 0;
    int xOffset2 = 0;
    if (x1 < 0) {
      xOffset1 = -x1;
      x1 = 0;
    } else if (x2 > canvas.width) {
      xOffset2 = x2 - canvas.width;
      x2 = canvas.width;
    }
    
    int yOffset1 = 0;
    int yOffset2 = 0;
    if (y1 < 0) {
      yOffset1 = -y1;
      y1 = 0;
    } else if (y2 > canvas.height) {
      yOffset2 = y2 - canvas.height;
      y2 = canvas.height;
    }
    
    int sourceX = x1;
    int sourceY = y1;
    int sourceW = x2 - x1;
    int sourceH = y2 - y1;
    
    int destX = floor(xOffset1);
    int destY = floor(yOffset1);
    int destW = w - floor((xOffset1 + xOffset2));
    int destH = h - floor((yOffset1 + yOffset2));    
    

    
    if(frame != null){
      synchronized (frame) { // Synchronize to avoid concurrent access issues
      frame.copy(canvas, sourceX, sourceY, sourceW, sourceH, destX, destY, destW, destH);
    }
    }
}
}
