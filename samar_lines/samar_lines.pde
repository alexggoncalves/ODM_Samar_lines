final boolean FULLSCREEN = true;
final int MAIN_SCREEN = 1;

LocalFrame localFrame;
Tracking tracking;
Canvas canvas;

color canvasBackground = color(255,255,255);

float canvasScale = 2;
float frameScale = 0.2;
int windowedWidth = 1920;
int windowedHeight = 1080;

void settings(){
  
  if(FULLSCREEN){
    fullScreen(P2D,MAIN_SCREEN);
    pixelDensity(1);
  } else {
    size(windowedWidth,windowedHeight,P2D);
  }
}

void setup(){
  background(canvasBackground);
  localFrame = new LocalFrame(this,0,0,0,frameScale);
  canvas = new Canvas(localFrame,canvasScale);
  tracking = new Tracking(this);
  
}

void draw(){
  
  noStroke();
  tracking.receiveData();
  canvas.drawCanvas();
}

 void dispose() {
    // Stop the server when the window is closing
    tracking.closeServer();
    localFrame.dispose();
    super.dispose();
  }
