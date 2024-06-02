final boolean FULLSCREEN = true;
final int MAIN_SCREEN = 0;
final int SECONDARY_SCREEN = 1;

LocalFrame localFrame;
Tracking tracking;
Canvas canvas;

float canvasScale = 7;
int frameWidth = 480;
int frameHeight = 270;

void settings(){
  if(FULLSCREEN){
    fullScreen(P2D,SECONDARY_SCREEN);
  } else {
    size(frameWidth, frameHeight,P2D);
  }
}

void setup(){
  
  tracking = new Tracking(this);
  
  localFrame = new LocalFrame(0,0,0,frameWidth,frameHeight);
  canvas = new Canvas((int)canvasScale * frameWidth,(int)canvasScale * frameHeight, localFrame);
}

void draw(){
  background(255,255,255);
  tracking.receiveData();
  
  
  canvas.drawCanvas();
}

 void dispose() {
    // Stop the server when the window is closing
    tracking.closeServer();
    localFrame.dispose();
    super.dispose();
  }
