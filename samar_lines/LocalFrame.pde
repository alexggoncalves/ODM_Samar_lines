import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.Rectangle;

class LocalFrame extends PApplet {
  int id, x, y, w, h;
  int bckColor = color(255, 255, 255); // Set a default background color
  
  PImage frame;

  LocalFrame(int id, int x, int y, int w, int h) {
    super();
    this.id = id;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    frame = createImage(w, h, RGB); // Initialize with the correct size and type

    PApplet.runSketch(new String[] { this.getClass().getName() }, this);
  }

  void settings() {
    // Set the size
    fullScreen();
    //size(w, h);
   
    smooth(0);
  }

  void setup() {
    windowMove(x, y);
    windowResizable(false);
    // Get the graphics environment
    GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
    GraphicsDevice[] screens = ge.getScreenDevices();

    // Choose the screen index (0 for primary screen, 1 for secondary screen, etc.)
    int screenIndex = 1; // Change this to the index of the desired screen

    if (screenIndex < screens.length) {
    Rectangle screenBounds = screens[screenIndex].getDefaultConfiguration().getBounds();
    // Set the location of the window
    surface.setLocation(screenBounds.x, screenBounds.y); // Adjust offset as needed
  } else {
    println("Screen index out of range.");
  }
  }

  void draw() {
    background(bckColor);
    synchronized (frame) { // Synchronize to avoid concurrent access issues
      image(frame, 0, 0, width, height);
    }
    String txt = String.format("Frame   %6.2f fps", frameRate);
    windowTitle(txt);
  }

  void setFrame(PGraphics canvas, PVector position) {
    int x1 = constrain(floor(position.x - w / 2), 0, canvas.width - 1);
    int y1 = constrain(floor(position.y - h / 2), 0, canvas.height - 1);
    int x2 = constrain(floor(position.x + w / 2), 0, canvas.width - 1);
    int y2 = constrain(floor(position.y + h / 2), 0, canvas.height - 1);
    
    synchronized (frame) { // Synchronize to avoid concurrent access issues
      frame.copy(canvas, x1, y1, x2 - x1, y2 - y1, 0, 0, w, h);
    }
  }
}
