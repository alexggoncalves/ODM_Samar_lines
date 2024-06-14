class Shape{
  PVector position;
  float turnRate = 0.03;
  float initialAngle;
  float angle;
  float turnAmount = 0;
  float totalTurnAmount;
  
  int radius;
  int ringWidth;
  color shapeColor;
  
  boolean toDelete = false;
  
  Shape(PVector position, color shapeColor, int radius){
    this.position = position;
    this.radius = radius;
    this.initialAngle = random(0, TWO_PI);
    this.angle = initialAngle;
    this.shapeColor = shapeColor;
    totalTurnAmount = int(random(1,4)) * HALF_PI;
    ringWidth = 10;
  }
  
  void drawShape(PGraphics canvas){
    if(turnAmount < totalTurnAmount){
      canvas.beginDraw();
      float x = position.x + radius * cos(angle);
      float y = position.y + radius * sin(angle);
      canvas.fill(shapeColor);
      canvas.ellipseMode(CENTER);
      canvas.ellipse(x,y,ringWidth,ringWidth);
    canvas.endDraw();
    
    angle += turnRate;
    turnAmount += abs(turnRate);
    } else {
      toDelete = true;
    }
  }
}
  
