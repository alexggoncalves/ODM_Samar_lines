import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;

class LocalFrame extends PApplet {
  PApplet parent;
  int id, x, y, w, h;
  float frameScale;
  int displayW;
  int displayH;
  color bckColor = color(0, 0, 0);
  color edgesColor = color(255, 255, 255);

  PImage frame;
  HandVisualizer handVisualizer;
  static final int SCREEN_INDEX = 2;

  LocalFrame(PApplet parent, int id, int x, int y, float frameScale) {
    super();
    this.id = id;
    this.x = x;
    this.y = y;
    this.frameScale = frameScale;
    this.parent = parent;

    PApplet.runSketch(new String[] { this.getClass().getName() }, this);

    if (FULLSCREEN) {
      GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
      GraphicsDevice[] screens = ge.getScreenDevices();

      if (screens.length >= SCREEN_INDEX) {
        
        displayW = screens[SCREEN_INDEX - 1].getDisplayMode().getWidth();
        displayH = screens[SCREEN_INDEX - 1].getDisplayMode().getHeight();
        frameScale = frameScale * (float(baseWidth)/float(displayW));
        
        w  = round(displayW * frameScale);
        h  = round(displayH * frameScale);
      }
    } else {
      displayW = windowedWidth;
      displayH = windowedHeight;
      w = round(displayW * frameScale);
      h = round(displayH * frameScale);
    }


    frame = createImage(w, h, ARGB);
    handVisualizer = new HandVisualizer(width, height, frameScale);
  }

  void settings() {
    if (FULLSCREEN) {
      fullScreen(SCREEN_INDEX);
      this.smooth(0);
      
    } else {
      size(windowedWidth,windowedHeight);
    }
    
  }
  

  void draw() {
    background(bckColor);
    fill(0, 255, 0);

    image(frame, 0, 0, displayW, displayH);
    handVisualizer.drawHandVisualizer(this);

    String txt = String.format("Frame %6.2f fps", frameRate);
    surface.setTitle(txt);
  }

  void setFrame(PGraphics canvas, PVector position) {
    // Top left corner of the view (source canvas)
    int x1 = round(position.x - w / 2);
    int y1 = round(position.y - h / 2);
    float brightnessMultiplier = float(mouseX)/float(width);
    
    color backgroundColor = color(255-(brightnessMultiplier * 255));

    //frame.loadPixels();
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        
        int frameIndex = x + y * w;
        int sourceX = x1 + x;
        int sourceY = y1 + y;
        
        frame.pixels[frameIndex] = backgroundColor;

        if (sourceX >= 0 && sourceX < canvas.width && sourceY >= 0 && sourceY < canvas.height) {
          color c = canvas.get(sourceX, sourceY);
          color noTransparencyColor = color(red(c),green(c),blue(c),255);
          
          
          //frame.pixels[frameIndex] = c;
          
          float brightness = (red(noTransparencyColor) + green(noTransparencyColor) + blue(noTransparencyColor)) / 3;
          
          
          if (brightness > 0.1) {
            frame.pixels[frameIndex] = color(brightnessMultiplier*red(noTransparencyColor),brightnessMultiplier*green(noTransparencyColor),brightnessMultiplier*blue(noTransparencyColor),alpha(c)* brightnessMultiplier);
          } else {
            //frame.pixels[frameIndex] = 
           }
        } else {
          // If the source coordinates are outside the canvas, use the edges color
          frame.pixels[frameIndex] = backgroundColor;
        }
      }
    }
    frame.updatePixels();
  }
}
