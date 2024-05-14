LocalFrame localFrame;
Tracking tracking;
Canvas canvas;

float angle = 0;
PVector position = new PVector(0,0);
PVector direction = new PVector(1,0);

int canvasWidth = 5000;
int canvasHeight = 5000;

void setup(){ 
  size(600, 600);
  
  tracking = new Tracking(this);
  
  localFrame = new LocalFrame(0,0,0,canvasWidth/10,canvasHeight/10);
  canvas = new Canvas(canvasWidth,canvasHeight, localFrame);
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
