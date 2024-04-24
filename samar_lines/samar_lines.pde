PGraphics pg;

float angle = 0;
PVector canvasSize = new PVector(2000,2000);
PVector position = new PVector(0,0);

void setup(){
  size(800, 600);
  pg = createGraphics((int)canvasSize.x, (int)canvasSize.y);
}

void draw(){
  background(255,255,255);
  pg.beginDraw();
  pg.fill(255,0,0);
  pg.rect(0,0,10,5);
  pg.endDraw();
  
  image(pg,mouseX,mouseY);
  noFill();
  stroke(0,0,0);
  rect(mouseX, mouseY,canvasSize.x,canvasSize.y);
}
