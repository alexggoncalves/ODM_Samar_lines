final boolean FULLSCREEN = true;
final int MAIN_SREEN_INDEX = 1;

LocalFrame localFrame;
Tracking tracking;
Canvas fullCanvas;

color canvasBackground = color(255, 255, 255);

float canvasScale = 1.4;
float frameScale = 0.2;
int baseWidth = 2560;
int windowedWidth = 1920;
int windowedHeight = 1080;

void settings() {
  
  if (FULLSCREEN) {
    fullScreen(P2D,MAIN_SREEN_INDEX);
  } else {
    size(windowedWidth, windowedHeight, P2D);
  }
  //noSmooth();
}

void setup() {
  tracking = new Tracking(this);
  localFrame = new LocalFrame(this, 0, 0, 0, frameScale);
  fullCanvas = new Canvas(localFrame, canvasScale);
}

void draw() {
  background(canvasBackground);
  noStroke();
  tracking.receiveData();
  fullCanvas.drawCanvas();
  
  String txt = String.format("Frame %6.2f fps", frameRate);
    surface.setTitle(txt);
}

void dispose() {
  // Stop the server when the window is closing
  tracking.closeServer();
  localFrame.dispose();
  super.dispose();
}

void keyPressed(){
  if(key == 'b' && localFrame.currentTransitionValue > 0.5){
    fullCanvas.addShape();
  }
}
