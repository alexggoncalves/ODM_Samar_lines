class Shape {
  PVector position;
  float turnRate = PI/14;
  float initialAngle;
  float angle;
  float turnAmount = 0;
  float totalTurnAmount;

  int radius;
  int ringWidth;
  color shapeColor;

  boolean toDelete = false;

  Shape(PVector position, color shapeColor) {
    this.position = position;
    this.radius = int(random(4,10));
    this.initialAngle = random(0, TWO_PI);
    this.angle = initialAngle;
    this.shapeColor = shapeColor;
    this.totalTurnAmount = ceil(random(1, 4)) * HALF_PI;
    this.ringWidth = this.radius;
  }

  void drawShape(PGraphics canvas) {
    if (turnAmount < totalTurnAmount) {
      canvas.beginDraw();
      float x = position.x + radius * cos(angle);
      float y = position.y + radius * sin(angle);
      canvas.fill(shapeColor);
      canvas.ellipseMode(CENTER);
      canvas.ellipse(x, y, ringWidth, ringWidth);
      canvas.endDraw();

      angle += turnRate;
      turnAmount += abs(turnRate);
    } else {
      toDelete = true;
    }
  }
  
  boolean isToDelete(){
   return toDelete; 
  }
}
