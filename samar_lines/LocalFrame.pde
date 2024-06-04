import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.Rectangle;

class LocalFrame extends PApplet {
  PApplet parent;
  int id, x, y, w, h;
  float wScale = 1;
  float hScale = 1;
  int bckColor = color(255, 255, 255); // Set a default background color
  
  PImage frame;
  HandVisualizer handVisualizer;

  LocalFrame(PApplet parent, int id, int x, int y, int w, int h) {
    super();
    this.id = id;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.parent = parent;
    
    frame = createImage(w, h, RGB); // Initialize with the correct size and type
    handVisualizer = new HandVisualizer(w,h,wScale,hScale);

    PApplet.runSketch(new String[] { this.getClass().getName() }, this);
  }

  void settings() {
    // Set the size
    if(FULLSCREEN){
      fullScreen(SECONDARY_SCREEN);
    } else {
      size(windowedWidth, windowedHeight);
    }
   
    smooth(0);
  }

  void draw() {
    background(bckColor);
    
    fill(0,255,0);
    synchronized (frame) { // Synchronize to avoid concurrent access issues
      image(frame, 0, 0, width, height);
      handVisualizer.drawHandVisualizer(this);
    } 
    
    String txt = String.format("Frame   %6.2f fps", frameRate);
    windowTitle(txt);
  }

  void setFrame(PGraphics canvas, PVector position) {
    wScale = (float) w/width;
    hScale = (float) h/height;
    int x1 = round(position.x - w / 2);
    int y1 = round(position.y - h / 2);
    int x2 = round(position.x + w / 2);
    int y2 = round(position.y + h / 2);
    
    // Check for limits and set exceeding offset in the x axis
    int xOffset1 = 0;
    int xOffset2 = 0;
    if(x1 < 0){
      xOffset1 = -x1;
      x1 = 0;
    }else if(x2 > canvas.width){
      xOffset2 = x2 - canvas.width;
      x2 = canvas.width;
    }
    
    // Check for limits and set exceeding offset in the y axis
    int yOffset1 = 0;
    int yOffset2 = 0;
    if(y1 < 0){
      yOffset1 = - y1;
      y1 = 0;
    } else if(y2> canvas.height){
      yOffset2 = y2 - canvas.height;
      y2 = canvas.height;
    }
    
    // Source (canvas)
    int sourceX = x1;
    int sourceY = y1;
    int sourceW = x2 - x1;
    int sourceH = y2 - y1;
    // Destination (frame)
    int destX = round(xOffset1);
    int destY = round(yOffset1);
    int destW = w - round((xOffset1 + xOffset2));
    int destH = h - round((yOffset1 + yOffset2));
  
    synchronized (frame) { // Synchronize to avoid concurrent access issues
      frame.copy(canvas,
                 sourceX, sourceY, sourceW, sourceH,
                 destX, destY, destW, destH
      );
    }
  }
}
