final boolean FULLSCREEN = true;
final int MAIN_SCREEN = 1;
final int SECONDARY_SCREEN = 2;

LocalFrame localFrame;
Tracking tracking;
Canvas canvas;

float canvasScale = 1.5;
float frameScale = 0.2;

int windowedWidth = 1920;
int windowedHeight = 1080;

void settings(){
  if(FULLSCREEN){
    fullScreen(P2D,MAIN_SCREEN);
  } else {
    size(windowedWidth,windowedHeight,P2D);
  }
}

void setup(){
  localFrame = new LocalFrame(this,0,0,0,floor(width *frameScale),floor(height * frameScale));
  canvas = new Canvas(floor(canvasScale * width),floor(canvasScale * height), localFrame);
  tracking = new Tracking(this);
}

void draw(){
  background(255,255,255);
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
