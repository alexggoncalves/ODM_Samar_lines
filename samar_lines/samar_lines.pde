ChildApplet childA;
ChildApplet childB;

Canvas canvas;
float angle = 0;
PVector position = new PVector(0,0);

float movementAmount;

void setup(){
  size(800, 600);
  canvas = new Canvas(1000,1000);
}

void draw(){
  movementAmount = mouseX;
  background(255,255,255);
  canvas.drawCanvas();
}
