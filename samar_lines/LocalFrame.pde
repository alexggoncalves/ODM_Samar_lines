import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;

class LocalFrame extends PApplet {
  // Applet
  PApplet parent;
  int displayW, displayH;
  int id, x, y;
  static final int SCREEN_INDEX = 2;

  // Frame
  PImage frame;
  float frameScale;
  int w, h;
  color bckColor = color(0, 0, 0);
  color edgesColor = color(255, 255, 255);

  // Hand inactivity
  int lastHandDetectionTime;
  int inactivityTimeout = 500;
  boolean movementDetected;

  // Transition
  int transitionStart;
  int transitionDuration = 500;
  float initialTransitionValue;
  float currentTransitionValue = 0;
  float transitionTargetValue = 1;
  boolean onTransition = false;

  LineGenerator line = null;
  HandVisualizer handVisualizer;

  PGraphics output;

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
    output = createGraphics(w, h);
    initialTransitionValue = currentTransitionValue;
  }

  void settings() {
    if (FULLSCREEN) {
      fullScreen(SCREEN_INDEX);
      this.smooth(0);
    } else {
      size(windowedWidth, windowedHeight);
    }
  }

  void draw() {
    if (line == null) line = fullCanvas.line;
    background(bckColor);

    // Check if there are any hands and handle movement/color transition
    handleHandPresence();
    line.setSpeedMultiplier(currentTransitionValue);

    // Draw elements
    fill(0, 255, 0);

    image(frame, 0, 0, displayW, displayH);

    handVisualizer.drawHandVisualizer(this);
    String txt = String.format("Frame %6.2f fps", frameRate);
    surface.setTitle(txt);
    
  }

  void handleHandPresence() {
  if (tracking.hands.size() == 0 && movementDetected && !onTransition) {
    movementDetected = false;
    lastHandDetectionTime = millis();
  } 
  else if (tracking.hands.size() > 0) {
    movementDetected = true;
    if (!onTransition) {
      initialTransitionValue = currentTransitionValue;
      transitionTargetValue = 1;
      transitionStart = millis();
      onTransition = true;
    }
  }

  // If no hand has been seen for the timeout duration, start stopping transition
  if (millis() - lastHandDetectionTime >= inactivityTimeout && !onTransition) {
    initialTransitionValue = currentTransitionValue;
    transitionTargetValue = 0;
    transitionStart = millis();
    onTransition = true;
  }

  // Apply the transition when it's active
  if (onTransition) {
    float elapsedTime = millis() - transitionStart;
    float t = elapsedTime / transitionDuration;
    t = constrain(t, 0, 1);
    float easedT = easeInOut(t);
    currentTransitionValue = lerp(initialTransitionValue, transitionTargetValue, easedT);

    // Check if transition is complete before setting onTransition to false
    if ((transitionTargetValue == 1 && currentTransitionValue >= 1) ||
        (transitionTargetValue == 0 && currentTransitionValue <= 0)) {
      currentTransitionValue = transitionTargetValue;
      onTransition = false;
    }
  }
}


  void setFrame(PGraphics canvas, PVector position) {
    // Top left corner of the view (source canvas)
    int x1 = round(position.x - w / 2);
    int y1 = round(position.y - h / 2);

    float brightnessMultiplier = currentTransitionValue;
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
          if (c != color(0, 0)) {
            frame.pixels[frameIndex] = color(brightnessMultiplier*red(c), brightnessMultiplier*green(c), brightnessMultiplier*blue(c), alpha(c));
          }
        } else {
          // If the source coordinates are outside the canvas, use the edges color
          frame.pixels[frameIndex] = color(255);
        }
      }
    }
    frame.updatePixels();
  }

  float easeInOut(float t) {
    if (t < 0.5) {
      return 2 * t * t;
    }
    return -1 + (4 - 2 * t) * t;
  }
}
