final boolean FULLSCREEN = true;
final int MAIN_SREEN_INDEX = 1;

LocalFrame localFrame;
Tracking tracking;
Canvas fullCanvas;

color canvasBackground = color(255, 255, 255);

float canvasScale = 1;
float frameScale = 0.1;
int windowedWidth = 1920;
int windowedHeight = 1080;

void settings() {

  if (FULLSCREEN) {
    fullScreen(P2D, MAIN_SREEN_INDEX);
    pixelDensity(1);
    
  } else {
    size(windowedWidth, windowedHeight, P2D);
  }
}

void setup() {
  localFrame = new LocalFrame(this, 0, 0, 0, frameScale);
  fullCanvas = new Canvas(localFrame, canvasScale);
  tracking = new Tracking(this);
}

void draw() {
  //background(canvasBackground);
  noStroke();
  tracking.receiveData();
  fullCanvas.drawCanvas();
}

void dispose() {
  // Stop the server when the window is closing
  tracking.closeServer();
  localFrame.dispose();
  super.dispose();
}

void mousePressed(){
 fullCanvas.addShape(); 
}
