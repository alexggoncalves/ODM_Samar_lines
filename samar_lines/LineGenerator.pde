class LineGenerator {
  PVector position;
  PVector direction = new PVector(0,0);
  
  color currentColor;
  float speed = 3;
  
  LineGenerator(float initX, float initY){
    this.position = new PVector(initX,initY);
    this.currentColor = color(255,0,0);
  }
  
  void move(){
    handleKeyPresses();
    
    position.x += direction.x * speed;
    position.y += direction.y * speed;
  }
  
  void drawDebug(){
    fill(255,0,0);
    ellipse(position.x,position.y,10,10);
  }
  
  void render(PGraphics canvas){
    canvas.fill(currentColor);
    canvas.noStroke();
    canvas.ellipse(position.x,position.y,10,10);
  }
  
  void handleKeyPresses(){
    direction.set(0,0);
    if (keyPressed == true) {
      if(key == 'w') direction.y -= 1;
      if(key == 's') direction.y += 1;
      if(key == 'd') direction.x += 1;
      if(key == 'a') direction.x -= 1;
    }
  }
}
